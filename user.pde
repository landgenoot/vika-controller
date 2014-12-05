import processing.serial.*;

/**
 * Master computer for controlling an interactive environment using a kinect.
 * Based on SimpleOpenNI User Test
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2014
 */

import SimpleOpenNI.*;

SimpleOpenNI  context;
color[]       userClr = new color[]{ color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();                                   
PVector com2d = new PVector();   
Serial serial;
int defaultSpeed = 55;
int gestureTimestamp = 0;

PVector leftHand[] = new PVector[100];
PVector rightHand[] = new PVector[100];
PVector head[] = new PVector[100];
int stopcount[] = new int[100];

void setup()
{
  size(640,480);
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  serial = new Serial(this, portName, 9600);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();  
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }      
      
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
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
  rightHand[userId] = new PVector();
  head[userId] = new PVector();
  
  
  
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand[userId]);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand[userId]);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,head[userId]);
  
  if (oldLeftHand == leftHand[userId].x) {
    stopcount[userId]++;
  } else {
    stopcount[userId] = 0;
  }
  
  
  
  
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  curContext.startTrackingSkeleton(userId);
}

/**
 * Returns the id of the person which' head is detected at the highest y-coordinate.
 * @return int id
 */
int getSmallestUser()
{
  int[] userList = context.getUsers();
  println();
  println("==");
  for (int i =0; i < userList.length; i++) {
    println(i);
  }
  println("==");
  println();
  int min = 9999;
  int smallestUser = -1;
  for (int i = 0; i<userList.length; i++)
  {
    if (context.isTrackingSkeleton(userList[i]) && stopcount[userList[i]] < 4)
    {
      if (userLength(userList[i]) < min) {
        min = userLength(userList[i]);
        smallestUser = i;
      }
    }      
  }    
  return smallestUser == -1 ? -1 : userList[smallestUser];
}  

/**
 * Returns relative length of user, based on 
 * @return int size
 */
int userLength(int userId)
{
  int smallestUserLength =-1;
  try {
    smallestUserLength = (int)head[userId].y;
  } catch(Exception e) {
    return -1;
  }
  return smallestUserLength;
}

/**
 * Return distance between hands
 * @return int length
 */
int userWidth(int userId)
{
  if (userId == -1)
    return 0;
  PVector leftHandUser = leftHand[userId];
  PVector rightHandUser = rightHand[userId];
  try {
    return (int)abs(leftHandUser.x - rightHandUser.x);
  } catch (Exception e) {
    return 0;
  }
  
}

/**
 * Implements the logic based on the skeletons.
 */
void logic()
{
  int smallestUser = getSmallestUser();
  int smallestUserLength = userLength(smallestUser);
  int smallestUserWidth = userWidth(smallestUser);
  int[] motors = new int[10];
  if (smallestUser != -1){
    motors = determineMotors(smallestUserLength, smallestUserWidth);
  }
  controlMotors(motors);
}

/**
 * Determines which motors to drive based on height.
 * @param int height of user
 * @return int[] motors which must be turned on
 */
int[] determineMotors(int length, int width)
{
  println("length: "+ length);
  int[] motors = new int[10]; 
  if (length > 600) {
    motors[1] = 1;
    if (width < 700) {
      // Nothing to add
    } else if (width < 1200) {
      motors[5] = 1;
      motors[6] = 1;
      motors[7] = 1;
    } else {
      motors[5] = 1;
      motors[6] = 1;
      motors[7] = 1;
      motors[3] = 1;
      motors[4] = 1;
      motors[2] = 1;
      motors[8] = 1;
    }
  } else if (length > 400) {
    motors[1] = 1;
    motors[5] = 1;
    motors[6] = 1;
    motors[7] = 1;
    if (width < 300) {
      // Nothing to add
    } else if (width < 500) {
      motors[3] = 1;
      motors[4] = 1;
    } else {
      motors[3] = 1;
      motors[4] = 1;
      motors[9] = 1;
    }
  } else if (length > 250) {
    motors[1] = 1;
    motors[2] = 1;
    motors[5] = 1;
    motors[3] = 1;
    motors[4] = 1;
    motors[6] = 1;
    motors[7] = 1;
    motors[9] = 1;
    if (width < 300) {
      // Nothing to add
    } else if (width < 500) {
      motors[3] = 1;
      motors[4] = 1;
    } else {
      motors[3] = 1;
      motors[4] = 1;
      motors[9] = 1;
    }
  } else {
    motors[1] = 1;
    motors[2] = 1;
    motors[3] = 1;
    motors[4] = 1;
    motors[5] = 1;
    motors[6] = 1;
    motors[7] = 1;
    motors[8] = 1;
    motors[9] = 1;
  }
  return motors;
}

void controlMotors(int[] motors)
{
  for (int i = 1; i <= 9; i++) {
    if (motors[i] == 1) {
      sendToModule(i, 55);
    } else {
      sendToModule(i, 0);
    }
  }  
}

/**
 * Send value to node via serial connection
 * @param int id Id of node
 * @param int value speed of motor
 */
void sendToModule(int id, int value)
{
   serial.write((byte)77);
   serial.write((byte)id);
   serial.write((byte)value);
   serial.write((byte)70);
}
