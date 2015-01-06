
/**
 * Singleton implementation of the Serial class.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class SingletonSerial
{
  private static Serial _instance = null;
  
  private SingletonSerial() {}
  
  private synchronized static void createInstance()
  {
    if (_instance == null) {
      String portName = Serial.list()[4]; //change the 0 to a 1 or 2 etc. to match your port
      _instance = new Serial(this, portName, 9600);
    }
  }
  
  public static Singleton getInstance () {
    if (_instance == null) {
      createInstance ();
    }
    return _instance;
  }
}
