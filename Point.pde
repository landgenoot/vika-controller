
/**
 * Point in the installation, used to determine the location of 
 * the flapjes
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Point
{
  public int x, y;

  Point(int x, int y) 
  {
    this.x = x;
    this.y = y;
  }
  
  public boolean equals(Point that)
  {
    if (this.x == that.x && this.y == that.y) {
      return true;
    } else {
      return false;
    } 
  }
  
  public String toString()
  {
    return "Point(" + x + ", " + y + ")";
  }
}

