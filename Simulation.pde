
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
  float scale;
  
  public Simulation(int x, int y, float scale)
  {
    this.x = x;
    this.y = y;
    this.scale = scale;
  }
  
  public void init()
  {
    textSize(36);
    text("Vika controller", 100, 100);
    Controller controller = Controller.getInstance();
    strokeWeight(1);
    for (Flap flap : controller.flaps) {
      drawFlap(flap);
    }
    for (Segment segment : controller.segments) {
      drawSegment(segment);
    }
  }
  
  private void drawFlap(Flap flap) 
  {
    pushMatrix();
    translate(this.x+flap.location.x, this.y-flap.location.y);
    strokeWeight(1);
    fill(160);
    polygon(0, 0, 15, 6); 
    fill(0);
    textSize(10);
    textAlign(CENTER);
    text("   "+flap.id, -5, 4); 
    popMatrix();
  }
  
  private void drawSegment(Segment segment)
  {
    pushMatrix();
    Rectangle rect = segment.controllingArea;
    fill(120, 128);
    translate(this.x+rect.origin.x, this.y-rect.origin.y-rect.height);
    rect(0, 0, rect.width, rect.height);
    popMatrix();
  }
  
  private void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    beginShape();
    stroke(255);
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
