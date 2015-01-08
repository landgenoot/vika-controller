
/**
 * Beunprojectje
 */

class Snake
{
  
  int direction = 0;
  Flap currentFlap, food;
  Controller controller;
  ArrayList<Flap> tail = new ArrayList<Flap>();
  int tailSize = 1;
  int effect = 0;
  boolean gameOver = false;
  
  public Snake()
  {
    controller = Controller.getInstance();
    currentFlap = controller.flaps[30];
    food = controller.flaps[int(random(77))];
    food.speed(1);
  }   
  
  public void update()
  {
    if (gameOver) {
      this.gameOver();
    } else {
      if (food != null) {
        food.speed(1);
      }
      delay(500);
      currentFlap = this.getNextFlap();
      if (currentFlap == null) {
        gameOver = true;
        effect = 0;
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
  }
  
  private void gameOver()
  {
    controller.enableFade = true;
    controller.drawRectangle(
      new Rectangle(
        new Point(effect, 0),
        50,
        400
      ),
      1
    );
    effect += 10;
  
    if (effect > 600) {
      controller.enableFade = false;
      gameOver = false;
      tail = new ArrayList<Flap>();
      controller = Controller.getInstance();
      currentFlap = controller.flaps[30];
      food = controller.flaps[int(random(77))];
      food.speed(1);
      direction = 0;
      tailSize = 1;
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
