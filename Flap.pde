
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
  private int maxSpeed = 127;
  private float speed;
  private float speedCorrection = 0.75;
  public Point location;
  
  public Flap(int id, Point location)
  {
    this.id = id;
    this.location = location;
  }
  
  public void speed(float speed)
  {
    this.speed = speed;
    this.update();
  }
  
  /**
   * Adjusts the speed to 80% of the current speed, resulting
   * in a fade-out effect.
   */
  public void fadeOut()
  {
    if (this.speed != 0.0) {
      // Turn of motor is speed drops below 0.1
      this.speed = this.speed*0.8 > 0.1 ? this.speed*0.8 : 0.0;
      this.update();
    }
  }
  
  /**
   * Posts the speed on the data bus.
   */
  private void update()
  {
    Serial serial = SingletonSerial.getInstance();
    //Simulation simulation = Simulation.getInstance();
    if (serial != null) {
      int value = int(speed*speedCorrection*maxSpeed);
      
      serial.write((byte)254); // @note: changed due to interference with speed values
      serial.write((byte)this.id);
      serial.write((byte)value);
      serial.write((byte)255);
    }
  }
}
