
import SimpleOpenNI.*;
import processing.serial.*;

/**
 * Master computer for controlling an interactive environment 
 * using multiple Microsoft Kincts.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2014
 */

SimpleOpenNI cam1;
SimpleOpenNI safetyCam;

void setup()
{
  
  Controller controller = new Controller();
  
  Segment[] segments = {
    new Segment(new SimpleOpenNI(1, this));
  }
  
  Flap[] flaps = { 
    new Flap(0, 10, 10)
  };
  
  controller.registerSegment(segments);
  controller.registerFlaps(flaps);
  
}
