import java.util.Map;
import processing.net.*; 

/**
 * This controller is part of a segment, but runs
 * in a different thread, which should make use of the 
 * multithreading capabilities of the computer.
 *
 * There are two types of KinectControllers: Remote and Local
 * Remote KinectControllers act as a client and keep asking for new incoming 
 * messages.
 * Local KinectControllers manage the SimpleOpenNI instance by theirself.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

public abstract class KinectController extends Thread
{
  Map<Integer, User> users = new HashMap<Integer, User>();
  int[] userList = {};
  
  public Map<Integer, User> getUsers()  { return this.users; }
  
  public int[] getUserList() { return this.userList; }
}

public class RemoteKinectController extends KinectController
{
  String address;
  int port;
  Client client;
  
  public RemoteKinectController(String address, int port)
  {
    this.address = address;
    this.port = port;
  }
  
  /**
   * Connects to the remote server, and keeps 
   * waiting for new incoming new incoming data on this
   * thread.
   */
  public void run()
  {
    String data;
    String usersData[];
    String vars[];
    client = new Client(new PApplet(), "145.94.151.132", 5555); 
    User user;
    while (true) {
      if (client.available() > 0) {
        
        data = client.readString();
        usersData = data.split(";");
        for (String userData : usersData) {
          vars = userData.split(",");
          int userId = int(vars[0]);
          
          if (users.get(new Integer(userId)) == null) {
             users.put(new Integer(userId), new User(userId));
          }
          user = users.get(userId);
          user.update(vars);
        }
        println(users.size());
      }
      delay(5);
    }
  }
}
 
public class LocalKinectController extends KinectController
{
  public SimpleOpenNI kinect;
  PImage userImage;
  
  public LocalKinectController(SimpleOpenNI kinect)
  {
    this.kinect = kinect;
  }
  
  public void run()
  {
    kinect.enableDepth();
    kinect.enableUser();
    
    int startLoop = 0;
    while (true) {
      startLoop = millis();
      this.update();
      
      // Run at 15fps
      try {
        int sleeptime = (1000/15)-(millis()-startLoop);
        Thread.sleep(sleeptime > 0 ? sleeptime : 0);
      } catch (InterruptedException e) {}
    }
  }
  
  /**
   * Sends the SimpleOpenNI data to the users' 
   * object, so it is able to set it in its own form
   */
  public void update() 
  {
    kinect.update();
    userImage = kinect.userImage();
    userList = kinect.getUsers();
    
    User user;
    for (int userId : userList) {
      if (users.get(new Integer(userId)) == null) {
        users.put(new Integer(userId), new User(userId));
      }
      user = users.get(userId);
      user.update(this.kinect);
    } 
  }
  
  public PImage userImage() { return this.userImage;  }
}

/**
 * This class wraps the local KinectController and sets up 
 * a server which pushes the changes every frame.
 */
class ServerKinectController extends LocalKinectController
{
  Server server;
  
  public ServerKinectController(SimpleOpenNI kinect, int port)
  {
    super(kinect);
    server = new Server(new PApplet(), port); 
  }
  
  /**
   * Run the same as local, and send the data
   * to the Vika controller
   */
  public void update()
  {
    super.update();
    image(kinect.userImage(), 0, 0);
    User user;
    for (int userId : userList) {
      user = users.get(userId);
      println("write");
      server.write(1);
      server.write(user.serialize());
    }
  }
  
}
