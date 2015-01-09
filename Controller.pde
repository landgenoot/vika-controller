
/**
 * The controller manages the different other classes.
 * Singleton implementation, to make sure we are dealing with only one controller.
 *
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */
 
static class Controller
{
  static Controller _instance;
  
  public Flap[] flaps;
  public Segment[] segments;
  SafetyMechanism safetyMechanism;
  Simulation simulation;
  boolean halt = false;
  boolean fade = false;
   
  private Controller()
  {
    SimpleOpenNI.start();
  }
 
  public void init()
  {
    int i = 0;
    for (Segment segment : segments) {
      if (segment.init() == false) {
        println("Can't init segment #" + i);
      } 
      i++;
    }
    if (this.safetyMechanism != null) {
      safetyMechanism.init();
    }
  }
 
  public void drawRectangle(Rectangle rectangle, float speed)
  {
    for (Flap flap : flaps) {
      if (rectangle.isInside(flap.location)) {
        flap.speed(speed);
      }
    }  
  }
  
  public PGraphics drawText(String text, PGraphics pg, PFont font, int x)
  {
    pg.beginDraw();
    pg.smooth();
    pg.background(0);
    pg.fill(255);
    pg.textFont(font, 250);
    pg.text(text, x, 230);
    pg.endDraw();
    
    for (Flap flap : flaps) {
      if (pg.get(flap.location.x, pg.height-flap.location.y) == -1) {
        flap.speed(1);
      }
    }
    return pg;
  }
    
 
 public void update()
  {
    if (this.safetyMechanism != null && this.safetyMechanism.isHalt()) {
      haltAll();
    } else {
      this.fadeOutAll();
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
      if (fade) {
        flap.fadeOut();
      } else {
        flap.speed(0);
      }
    }
  }
 
  public void registerFlaps(Flap flaps[]) { this.flaps = flaps; }
 
  public void registerSegments(Segment segments[]) { this.segments = segments; }
 
  public void registerSafetyMechanism(SafetyMechanism safetyMechanism) { this.safetyMechanism = safetyMechanism; }

  private static void createInstance()
  {
    if (_instance == null) {
      _instance = new Controller();
    }
  }
  
  public static Controller getInstance () {
    if (_instance == null) {
      createInstance();
    }
    return _instance;
  }
}
