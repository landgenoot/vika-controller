
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
  private int id, posX, posY, speed;
  private int maxSpeed = 127;
  private float speedCorrection = 0.75;
  
  public Flap(int id, int posX, int posY)
  {
    this.id = id;
    this.posX = posX;
    this.posY = posY;
  }
  
  public void speed(float speed)
  {
    this.speed = speed;
    this.update();
  }
  
  /**
   * Posts the speed on the data bus.
   */
  private void update()
  {
    Serial serial = SingletonSerial.getInstance();
    int value = speed*speedCorrection*maxSpeed;
    
    serial.write((byte)254); // @note: changed due to interference with speed values
    serial.write((byte)this.id);
    serial.write((byte)value);
    serial.write((byte)255);
  }
  
  public int x() { return posX; }
  
  public int y() { return posY; }
  
}
