
/**
 * The controller manages the different other classes.
 *
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */
 
class Controller
{
  
 Flap[] flaps;
 Segment[] segments;
  
 public Controller()
 {
   SimpleOpenNI.start();
   
 }
 
 public void init()
 {
   int i = 0;
   for (Segment segment : segments) {
     if (segment.init() == false) {
       println("Can't init segment #" + i);
       exit();
     } 
     i++;
   }
 }
 
 public void drawSquare(Square square, float speed)
 {
   for (Flap flap : flaps) {
     if (square.isInside(flap.getPoint())) {
       flap.speed(speed);
     }
   }  
 }
 
 public void update()
 {
   this.fadeAll();
 }
 
 /**
  * Fades all the registered flaps
  */
 private void fadeOutAll()
 {
   for (Flap flap : flaps) {
     flap.fadeOut();
   }
 }
 
 public void registerFlap(Flap flaps) { this.flaps = flaps; }
 
 public void registerSegment(Segment segments) { this.segments = segmen
}
