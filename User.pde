
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
  public int lastUpdate;
  
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
    this.lastUpdate = millis();
  }
  
  public void update(String vars[])
  { 
    if (vars.length == 21) {
  //    this.id = int(vars[0]);
      this.stopcount = int(vars[1]);
      this.leftHand.x = float(vars[2]);
      this.leftHand.y = float(vars[3]);
      this.leftHand.z = float(vars[4]);
      this.leftShoulder.x = float(vars[5]);
      this.leftShoulder.y = float(vars[6]);
      this.leftShoulder.z = float(vars[7]);
      this.rightHand.x = float(vars[8]);
      this.rightHand.y = float(vars[9]);
      this.rightHand.z = float(vars[10]);
      this.rightShoulder.x = float(vars[11]);
      this.rightShoulder.y = float(vars[12]);
      this.rightShoulder.z = float(vars[13]);
      this.head.x = float(vars[14]);
      this.head.y = float(vars[15]);
      this.head.z= float(vars[16]);
      this.rightFoot.x = float(vars[17]);
      this.rightFoot.y = float(vars[18]);
      this.rightFoot.z = float(vars[19]);
      this.previousHeadX = float(vars[20]);
      this.lastUpdate = millis();
    }
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
    return (stopcount > 3 || millis() - lastUpdate > 1000 ? false : true);
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
  
  public String serialize()
  {
    String output = "";
    
    output = 
      this.id + "," + 
      this.stopcount + "," + 
      this.leftHand.x + "," + 
      this.leftHand.y + "," + 
      this.leftHand.z + "," + 
      this.leftShoulder.x + "," + 
      this.leftShoulder.y + "," + 
      this.leftShoulder.z + "," + 
      this.rightHand.x + "," + 
      this.rightHand.y + "," + 
      this.rightHand.z + "," + 
      this.rightShoulder.x + "," + 
      this.rightShoulder.y + "," + 
      this.rightShoulder.z + "," +
      this.head.x + "," + 
      this.head.y + "," + 
      this.head.z + "," +
      this.rightFoot.x + "," + 
      this.rightFoot.y + "," + 
      this.rightFoot.z + "," +
      this.previousHeadX;
      
    return output;
  }
}
