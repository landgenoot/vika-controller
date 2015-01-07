
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
  public int stopcount;
  public PVector leftHand;
  public PVector leftShoulder;
  public PVector rightHand;
  public PVector rightShoulder;
  public PVector head;
  
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
  }
  
  /**
   * Fetches the position data of a couple of skeleton joints and
   * stores them in its own properties.
   *
   * @param SimpleOpenNI kinect from the segment the user is in.
   */
  private void updatePositions(SimpleOpenNI kinect)
  {
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
  }
}

