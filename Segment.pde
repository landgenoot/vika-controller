import java.util.Map;

/**
 * A segment is basically a part of the installation controlled by
 * one kinect. This class will read the kinect and determine which
 * flaps to enable.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Segment
{
  int id;
  SimpleOpenNI kinect;
  Map<Integer, User> users = new HashMap<Integer, User>();
  public Rectangle controllingArea;
  Point kinectLocation;
  
  /**
   * Constructs a new segment
   * @param kinect a SimpleOpenNI instance
   * @param controllingArea is the space which is controlled by this segment.
   */
  public Segment(int id, SimpleOpenNI kinect, Rectangle controllingArea, Point kinectLocation)
  {
    this.kinect = kinect;
    this.controllingArea = controllingArea;
    this.kinectLocation = kinectLocation;
    this.kinect.enableDepth();
    this.kinect.enableUser();
  } 
  
  public boolean init()
  {
    return true;
  }
 
  /**
   * Checks for new users and updates triggers all the logic 
   * of all the users.
   */
  public void update()
  {
    kinect.update();
    image(kinect.userImage(), 640+640*id, 0);
    int[] userList = kinect.getUsers();
    
    User user;
    for (int userId : userList) {
      if (users.get(new Integer(userId)) == null) {
        users.put(new Integer(userId), new User(userId));
      }
      user = users.get(userId);
      user.update(this.kinect);
      this.drawBaseRectangle(user);
    }
  } 
  
  private void drawBaseRectangle(User user)
  {
    Controller controller = Controller.getInstance();
    
    int projectionHeight = int(min(1.0, 1.2-user.getHeight()) * this.controllingArea.height);
    int verticalProjectionPosition = int(user.getVerticalPosition() * this.controllingArea.width);
    
    Rectangle userProjection = new Rectangle(
      new Point(verticalProjectionPosition, 0),
      50,
      projectionHeight
    );
    
    controller.drawRectangle(userProjection, 1);
    if (user.isActive()) {
      //println(userProjection.toString());
      println(user.getHeight());
    }
    
  }
}
