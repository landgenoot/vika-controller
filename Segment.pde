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
  public Rectangle controllingArea;
  Point kinectLocation;
  private KinectController kinectController;
  
  /**
   * Constructs a new segment
   * @param kinect a SimpleOpenNI instance
   * @param controllingArea is the space which is controlled by this segment.
   */
  public Segment(int id, SimpleOpenNI kinect, Rectangle controllingArea, Point kinectLocation)
  {
    this.controllingArea = controllingArea;
    this.kinectLocation = kinectLocation;
    kinectController = new KinectController(kinect);
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
    User user;
    for (int userId : kinectController.getUserList()) {
      user = users.get(userId);
      if (user.isActive()) {
        this.drawBaseRectangle(user);
        this.drawArms(user);
        this.checkJump(user);
      }
    }
  } 
  
  private void checkJump(User user)
  {
    Controller controller = Controller.getInstance();
    
    if (user.rightFoot.y > -950 && controller.effect.type == 0) {
      controller.effect.bottomToTop();
    }
  }
  
  private void drawArms(User user)
  {
    Controller controller = Controller.getInstance();
    
    int projectionHeight = int(min(1.0, (1.2-(user.getHeight()/200))) * this.controllingArea.height);
    int verticalProjectionPosition = int(user.getVerticalPosition() * this.controllingArea.width * -0.75);
    Point rightArm = user.getRightHand();
    Point leftArm = user.getLeftHand();
    
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
  
  private void drawBaseRectangle(User user)
  {
    Controller controller = Controller.getInstance();
    
    int projectionHeight = int(min(1.0, (1.2-(user.getHeight()/200))) * this.controllingArea.height);
    int verticalProjectionPosition = int(user.getVerticalPosition() * this.controllingArea.width * -0.75);
    
    Rectangle userProjection = new Rectangle(
      new Point(verticalProjectionPosition+this.controllingArea.origin.x, 0),
      70,
      projectionHeight
    );
    
    controller.drawRectangle(userProjection, 1);
  }
}
