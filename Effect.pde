
class Effect
{
  int progress = 0;
  int type = 0;
  
  public Effect()
  {
    
  } 
  
  public void update()
  {
    if (type == 1) {
      bottomToTop();
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
      1
    );
    controller.simulation.update();
    
    progress += 10;
    
    if (progress > controller.height) {
      type = 0;
      progress = 0;
    }
  }
  
}
