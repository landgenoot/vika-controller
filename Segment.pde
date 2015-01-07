
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
  Segment(int id, SimpleOpenNI kinect, Rectangle controllingArea)
  {
    this.kinect = kinect;
    this.controllingArea = controllingArea;
    this.kinect.enableDepth();
    this.kinect.enableUser();
    
  } 
 
  /**
   * Checks for new users and updates triggers all the logic 
   * of all the users.
   */
  void update()
  {
    kinect.update();
    image(kinect.userImage(), 
    int[] userList = kinect.getUsers();
    
    for (int userId : userList) {
      try {
        user = users.get(userId);
      } catch (IndexOutOfBoundsException e) {
        users.add(i, new User(userId));
        user = users.get(userId);
      }
      user.update(this.kinect);
    }
  } 
}
