
/**
 * The controller manages the different other classes.
 * Singleton implementation, to make sure we are dealing with only one controller.
 *
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */
 
class Controller
{
  Controller _instance;
  
  Flap[] flaps;
  Segment[] segments;
  SafetyMechanism safetyMechanism;
  boolean halt = false;
   
  public Controller()
  {
    SimpleOpenNI.start();
    
  }
 
  public void init()
  {
    int i = 0;
    for (Segment segment : segments) {
      if (segment.init() == false) {
        println("Can't init segment #" + i);
        exit();
      } 
      i++;
    }
    if (this.safetyMechanism != null) {
      safetyMechanism.init();
    }
  }
 
  public void drawSquare(Square square, float speed)
  {
    for (Flap flap : flaps) {
      if (square.isInside(flap.getPoint())) {
        flap.speed(speed);
      }
    }  
  }
 
 public void update()
  {
    if (this.safetyMechanism != null && this.safetyMechanism.isHalt()) {
      haltAll();
    } else {
      this.fadeAll();
      for (Segment segment : segments) {
        segment.update();
      }
    }
  }
  
  /**
   * Halt all the flaps, without fading out.
   */
  public void haltAll()
  {
    for (Flap flap : flaps) {
      flap.speed(0);
    }
  }
 
  /**
   * Fades all the registered flaps
   */
  private void fadeOutAll()
  {
    for (Flap flap : flaps) {
      flap.fadeOut();
    }
  }
 
  public void registerFlap(Flap flaps) { this.flaps = flaps; }
 
  public void registerSegment(Segment segments) { this.segments = segments }
 
  public void registerSafetyMechanism(SafetyMechanism safetyMechanism) { this safetyMechanism = safetypMechanism; }

  private synchronized static void createInstance()
  {
    if (_instance == null) {
      _instance = new Controller();
    }
  }
  
  public static Controller getInstance () {
    if (_instance == null) {
      this.createInstance();
    }
    return _instance;
  }
}
