
/**
 * Standard square class.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Rectangle 
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
  public boolean isInside(Point p)
  {
    if (origin.x > p.x || origin.y > p.y || origin.x+width < p.x || origin.y+heigth < p.y) {
      return false; 
    } else {
      return true;
    }
  }
  
  /**
   * Moves the rectangle. This is used to place figures on the correct segment.
   * @param int x-correction
   * @param int y-correction
   */
  public void transform(int x, int y)
  {
    origin.x = origin.x + x;
    origin.y = origin.y + y;
  }
}

