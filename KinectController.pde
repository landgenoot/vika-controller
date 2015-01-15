
/**
 * This controller is part of a segment, but runs
 * in a different thread, which should make use of the 
 * multithreading capabilities of the computer.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */
 
public class KinectController extends Thread
{
  public SimpleOpenNI kinect;
  Map<Integer, User> users = new HashMap<Integer, User>();
  int[] userList = {};
  PImage userImage;
  
  public KinectController(SimpleOpenNI kinect)
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
  
  public Map<Integer, User> getUsers()  { return this.users; }
  
  public int[] getUserList() { return this.userList; }
  
  public PImage userImage() { return this.userImage;  }
}
