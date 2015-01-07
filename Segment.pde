
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
  SimpleOpenNI kinect;
  ArrayList<User> users = new ArrayList<User>();
  Rectangle controllingArea;
  
  /**
   * Constructs a new segment
   * @param kinect a SimpleOpenNI instance
   * @param controllingArea is the space which is controlled by this segment.
   */
  Segment(SimpleOpenNI kinect, Rectangle controllingArea)
  {
    this.kinect = kinect;
    this.controllingArea = controllingArea;
  } 
 
  void update()
  {
    kinect.update();
    int[] userList = kinect.getUsers();
    
    for (int userId : userList) {
      if (users.size() <= userId) {
        users.add(new User(userId));
      }
      
    }
  } 
  
}
