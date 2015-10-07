
class Effect
{
  int progress = 0;
  int type = 0;
  int random = int(random(0,77));
  public int lastSeenUser = 0;
  
  public Effect()
  {
    
  } 
  
  public void update()
  {
    if (type == 1) {
      bottomToTop();
    } else if (type == 2) {
      randomFlap();
    }
  }
  
  public void randomFlap()
  {
    if ((millis() - lastSeenUser) < 5000) {
    type = 2;
    
    Controller controller = Controller.getInstance();
    controller.flaps[random].speed(0.8);
    progress++;
    
    if (progress > 250) {
      type = 0; 
      progress = 0;
      random = int(random(0, 77));
    }
    }
  }
  
  public void bottomToTop()
  {
    type = 1;
    
    Controller controller = Controller.getInstance();

    controller.drawRectangle(
        new Rectangle(
        new Point(0, progress),
        controller.width,
        100
      ),
      2
    );
    controller.simulation.update();
    
    progress += 10;
    
    if (progress > controller.height) {
      type = 0;
      progress = 0;
    }
  }
  
}

