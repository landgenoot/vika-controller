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
  leftHand[userId] = new PVector();
  rightHand[userId] = new PVector();
  
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand[userId]);
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand[userId]);
  
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
  int min = 9999;
  int smallestUser = -1;
  for (int i = 0; i<userList.length; i++)
  {
    if (context.isTrackingSkeleton(userList[i]))
    {
      if (userLength(i) < min) {
        min = userLength(i);
        smallestUser = i;
      }
    }      
  }    
  return smallestUser;
}  

/**
 * Returns relative length of user, based on 
 * @return int size
 */
int userLength(int userId)
{
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointPos);
  int smallestUserLength = 480 - (int)jointPos.y;
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
  PVector leftHandUser = leftHand[userId+1];
  PVector rightHandUser = rightHand[userId+1];
  return (int)abs(leftHandUser.x - rightHandUser.x);
  
}

/**
 * Implements the logic based on the skeletons.
 */
void logic()
{
  int smallestUser = getSmallestUser();
  int smallestUserLength = userLength(smallestUser);
  int smallestUserWidth = userWidth(smallestUser);
  if (smallestUser != -1){
    int[] motors = determineMotors(smallestUserLength, smallestUserWidth);
  }
}

/**
 * Determines which motors to drive based on height.
 * @param int height of user
 * @return int[] motors which must be turned on
 */
int[] determineMotors(int length, int width)
{
  
  ArrayList<Integer> motors = new ArrayList();
      
      
  if (length < 250) {
    motors.add(1);
    if (width < 300) {
      secondary = {};
    } else if (width < 500) {
      motors.add(3);
      motors.add(4);
      motors.add(5);
      motors.add(7);
    } else {
      motors.add(3);
      motors.add(4);
      motors.add(6);
      motors.add(7);
      motors.add(9);
    }
  } else if (length < 360) {
    primary = {1, 5, 6, 7};
    if (width < 300) {
      secondary = {};
    } else if (width < 500) {
      secondary = {3, 4};
    } else {
      secondary = {3, 4, 9};
    }
  } else if (length < 560) {
    primary = {1, 2, 5, 3, 4, 6, 7, 9};
    if (width < 300) {
      secondary = {};
    } else if (width < 500) {
      secondary = {3, 4};
    } else {
      secondary = {3, 4, 9};
    }
  } else {
    secondary = {};
    primary = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  }
  
  return concat(primary, secondary);
}

/**
 * Determines the size between two hands, and controlls motors based on the gesture.
 * @param int smallest user in view
 * @return int[] motors which must be turned on
 */
//int[] motorsOnGesture(int smallestUser)
//{
//  
//}

/**
 * Send value to node via serial connection
 * @param int id Id of node
 * @param int value speed of motor
 */
void sendToModule(int id, int value)
{
   serial.write((byte)77);
   serial.write((byte)id);
   serial.write((byte)55);
   serial.write((byte)70);
}
