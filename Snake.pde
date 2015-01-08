
class Snake
{
  
  int direction = 0;
  Flap currentFlap, food;
  Controller controller;
  ArrayList<Flap> tail = new ArrayList<Flap>();
  int tailSize = 1;
  
  public Snake()
  {
    controller = Controller.getInstance();
    currentFlap = controller.flaps[30];
    food = controller.flaps[int(random(77))];
    food.speed(1);
  }   
  
  public void update()
  {
    if (food != null) {
      food.speed(1);
    }
    delay(500);
    currentFlap = this.getNextFlap();
    if (currentFlap == null) {
      this.gameOver();
    } else {
      if (currentFlap.location.equals(food.location)) {
        tailSize++;
        food = controller.flaps[int(random(77))];
      }
        
      tail.add(currentFlap);
      this.drawTail();
      if (tail.size() > tailSize){
        tail.remove(0);
      }
    }
  }
  
  private void gameOver()
  {
    for (int i = 0; i < 300; i++) {
      controller.
      controller.drawRectangle(
        new Rectangle(
          new Point(0,x),
          70,
          220
        ),
        1
      );
    }
  }
  
  private void drawTail()
  {
    for (Flap flap : tail) {
      flap.speed(1);
    }
  }
  
  public Flap getNextFlap() 
  {
    Point currentLocation = currentFlap.location;
    Point nextPoint = new Point(0,0);
    if (direction == 0 ){
      nextPoint = new Point(currentLocation.x, currentLocation.y+30);
    } else if (direction == 1) {
      nextPoint = new Point(currentLocation.x+27, currentLocation.y+15);
    } else if (direction == 2) {
      nextPoint = new Point(currentLocation.x+27, currentLocation.y-15);
    } else if (direction == 3) {
      nextPoint = new Point(currentLocation.x, currentLocation.y-30);
    } else if (direction == 4) {
      nextPoint = new Point(currentLocation.x-27, currentLocation.y-15);
    } else if (direction == 5) {
      nextPoint = new Point(currentLocation.x-27, currentLocation.y+15);
    }
    return controller.findFlapByLocation(nextPoint);
  }
  
  public void setNextDirection()
  {
    if (keyCode == LEFT) {
      direction--;
    }
    if (keyCode == RIGHT) {
      direction++;
    }
    if (direction > 5) {
      direction = direction - 6;
    }
    if (direction < 0) {
      direction = direction + 6;
    }
  }
  
}
