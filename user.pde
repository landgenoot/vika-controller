import processing.serial.*;

/**
 * Master computer for controlling an interactive environment using a kinect.
 * Based on SimpleOpenNI User Test
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2014
 */

import SimpleOpenNI.*;

SimpleOpenNI  cam1;
SimpleOpenNI  safetyCam;

color[]       userClr = new color[]{ color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();                                   
PVector com2d = new PVector();   
Serial serial;
int customSpeeds[] = new int[10];
int gestureTimestamp = 0;
boolean halt = false;

int haltcount1 = 0;
int haltcount2 = 0;

// All location data of all users is stored here
PVector leftHand[] = new PVector[100];
PVector leftShoulder[] = new PVector[100];
PVector rightHand[] = new PVector[100];
PVector rightShoulder[] = new PVector[100];
PVector head[] = new PVector[100];
int stopcount[] = new int[100];
int defaultSpeed = 55;

void setup()
{
  // Settings
  customSpeeds[1] = 35;
  customSpeeds[2] = 69;
  
  SimpleOpenNI.start();
  
  size(1280,480);
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  serial = new Serial(this, portName, 9600);
  
  cam1       = new SimpleOpenNI(0, this);
  safetyCam  = new SimpleOpenNI(1, this);
  
  if(cam1.isInit() == false || safetyCam.isInit() == false)
  {
     println("Can't init SimpleOpenNI, need at least two cams!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  cam1.enableDepth();
   
  // enable skeleton generation for all joints
  cam1.enableUser();
  
  safetyCam.setMirror(true);
  safetyCam.enableDepth();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();  
}

void draw()
{
  // update the cam
  cam1.update();
  
  doSafetyCheck();
  
  image(cam1.userImage(),0,0);
  image(safetyCam.depthImage(), 640, 0);
  
  // draw the skeleton if it's available
  int[] userList = cam1.getUsers();
  
  for(int i=0;i<userList.length;i++) {
    if(cam1.isTrackingSkeleton(userList[i])) {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }      
      
    // draw the center of mass
    if(cam1.getCoM(userList[i],com)) {
      cam1.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();
      
      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }
  }   
 
  logic(); 
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  float oldLeftHand = 0;
  try {
    oldLeftHand = leftHand[userId].x;
  } catch (Exception e) {}
    
  leftHand[userId] = new PVector();
  leftShoulder[userId] = new PVector();
  rightHand[userId] = new PVector();
  rightShoulder[userId] = new PVector();
  head[userId] = new PVector();
  
  cam1.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand[userId]);
  cam1.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,leftShoulder[userId]);
  cam1.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand[userId]);
  cam1.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder[userId]);
  cam1.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,head[userId]);
  
  if (oldLeftHand == leftHand[userId].x) {
    stopcount[userId]++;
  } else {
    stopcount[userId] = 0;
  }
  
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  cam1.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  cam1.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  cam1.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  cam1.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  cam1.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  cam1.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

void onNewUser(SimpleOpenNI curcam1, int userId)
{
  curcam1.startTrackingSkeleton(userId);
}

/**
 * Returns relative length of user, based on the y-coördinate of the head.
 * @return int size
 */
int height(int userId)
{
  int smallestUserLength =-1;
  PVector headUser = head[userId];
  try {
    smallestUserLength = (int)headUser.y;
  } catch(Exception e) {
    return -1;
  }
  return smallestUserLength;
}

/**
 * Returns distance of user, based on the z-coördinate of the head.
 * @return int distance
 */
int distance(int userId)
{
  int distance = -1;
  PVector headUser = head[userId];
  try {
    distance = (int)headUser.z;
  } catch(Exception e) {
    return -1;
  }
  return distance;
}

/**
 * Returns the segement the user is in.
 * @param int userId
 */
int segment(int userId)
{
  if (userId == -1) {
    return -1;
  }
  PVector headUser = head[userId];
  int segment = -1;
    try {
    if (headUser.x < -400) {
      segment = 1;
    } else if (headUser.x < 400) {
      segment = 2;
    } else {
      segment = 3;
    }
    println("segment: "+segment);
  } catch (Exception e) {
    segment = 0;
  }
  return segment;
}

/**
 * Determines the distance between the shoulder and the hand on the x-axis.
 * @param int userId
 */
int leftHandRaise(int userId) 
{
  if (userId == -1) {
    return -1;
  }
  int value = -1;
  PVector leftHandUser      = leftHand[userId];
  PVector leftShoulderUser  = leftShoulder[userId];
  try {
    if (leftHandUser.y > leftShoulderUser.y) {
      value = 500;
    } else {
      value = abs((int)leftHandUser.x - (int)leftShoulderUser.x);
    }
    println("leftArmRaise: "+value);
  } catch (Exception e) {
    value = 0;
  }
  return value;
}


/**
 * Determines the distance between the shoulder and the hand on the x-axis.
 * @param int userId
 */
int rightHandRaise(int userId) 
{
  if (userId == -1) {
    return -1;
  }
  int value = -1;
  PVector rightHandUser      = rightHand[userId];
  PVector rightShoulderUser  = rightShoulder[userId];
  try {
    if (rightHandUser.y > rightShoulderUser.y) {
      value = 500;
    } else {
      value = abs((int)rightHandUser.x - (int)rightShoulderUser.x);
    }
    println("rightArmRaise: "+value);
  } catch (Exception e) {
    value = 0;
  }
  return value;
}

/**
 * Returns the id of the user which shoulder is the nearest.
 * @return int userid
 */
int getNearestUser()
{
  int[] userList = cam1.getUsers();
  int min = 9999;
  int nearestUser = -1;
  for (int i = 0; i<userList.length; i++) {
    if (cam1.isTrackingSkeleton(userList[i]) && stopcount[userList[i]] < 4) {
      if (distance(userList[i]) < min) {
        min = distance(userList[i]);
        nearestUser = i;
      }
    }      
  }    
  return nearestUser == -1 ? -1 : userList[nearestUser];
}  

/**
 * Implements the logic based on the skeletons.
 */
void logic()
{ 
  int[] motors = {};
  int[] userList = cam1.getUsers();
  for (int i = 0; i < userList.length; i++) {
    if (cam1.isTrackingSkeleton(userList[i]) && stopcount[userList[i]] < 4) {
      motors = concat(motors, determineMotorsForUser(userList[i]));
    }
  }
  int nearestUser = getNearestUser();
  if (nearestUser > 0) {
    defaultSpeed = (2100-abs(distance(nearestUser)-2100))/40;
    println("speed"+defaultSpeed);
  } else if (second() == 42) {
    doRandomTrick();
  }  
  controlMotors(motors);
}

/**
 * Determines which motors to drive for a certain user.
 * @param int userId
 * @return int[] motors which must be turned on
 */
int[] determineMotorsForUser(int userId) {
  // Get skeleton parts
  int leftHandRaise = leftHandRaise(userId);
  int rightHandRaise = rightHandRaise(userId);
  int height = height(userId);
  int segment = segment(userId);
  int[] motors = {};
  
  int length1 = 300;
  int length2 = 500;
  int length3 = 600;
  int raise1 = 200;
  int raise2 = 400;
  
  if (stopcount[userId] > 3) {
    return motors;
  }
  
  if (segment == 1) {
    if (height < length1) {
      int[] part = {4, 7};
      motors = concat(motors, part);
    } else if (height < length2) {
      int[] part = {4, 7};
      motors = concat(motors, part);
      if (rightHandRaise > raise2) {
        int[] part1 = {1, 5, 6, 4, 3, 2, 8};
        motors = concat(motors, part1);
      } else if (rightHandRaise > raise1) {
        int[] part1 = {1, 5, 6};
        motors = concat(motors, part1);
      }
    } else if (height < length3) {
      int[] part = {7};
      motors = concat(motors, part);
      if (rightHandRaise > raise2) {
        int[] part1 = {1, 5, 6, 4, 3, 2, 8};
        motors = concat(motors, part1);
      } else if (rightHandRaise > raise1) {
        int[] part1 = {1, 5, 6};
        motors = concat(motors, part1);
      }
    } else {
      int[] part = {7};
      motors = concat(motors, part);
      if (rightHandRaise > raise2) {
        int[] part1 = {1, 5, 6, 4, 3, 2, 8};
        motors = concat(motors, part1);
      } else if (rightHandRaise > raise1) {
        int[] part1 = {1, 5, 6};
        motors = concat(motors, part1);
      }
    }
  } else if (segment == 2) {
    if (height < length1) {
      int[] part = {1, 5, 2, 8};
      motors = concat(motors, part);
      if (leftHandRaise > raise1) {
        int[] part1 = {4, 7};
        motors = concat(motors, part1);
      } 
      if (rightHandRaise > raise1) {
        int[] part1 = {6, 3};
        motors = concat(motors, part1);
      }
    } else if (height < length2) {
      int[] part = {1, 5, 2};
      motors = concat(motors, part);
      if (leftHandRaise > raise1) {
        int[] part1 = {4, 7};
        motors = concat(motors, part1);
      } 
      if (rightHandRaise > raise1) {
        int[] part1 = {6, 3};
        motors = concat(motors, part1);
      }
      if (rightHandRaise > raise1 && leftHandRaise > raise1) {
        int[] part1 = {8};
        motors = concat(motors, part1);
      }
    } else if (height < length3) {
      int[] part = {1, 5};
      motors = concat(motors, part);
      if (leftHandRaise > raise1) {
        int[] part1 = {4, 7};
        motors = concat(motors, part1);
      } 
      if (rightHandRaise > raise1) {
        int[] part1 = {6, 3};
        motors = concat(motors, part1);
      }
      if (rightHandRaise > raise1 && leftHandRaise > raise1) {
        int[] part1 = {2, 8};
        motors = concat(motors, part1);
      }
    } else {
      int[] part = {1};
      motors = concat(motors, part);
      if (leftHandRaise > raise1) {
        int[] part1 = {4, 7};
        motors = concat(motors, part1);
      } 
      if (rightHandRaise > raise1) {
        int[] part1 = {6, 3};
        motors = concat(motors, part1);
      }
      if (rightHandRaise > raise1 && leftHandRaise > raise1) {
        int[] part1 = {5, 2, 8};
        motors = concat(motors, part1);
      }
    }
  } else if (segment == 3) {
    if (height < length1) {
      int[] part = {6, 3};
      motors = concat(motors, part);
    } else if (height < length2) {
      int[] part = {6, 3};
      motors = concat(motors, part);
      if (leftHandRaise > raise2) {
        int[] part1 = {5, 7, 1, 4, 3, 2, 8};
        motors = concat(motors, part1);
      } else if (leftHandRaise > raise1) {
        int[] part1 = {5, 7, 1};
        motors = concat(motors, part1);
      }
    } else if (height < length3) {
      int[] part = {6};
      motors = concat(motors, part);
      if (leftHandRaise > raise2) {
        int[] part1 = {5, 7, 1, 4, 3, 2, 8};
        motors = concat(motors, part1);
      } else if (leftHandRaise > raise1) {
        int[] part1 = {5, 7, 1};
        motors = concat(motors, part1);
      }
    } else {
      int[] part = {6};
      motors = concat(motors, part);
      if (leftHandRaise > raise2) {
        int[] part1 = {5, 7, 1, 4, 3, 2, 8};
        motors = concat(motors, part1);
      } else if (leftHandRaise > raise1) {
        int[] part1 = {5, 7, 1};
        motors = concat(motors, part1);
      }
    }
  } 
  return motors;
} 

/**
 * Reads an array containing the id's of the motors which need to be turned on.
 * @param int[] motors
 */
void controlMotors(int[] motors)
{
  int[] motorState = new int[10];
  
  for (int i = 0; i < motors.length; i++) {
    motorState[motors[i]] = 1;
  }  
  
  for (int i = 1; i < motorState.length; i++) {
    if (motorState[i] == 1) {
      sendToModule(i, customSpeeds[i] != 0 ? customSpeeds[i] : defaultSpeed);
    } else {
      sendToModule(i, 0);
    }
  }  
}

/**
 * Tracks two lines of the safetycam and halts if there are other objects
 * on these lines.
 */
void doSafetyCheck()
{
  safetyCam.update();
  
  background(200, 0, 0);

  PImage depthImage = safetyCam.depthImage();

  // draw depthImageMap
  image(depthImage, 0, 0);
  
  int b1 = 220;
  int b2 = 390;
  float sum1 = 0;
  float sum2 = 0;
  float previous1 = 0;
  float previous2 = 0;
  
  for (int i = 0; i < 640; i++) {
    if (red(depthImage.get(i, b1)) > 20) { 
      sum1 = pow(abs(previous1 - red(depthImage.get(i, b1))),2) + sum1;
      previous1 = red(depthImage.get(i, b1));
    }
  }
  for (int i = 0; i < 640; i++) {
    if (red(depthImage.get(i, b2)) > 20) { 
      sum2 = pow(abs(previous2 - red(depthImage.get(i, b2))), 2) + sum2;
      previous2 = red(depthImage.get(i, b2));
    }
  }
  boolean halt1, halt2;
  if (sum1 > 60000) {
    if (haltcount1 > 3) {
      halt1 = true;
    } else {
      halt1 = false;
    }
    haltcount1++;
  } else {
    halt1 = false;
    haltcount1 = 0;
  }
  if (sum2 > 60000) {
    if (haltcount2 > 3) {
      halt2 = true;
    } else {
      halt2 = false;
    }
    haltcount2++;
  } else {
    halt2 = false;
    haltcount2 = 0;
  }

  if (halt1 || halt2) {
    halt = true;
  } else {
    halt = false;
  }
}

/**
 * Turns on a random segment for 3 seconds
 */
void doRandomTrick()
{
  int duration = 2000;
  int speed = 35;
  int id = int(random(9));
  for (int i = 0; i < speed; i++) {
    sendToModule(id, i);
    delay(50);
  }
  delay(duration);
  for (int i = 0; i < speed; i++) {
    sendToModule(id, speed-1-i);
    delay(50);
  }  
}

/**
 * Send value to node via serial connection
 * @param int id Id of node
 * @param int value speed of motor
 */
void sendToModule(int id, int value)
{
  value = halt ? 0 : value;
  serial.write((byte)77);
  serial.write((byte)id);
  serial.write((byte)value);
  serial.write((byte)70);
}

