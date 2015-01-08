
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
  ArrayList<User> users = new ArrayList<User>();
  Rectangle controllingArea;
  
  /**
   * Constructs a new segment
   * @param kinect a SimpleOpenNI instance
   * @param controllingArea is the space which is controlled by this segment.
   */
  public Segment(int id, SimpleOpenNI kinect, Rectangle controllingArea)
  {
    this.kinect = kinect;
    this.controllingArea = controllingArea;
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
    image(kinect.userImage(), 640*id, 0);
    int[] userList = kinect.getUsers();
    
    User user;
    for (int userId : userList) {
      try {
        user = users.get(userId);
      } catch (IndexOutOfBoundsException e) {
        users.add(userId, new User(userId));
        user = users.get(userId);
      }
      user.update(this.kinect);
      this.drawBaseRectangle(user);
    }
  } 
  
  private void drawBaseRectangle(User user)
  {
    
    
  }
}
