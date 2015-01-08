
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
  
  public void update()
  {
    clear();
    background(50,50,50);
    pushMatrix();
    textSize(26);
    text("Vika controller", 110, 40);
    Controller controller = Controller.getInstance();
    popMatrix();
    strokeWeight(1);
    for (Flap flap : controller.flaps) {
      drawFlap(flap, flap.speed);
    }
    for (Segment segment : controller.segments) {
      drawSegment(segment);
    }
  }
  
  private void drawFlap(Flap flap, float speed) 
  {
    pushMatrix();
    translate(this.x+flap.location.x*scale, this.y-flap.location.y*scale);
    strokeWeight(1);
    fill(140 - speed*140);
    polygon(0, 0, 15*scale, 6); 
    fill(255);
    textSize(10*scale);
    textAlign(CENTER);
    text("   "+flap.id, -5*scale, 4*scale); 
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
