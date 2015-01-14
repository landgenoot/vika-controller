
/**
 * A flap is the entire element which contains the spinning flap,
 * this class will keep track of the properties of this element
 * and handle the communication to the external module.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */
 
class Flap
{
  public int id;
  public int bus;
  private int maxSpeed = 127;
  public float speed;
  public float speedCorrection = 0.75;
  public int lastOnTimestamp; // For fade-out purposes
  public Point location;
  
  public Flap(int id, int bus, Point location)
  {
    this.id = id;
    this.bus = bus;
    this.location = location;
  }
  
  public void speed(float speed)
  {
    if (speed == 1.0) {
      lastOnTimestamp = millis();
    }
    this.speed = speed;
    this.update();
  }
  
  /**
   * Adjusts the speed to 90% of the current speed, resulting
   * in a fade-out effect.
   */
  public void fadeOut()
  {
    if (this.speed != 0.0) {
      int timePassed = millis()-lastOnTimestamp;
      float newSpeed = 1000/(timePassed*5);
      newSpeed = newSpeed > 1.0 ? 1 : newSpeed;
      // Turn of motor if speed drops below 0.3
      this.speed = newSpeed > 0.03 ? newSpeed : 0.0;
      this.update();
    }
  }
  
  public int getMotorValue()
  {
    return int(this.speed*this.speedCorrection*this.maxSpeed);
  }
  
  /**
   * Posts the speed on the data bus.
   */
  private void update()
  {
    Controller controller = Controller.getInstance();
    Message message = controller.message;
    
    Byte[] data = new Byte[4];
    
//    {
//      77,
//      this.id,
//      this.getMotorValue(),
//      70
//    }
    
    message.addToQueue(this.bus, data);
  }
}
