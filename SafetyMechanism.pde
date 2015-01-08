
/**
 * The safety mechanism makes sure that no one will
 * be able to touch the interactive installation.
 *
 * A kinect placed at the ceiling will keep track of two lines
 * parralel to the installlation. The SQD (Sum Squared Difference) in depth
 * on this line is calculated, and if this becomes above a treshold
 * the installation is turned off.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class SafetyMechanism
{
  int[] lines;
  
  public SafetyMechanism(int[] lines)
  {
    this.lines = lines;
  }
  
  public boolean init()
  {
    return true;
  }
  
  public boolean isHalt()
  {
    return false;
  }
  
  
}
