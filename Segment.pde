import java.util.Map;

import java.util.ConcurrentModificationException;

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
  public Rectangle controllingArea;
  Point kinectLocation;
  private KinectController kinectController;
  
  /**
   * Constructs a new segment with a local kinect
   * @param kinect a SimpleOpenNI instance
   * @param controllingArea is the space which is controlled by this segment.
   */
  public Segment(int id, SimpleOpenNI kinect, Rectangle controllingArea, Point kinectLocation)
  {
    this.controllingArea = controllingArea;
    this.kinectLocation = kinectLocation;
    kinectController = new LocalKinectController(kinect);
    kinectController.start();
  } 
  
  
  /**
   * Constructs a new segment with a remote kinect
   * @param String address
   * @param int port
   * @param controllingArea is the space which is controlled by this segment.
   */
  public Segment(int id, String address, int port, Rectangle controllingArea, Point kinectLocation)
  {
    this.controllingArea = controllingArea;
    this.kinectLocation = kinectLocation;
    kinectController = new RemoteKinectController(address, port);
    kinectController.start();
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
    Map<Integer, User> users = kinectController.getUsers();
    try {
      for (User user : users.values()) {
        if (user.isActive()) {
          this.drawBaseRectangle(user);
          this.drawArms(user);
//          this.checkJump(user);
        }
      }
    } catch (ConcurrentModificationException e) {}
  } 
  
  private void checkJump(User user)
  {
    Controller controller = Controller.getInstance();
//    println(user.rightFoot.y);
    if (user.rightFoot.y > -500 && controller.effect.type == 0) {
      controller.effect.bottomToTop();
    }
  }
  
  private void drawArms(User user)
  {
    Controller controller = Controller.getInstance();
    
//    int projectionHeight = int(min(1.0, (1.2-(user.getHeight()/200))) * this.controllingArea.height);
    int projectionHeight = int(min(1.0, (1.3-(user.getHeight()/150))) * this.controllingArea.height); 
    int verticalProjectionPosition = int(user.getVerticalPosition() * this.controllingArea.width * -0.75);
    Point rightArm = user.getRightHand();
    Point leftArm = user.getLeftHand();
    
    if (abs(rightArm.x - leftArm.x) > 40) {
    
      controller.drawLine(
        new Line(
          new Point(verticalProjectionPosition+this.controllingArea.origin.x+35,projectionHeight), 
          new Point(verticalProjectionPosition+this.controllingArea.origin.x+rightArm.x*2,projectionHeight + rightArm.y*3),
          30
        )
      );
      controller.drawLine(
        new Line(
          new Point(verticalProjectionPosition+this.controllingArea.origin.x+35,projectionHeight), 
          new Point(verticalProjectionPosition+this.controllingArea.origin.x+leftArm.x*2,projectionHeight + leftArm.y*3),
          30
        )
      );
    }
  }
  
  private void drawBaseRectangle(User user)
  {
    Controller controller = Controller.getInstance();
    controller.effect.lastSeenUser = millis();
    int projectionHeight = int(min(1.0, (1.3-(user.getHeight()/150))) * this.controllingArea.height);    
    int verticalProjectionPosition = int(user.getVerticalPosition() * this.controllingArea.width * -1.2);
   
    if (user.getHeight() > 100) { 
      Rectangle userProjection = new Rectangle(
        new Point(verticalProjectionPosition+this.controllingArea.origin.x, 0),
        70,
        projectionHeight
      );
      
      controller.drawRectangle(userProjection, 1);
    }
  }
}

