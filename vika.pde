
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
Simulation simulation;

int x = 0;
void setup()
{
  controller = Controller.getInstance();
  simulation = new Simulation(75, 525, 1.5);
  
  //SingletonSerial.createInstance(this, 0);
  
  Segment[] segments = {
    new Segment(0, new SimpleOpenNI(0, this),
      new Rectangle(
        new Point(0, 0),
        123, 
        280
      ),
      new Point(40, 140)),
    new Segment(1, new SimpleOpenNI(0, this),
      new Rectangle(
        new Point(123, 0),
        108, 
        280
      ),
      new Point(40, 140)),
    new Segment(3, new SimpleOpenNI(0, this),
      new Rectangle(
        new Point(231, 0),
        97, 
        280
      ),
      new Point(40, 140))
  };
  
  size(640, 750);
  stroke(0,0,255);
  strokeWeight(3);
  smooth(); 
  
  Flap[] flaps = { 
    new Flap(0,  new Point(15, 20 + (30*6))),
    new Flap(1,  new Point(15, 20 + (30*5))),
    new Flap(2,  new Point(15, 20 + (30*3))),
    new Flap(3,  new Point(15, 20 + (30*2))),
    new Flap(4,  new Point(15, 20 + (30*1))),
    new Flap(5,  new Point(15 + (27*1), 35 + (30*7))),
    new Flap(6,  new Point(15 + (27*1), 35 + (30*6))),
    new Flap(7,  new Point(15 + (27*1), 35 + (30*5))),
    new Flap(8,  new Point(15 + (27*1), 35 + (30*4))),
    new Flap(9,  new Point(15 + (27*1), 35 + (30*3))),
    new Flap(10, new Point(15 + (27*1), 35 + (30*2))),
    new Flap(11, new Point(15 + (27*1), 35 + (30*1))),
    new Flap(12, new Point(15 + (27*2), 20 + (30*7))),
    new Flap(13, new Point(15 + (27*2), 20 + (30*6))),
    new Flap(14, new Point(15 + (27*2), 20 + (30*4))),
    new Flap(15, new Point(15 + (27*2), 20 + (30*3))),
    new Flap(16, new Point(15 + (27*2), 20 + (30*2))),
    new Flap(17, new Point(15 + (27*2), 20 + (30*1))),
    new Flap(18, new Point(15 + (27*3), 35 + (30*6))),
    new Flap(19, new Point(15 + (27*3), 35 + (30*5))),
    new Flap(20, new Point(15 + (27*3), 35 + (30*4))),
    new Flap(21, new Point(15 + (27*3), 35 + (30*3))),
    new Flap(22, new Point(15 + (27*3), 35 + (30*2))),
    new Flap(23, new Point(15 + (27*3), 35 + (30*1))),
    new Flap(24, new Point(15 + (27*4), 20 + (30*8))),
    new Flap(25, new Point(15 + (27*4), 20 + (30*7))),
    new Flap(26, new Point(15 + (27*4), 20 + (30*6))),
    new Flap(27, new Point(15 + (27*4), 20 + (30*5))),
    new Flap(28, new Point(15 + (27*4), 20 + (30*4))),
    new Flap(29, new Point(15 + (27*4), 20 + (30*3))),
    new Flap(30, new Point(15 + (27*4), 20 + (30*2))),
    new Flap(31, new Point(15 + (27*4), 20 + (30*1))),
    new Flap(32, new Point(15 + (27*5), 35 + (30*7))),
    new Flap(33, new Point(15 + (27*5), 35 + (30*6))),
    new Flap(34, new Point(15 + (27*5), 35 + (30*5))),
    new Flap(35, new Point(15 + (27*5), 35 + (30*4))),
    new Flap(36, new Point(15 + (27*5), 35 + (30*3))),
    new Flap(37, new Point(15 + (27*5), 35 + (30*2))),
    new Flap(38, new Point(15 + (27*5), 35 + (30*1))),
    new Flap(39, new Point(15 + (27*6), 20 + (30*8))),
    new Flap(40, new Point(15 + (27*6), 20 + (30*7))),
    new Flap(41, new Point(15 + (27*6), 20 + (30*6))),
    new Flap(42, new Point(15 + (27*6), 20 + (30*4))),
    new Flap(43, new Point(15 + (27*6), 20 + (30*3))),
    new Flap(44, new Point(15 + (27*6), 20 + (30*2))),
    new Flap(45, new Point(15 + (27*6), 20 + (30*1))),
    new Flap(46, new Point(15 + (27*7), 35 + (30*7))),
    new Flap(47, new Point(15 + (27*7), 35 + (30*6))),
    new Flap(48, new Point(15 + (27*7), 35 + (30*5))),
    new Flap(49, new Point(15 + (27*7), 35 + (30*4))),
    new Flap(50, new Point(15 + (27*7), 35 + (30*3))),
    new Flap(51, new Point(15 + (27*7), 35 + (30*2))),
    new Flap(52, new Point(15 + (27*7), 35 + (30*1))),
    new Flap(53, new Point(15 + (27*8), 20 + (30*7))),
    new Flap(54, new Point(15 + (27*8), 20 + (30*6))),
    new Flap(55, new Point(15 + (27*8), 20 + (30*5))),
    new Flap(56, new Point(15 + (27*8), 20 + (30*4))),
    new Flap(57, new Point(15 + (27*8), 20 + (30*3))),
    new Flap(58, new Point(15 + (27*8), 20 + (30*2))),
    new Flap(59, new Point(15 + (27*8), 20 + (30*1))),
    new Flap(60, new Point(15 + (27*9), 35 + (30*7))),
    new Flap(61, new Point(15 + (27*9), 35 + (30*6))),
    new Flap(62, new Point(15 + (27*9), 35 + (30*5))),
    new Flap(63, new Point(15 + (27*9), 35 + (30*4))),
    new Flap(64, new Point(15 + (27*9), 35 + (30*3))),
    new Flap(65, new Point(15 + (27*9), 35 + (30*2))),
    new Flap(66, new Point(15 + (27*9), 35 + (30*1))),
    new Flap(67, new Point(15 + (27*10), 20 + (30*7))),
    new Flap(68, new Point(15 + (27*10), 20 + (30*6))),
    new Flap(69, new Point(15 + (27*10), 20 + (30*4))),
    new Flap(70, new Point(15 + (27*10), 20 + (30*3))),
    new Flap(71, new Point(15 + (27*10), 20 + (30*2))),
    new Flap(72, new Point(15 + (27*10), 20 + (30*1))),
    new Flap(73, new Point(15 + (27*11), 35 + (30*7))),
    new Flap(74, new Point(15 + (27*11), 35 + (30*6))),
    new Flap(75, new Point(15 + (27*11), 35 + (30*4))),
    new Flap(76, new Point(15 + (27*11), 35 + (30*3))),
    new Flap(77, new Point(15 + (27*11), 35 + (30*1))),
  };
  
  //SafetyMechanism safetyMechanism = new SafetyMechanism(new SimpleOpenNI(0, this));
  
  controller.registerSegments(segments);
  controller.registerFlaps(flaps);
  //controller.registerSafetyMechanism(safetyMechanism);
}

void draw()
{
  //controller.flaps[int(random(77))].speed(1);
  simulation.update();
  controller.update(); 
  delay(10);
  
  
  controller.drawRectangle(
    new Rectangle(
      new Point(0,x),
      320,
      20
    ),
    1
  );
  x = x+5;
}

void onNewUser(SimpleOpenNI curcam1, int userId)
{
  curcam1.startTrackingSkeleton(userId);
}

