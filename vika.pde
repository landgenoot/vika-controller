
import SimpleOpenNI.*;
import processing.serial.*;

/**
 * Master computer for controlling an interactive environment 
 * using multiple Microsoft Kinects.
 
 Coordinate system Vika in CM:
 
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

// Slave = kinect host only
final String mode = "master";

void setup()
{
  
  if (mode == "slave") {
      
    size(640, 480);
    SimpleOpenNI kinect = new SimpleOpenNI(0, this);
    
    KinectController serverKinectController = new ServerKinectController(kinect, 5555);
    serverKinectController.start();
    
  } else if (mode == "master") {
    
    size(640, 750);
    stroke(0,0,255);
    strokeWeight(3);
    smooth(); 
    
    controller = Controller.getInstance();
    simulation = new Simulation(75, 525, 1.5);
    
    Serial[] serialInstances = {
      new Serial(this, "COM5", 250000)
    };
    
    Message message = new Message(serialInstances);
    
    Segment[] segments = {
      new Segment(0, new SimpleOpenNI(0, this),
        new Rectangle(
          new Point(20, 0),
          108, 
          380
        ),
        new Point(40, 140)),
      new Segment(1, new SimpleOpenNI(1, this),
        new Rectangle(
          new Point(210, 0),
          108, 
          380
        ),
        new Point(40, 140)),
    };
    
    Flap[] flaps = { 
      new Flap(0,  0, new Point(15, 20 + (30*6))),
      new Flap(1,  0, new Point(15, 20 + (30*5))),
      new Flap(2,  0, new Point(15, 20 + (30*3))),
      new Flap(3,  0, new Point(15, 20 + (30*2))),
      new Flap(4,  0, new Point(15, 20 + (30*1))),
      new Flap(5,  0, new Point(15 + (27*1), 35 + (30*7))),
      new Flap(6,  0, new Point(15 + (27*1), 35 + (30*6))),
      new Flap(7,  0, new Point(15 + (27*1), 35 + (30*5))),
      new Flap(8,  0, new Point(15 + (27*1), 35 + (30*4))),
      new Flap(9,  0, new Point(15 + (27*1), 35 + (30*3))),
      new Flap(10, 0, new Point(15 + (27*1), 35 + (30*2))),
      new Flap(11, 0, new Point(15 + (27*1), 35 + (30*1))),
      new Flap(12, 0, new Point(15 + (27*2), 20 + (30*7))),
      new Flap(13, 0, new Point(15 + (27*2), 20 + (30*6))),
      new Flap(14, 0, new Point(15 + (27*2), 20 + (30*4))),
      new Flap(15, 0, new Point(15 + (27*2), 20 + (30*3))),
      new Flap(16, 0, new Point(15 + (27*2), 20 + (30*2))),
      new Flap(17, 0, new Point(15 + (27*2), 20 + (30*1))),
      new Flap(18, 0, new Point(15 + (27*3), 35 + (30*6))),
      new Flap(19, 0, new Point(15 + (27*3), 35 + (30*5))),
      new Flap(20, 0, new Point(15 + (27*3), 35 + (30*4))),
      new Flap(21, 0, new Point(15 + (27*3), 35 + (30*3))),
      new Flap(22, 0, new Point(15 + (27*3), 35 + (30*2))),
      new Flap(23, 0, new Point(15 + (27*3), 35 + (30*1))),
      new Flap(24, 0, new Point(15 + (27*4), 20 + (30*8))),
      new Flap(25, 0, new Point(15 + (27*4), 20 + (30*7))),
      new Flap(26, 0, new Point(15 + (27*4), 20 + (30*6))),
      new Flap(27, 0, new Point(15 + (27*4), 20 + (30*5))),
      new Flap(28, 0, new Point(15 + (27*4), 20 + (30*4))),
      new Flap(29, 0, new Point(15 + (27*4), 20 + (30*3))),
      new Flap(30, 0, new Point(15 + (27*4), 20 + (30*2))),
      new Flap(31, 0, new Point(15 + (27*4), 20 + (30*1))),
      new Flap(32, 0, new Point(15 + (27*5), 35 + (30*7))),
      new Flap(33, 0, new Point(15 + (27*5), 35 + (30*6))),
      new Flap(34, 0, new Point(15 + (27*5), 35 + (30*5))),
      new Flap(35, 0, new Point(15 + (27*5), 35 + (30*4))),
      new Flap(36, 0, new Point(15 + (27*5), 35 + (30*3))),
      new Flap(37, 0, new Point(15 + (27*5), 35 + (30*2))),
      new Flap(38, 0, new Point(15 + (27*5), 35 + (30*1))),
      new Flap(39, 0, new Point(15 + (27*6), 20 + (30*8))),
      new Flap(40, 0, new Point(15 + (27*6), 20 + (30*7))),
      new Flap(41, 0, new Point(15 + (27*6), 20 + (30*6))),
      new Flap(42, 0, new Point(15 + (27*6), 20 + (30*4))),
      new Flap(43, 0, new Point(15 + (27*6), 20 + (30*3))),
      new Flap(44, 0, new Point(15 + (27*6), 20 + (30*2))),
      new Flap(45, 0, new Point(15 + (27*6), 20 + (30*1))),
      new Flap(46, 0, new Point(15 + (27*7), 35 + (30*7))),
      new Flap(47, 0, new Point(15 + (27*7), 35 + (30*6))),
      new Flap(48, 0, new Point(15 + (27*7), 35 + (30*5))),
      new Flap(49, 0, new Point(15 + (27*7), 35 + (30*4))),
      new Flap(50, 0, new Point(15 + (27*7), 35 + (30*3))),
      new Flap(51, 0, new Point(15 + (27*7), 35 + (30*2))),
      new Flap(52, 0, new Point(15 + (27*7), 35 + (30*1))),
      new Flap(53, 0, new Point(15 + (27*8), 20 + (30*7))),
      new Flap(54, 0, new Point(15 + (27*8), 20 + (30*6))),
      new Flap(55, 0, new Point(15 + (27*8), 20 + (30*5))),
      new Flap(56, 0, new Point(15 + (27*8), 20 + (30*4))),
      new Flap(57, 0, new Point(15 + (27*8), 20 + (30*3))),
      new Flap(58, 0, new Point(15 + (27*8), 20 + (30*2))),
      new Flap(59, 0, new Point(15 + (27*8), 20 + (30*1))),
      new Flap(60, 0, new Point(15 + (27*9), 35 + (30*7))),
      new Flap(61, 0, new Point(15 + (27*9), 35 + (30*6))),
      new Flap(62, 0, new Point(15 + (27*9), 35 + (30*5))),
      new Flap(63, 0, new Point(15 + (27*9), 35 + (30*4))),
      new Flap(64, 0, new Point(15 + (27*9), 35 + (30*3))),
      new Flap(65, 0, new Point(15 + (27*9), 35 + (30*2))),
      new Flap(66, 0, new Point(15 + (27*9), 35 + (30*1))),
      new Flap(67, 0, new Point(15 + (27*10), 20 + (30*7))),
      new Flap(68, 0, new Point(15 + (27*10), 20 + (30*6))),
      new Flap(69, 0, new Point(15 + (27*10), 20 + (30*4))),
      new Flap(70, 0, new Point(15 + (27*10), 20 + (30*3))),
      new Flap(71, 0, new Point(15 + (27*10), 20 + (30*2))),
      new Flap(72, 0, new Point(15 + (27*10), 20 + (30*1))),
      new Flap(73, 0, new Point(15 + (27*11), 35 + (30*7))),
      new Flap(74, 0, new Point(15 + (27*11), 35 + (30*6))),
      new Flap(75, 0, new Point(15 + (27*11), 35 + (30*4))),
      new Flap(76, 0, new Point(15 + (27*11), 35 + (30*3))),
      new Flap(77, 0, new Point(15 + (27*11), 35 + (30*1))),
    };
    
    Effect effect = new Effect();
    
    //SafetyMechanism safetyMechanism = new SafetyMechanism(new SimpleOpenNI(0, this));
    
    controller.registerSegments(segments);
    controller.registerFlaps(flaps);
    controller.registerEffect(effect);
    controller.registerSimulation(simulation);
    controller.registerMessage(message);
    //controller.registerSafetyMechanism(safetyMechanism);
    controller.init(330, 280);
  }
}

void draw()
{
  if (mode == "master") {
   // println(frameRate);
    simulation.update();
    controller.update(); 
  }
}

void onNewUser(SimpleOpenNI curcam1, int userId)
{
  curcam1.startTrackingSkeleton(userId);
}

