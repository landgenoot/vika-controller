
/**
 * Draws a graphical representation of the interactive
 * installation on screen.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Simulation
{
  int x, y; // Location of simulation
  
  public Simulation(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  public void init()
  {
    Controller controller = Controller.getInstance():
    for (Flap flap : controller.flaps){
      drawFlap(flap);
    }
  }
  
  private void drawFlap(Flap flap) 
  {
    
  }
}
