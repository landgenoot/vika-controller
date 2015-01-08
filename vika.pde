
import SimpleOpenNI.*;
import processing.serial.*;
import javax.swing.*; 

/**
 * Master computer for controlling an interactive environment 
 * using multiple Microsoft Kinects.
 
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

Controller controller;

void setup()
{
  controller = Controller.getInstance();
  SingletonSerial.createInstance(this, 0);
  
  Segment[] segments = {
    new Segment(0, new SimpleOpenNI(0, this),
      new Rectangle(
        new Point(0, 0),
        110, 
        210
      ),
      new Point(40, 140))
  };
  
  size(640 + 640*segments.length, 480);
  background(50,50,50);
  stroke(0,0,255);
  strokeWeight(3);
  smooth(); 
  
  Flap[] flaps = { 
    new Flap(0, new Point(15, 140)),
    new Flap(1, new Point(15, 70)),
    new Flap(2, new Point(55, 210)),
    new Flap(3, new Point(55, 175)),
    new Flap(4, new Point(55, 105)),
    new Flap(5, new Point(55, 35)),
    new Flap(6, new Point(95, 140)),
    new Flap(7, new Point(95, 70))
  };
  
  //SafetyMechanism safetyMechanism = new SafetyMechanism(new SimpleOpenNI(0, this));
  
  controller.registerSegments(segments);
  controller.registerFlaps(flaps);
  //controller.registerSafetyMechanism(safetyMechanism);
}

void draw()
{
  controller.update(); 
}

void onNewUser(SimpleOpenNI curcam1, int userId)
{
  curcam1.startTrackingSkeleton(userId);
}
