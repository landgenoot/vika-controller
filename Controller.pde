
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
  public SafetyMechanism safetyMechanism;
  public Effect effect;
  public Simulation simulation;
  public Message message;
  public int width, height;
  public boolean halt = false;
  private int  frameCount = 0; 
   
  Controller()
  {
    SimpleOpenNI.start();
  }
 
  public void init(int width, int height)
  {
    this.width = width;
    this.height = height;
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
 
  /**
   * Draws a line over the installation, from point to point.
   * @param Point a
   * @param Point b
   * @param int thickness (in CM)
   */
  public void drawLine(Line line)
  {
     for (Flap flap : flaps) {
       
       if ( line.isOnLine(flap.location)) {
         flap.speed(1);
       }
     }
  }
 
  public void update()
  {
    frameCount++;
    if (frameCount % 30 == 0) {
//      println("reset");
        byte[] resetAll = {
          (byte)77,
          (byte)255,
          (byte)0,
          (byte)70
        };
        message.serialInstances[0].write(
          resetAll
        );
      try {
        Thread.sleep(1);
      } catch (InterruptedException e) {}
        message.serialInstances[0].write(
          resetAll
        );
      try {
        Thread.sleep(1);
      } catch (InterruptedException e) {}
    }
    if (frameCount % 600 == 0) {
      this.effect.randomFlap();
    }
    if (this.safetyMechanism != null && this.safetyMechanism.isHalt()) {
      haltAll();
    } else {
      this.fadeOutAll();
      for (Segment segment : segments) {
        segment.update();
      }
    }
    effect.update();
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
  
//  public void jumpEffect(int duration) {
//    int delay = (duration/this.height);
//    for (int i = 0; i < this.height; i++) {
//      this.drawRectangle(
//        new Rectangle(
//          new Point(0, i),
//          this.height/6,
//          this.width
//        ),
//        1
//      );
//      try {
//        Thread.sleep(delay); // Delay doesn't work in a static class
//      } catch (InterruptedException e) {}
//        
//    }
//  }
 
  public void registerFlaps(Flap flaps[]) { this.flaps = flaps; }
 
  public void registerSegments(Segment segments[]) { this.segments = segments; }
  
  public void registerEffect(Effect effect) { this.effect = effect; }
  
  public void registerSimulation(Simulation simulation) { this.simulation = simulation; }
 
  public void registerSafetyMechanism(SafetyMechanism safetyMechanism) { this.safetyMechanism = safetyMechanism; }
  
  public void registerMessage(Message message) { this.message = message; }
  
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
