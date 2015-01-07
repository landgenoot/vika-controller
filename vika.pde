
import SimpleOpenNI.*;
import processing.serial.*;

/**
 * Master computer for controlling an interactive environment 
 * using multiple Microsoft Kincts.
 
 Coordinate system in CM:
 
   ----------------------------
   |                          |
y  |  Front of installation   |
^  |                          |
|  ----------------------------
O --> x
 
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */



void setup()
{
  Controller controller = Controller.getInstance();
  
  Segment[] segments = {
    new Segment(new SimpleOpenNI(1, this));
  }
  
  Flap[] flaps = { 
    new Flap(0, new Point(10, 10))
  };
  
  SafetyMechanism safetyMechanism = new SafetyMechanism(new SimpleOpenNI(0, this));
  
  controller.registerSegment(segments);
  controller.registerFlaps(flaps);
  controller.registerSafetyMechanism(safetyMechanism);
}

void draw()
{
  controller.update(); 
}
