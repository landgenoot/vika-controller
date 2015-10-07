
import java.awt.geom.Line2D.Double;

/**
 * Line from point to point over the installation.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Line
{
  public Point a, b;
  public int thickness;
  
  public Line(Point a, Point b, int thickness)
  {
    this.a = a;
    this.b = b;
    this.thickness = thickness;
  }
  
  /**
   * Returns true if the given point is part of the line.
   * @param Point
   * @return boolean true if part of line
   */
  public boolean isOnLine(Point p)
  {
    if (
      b.y > a.y 
      && (
        p.y > b.y+thickness 
        || p.y < a.y-thickness
      ) 
      || a.y >= b.y 
      && (
        p.y > a.y+thickness 
        || p.y < b.y-thickness 
      )
      || b.x > a.x 
      && (
        p.x > b.x+thickness 
        || p.x < a.x-thickness
      ) 
      || a.x >= b.x 
      && (
        p.x > a.x+thickness 
        || p.x < b.x-thickness 
      )
    ) {
      return false;
    }
    float x1 = a.x;
    float x2 = b.x;
    float y1 = a.y;
    float y2 = b.y;
    float px = p.x;
    float py = p.y;
    float x, y;
    
    float pd2 = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
    if (pd2 == 0) {
      x = x1;
      y = y2;
    } else {
      float u = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1)) / pd2;
      x = x1 + u * (x2 - x1);
      y = y1 + u * (y2 - y1);
    }
    double distance = Math.sqrt((x - px) * (x - px) + (y - py) * (y - py));
    
    return (distance < thickness);
  }
  
}
