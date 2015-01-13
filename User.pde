
/**
 * Object is updated continiously, provides data about the people
 * visible in a segment. Is updated by the Segment class.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */
 
class User
{
  public int id;
  private int stopcount = 5;
  public PVector leftHand = new PVector();
  public PVector leftShoulder = new PVector();
  public PVector rightHand = new PVector();
  public PVector rightShoulder = new PVector();
  public PVector head = new PVector();
  public PVector rightFoot = new PVector();
  public float previousHeadX;
  
  public User(int id)
  {
    this.id = id;
  }
  
  /**
   * Method runs every frame.
   */
  public void update(SimpleOpenNI kinect)
  {
    this.updatePositions(kinect);  
    this.updateStopcount();
  }
  
  /**
   * Returns length of the user in CM
   */
  public float getHeight()
  {
    return (head.y/10)-(rightFoot.y/10);
  }
  
  public float getVerticalPosition()
  {
    return head.x/1000;
  }
  
  public Point getRightHand()
  {
    int dx = int(leftShoulder.x/10 - leftHand.x/10);
    int dy = int(leftHand.y/10 - leftShoulder.y/10);
    return new Point(dx, dy);
  }
  
  public Point getLeftHand()
  {
    int dx = int(rightShoulder.x/10 - rightHand.x/10);
    int dy = int(rightHand.y/10 - rightShoulder.y/10);
    return new Point(dx, dy);
  }
  
  public void updateStopcount()
  {
    if (previousHeadX == head.x)
    {
      stopcount++;
    } else {
      stopcount = 0;
    }
  }
  
  /**
   * Returns false is the user hasn't moved for 3 frames.
   */
  public boolean isActive()
  {
    return (stopcount > 3 ? false : true);
  }
  
  /**
   * Fetches the position data of a couple of skeleton joints and
   * stores them in its own properties.
   *
   * @param SimpleOpenNI kinect from the segment the user is in.
   */
  private void updatePositions(SimpleOpenNI kinect)
  {
    previousHeadX = head.x;
    kinect.getJointPositionSkeleton(
      this.id,
      SimpleOpenNI.SKEL_LEFT_HAND,
      this.leftHand
    );
    kinect.getJointPositionSkeleton(
      this.id,
      SimpleOpenNI.SKEL_LEFT_SHOULDER,
      this.leftShoulder
    );
    kinect.getJointPositionSkeleton(
      this.id,
      SimpleOpenNI.SKEL_RIGHT_HAND,
      this.rightHand
    );
    kinect.getJointPositionSkeleton(
      this.id,
      SimpleOpenNI.SKEL_RIGHT_SHOULDER,
      this.rightShoulder
    );
    kinect.getJointPositionSkeleton(
      this.id,
      SimpleOpenNI.SKEL_HEAD,
      this.head
    );
    kinect.getJointPositionSkeleton(
      this.id,
      SimpleOpenNI.SKEL_RIGHT_FOOT,
      this.rightFoot
    );
  }
}

