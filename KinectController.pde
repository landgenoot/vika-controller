
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
  public int segmentId;
  public SimpleOpenNI kinect;
  public Segment segment;
  Map<Integer, User> users = new HashMap<Integer, User>();
  
  public KinectController(int s, int n, int m)
  {
    this.segmentId = segmentId;
    this.kinect = kinect;
    this.segment = segment;
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
  
  
    
  public void update() 
  {
    kinect.update();
    int[] userList = kinect.getUsers();
    
    User user;
    for (int userId : userList) {
      if (users.get(new Integer(userId)) == null) {
        users.put(new Integer(userId), new User(userId));
      }
      user = users.get(userId);
      user.update(this.kinect);
    } 
  }
}
