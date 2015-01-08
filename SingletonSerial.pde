
/**
 * Singleton implementation of the Serial class.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

static class SingletonSerial
{
  private static Serial _instance = null;
  
  private SingletonSerial() {}
  
  public synchronized static void createInstance(vika main, int port)
  {
    if (_instance == null) {
      String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
      _instance = new Serial(main, portName, 9600);
    }
  }
  
  public static Serial getInstance () {
    return _instance;
  }
}
