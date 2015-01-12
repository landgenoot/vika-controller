
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
   
        . b
       / \
      /   \
     /     \
   ./Alp____\. point
   a   
   
   * @param Point
   * @return boolean true if part of line
   */
  public boolean isOnLine(Point p)
  {
    float Alp = atan(slope());
    float distance = dX(p) * sin(Alp);
    //println(dX(p));
    println(Alp);
    return (distance < this.thickness);
  }
  
  public int dX(Point p)
  {
    return abs(p.x - a.x); 
  }
  
  public int dY(Point p)
  {
    return abs(p.y - a.y);
  }
  
  public float slope()
  {
    return dX(b)/dY(b);
  }
}
