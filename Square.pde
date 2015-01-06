
/**
 * Standard square class.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Square 
{
  public Point ul, ur, lr, ll;

  Square(Point ul, Point ur, Point lr, Point ll) 
  {
    this.ul = ul;
    this.ur = ur;
    this.lr = lr;
    this.ll = ll;
  }
}

