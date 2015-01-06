
/**
 * Standard square class.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Square 
{
  public Point origin;
  public int width, height;

  Square(Point origin, int width, int height) 
  {
    this.origin = origin;
    this.width = width;
    this.height = height;
  }
  
  /**
   * Determines if a point is located inside this square.
   */
  boolean isInside(Point p)
  {
    if (origin.x > p.x || origin.y > p.y || origin.x+width < p.x || origin.y+heigth < p.y) {
      return false; 
    } else {
      return true;
    }
  }
}

