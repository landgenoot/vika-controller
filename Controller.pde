
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
   for (Segment segment : segments) {
     if (segment.init() == false) {
       println("Can't init segment #" + segment.id);
     } 
   }
 }
 
 public void registerFlap(Flap flaps) { this.flaps = flaps; }
 
 public void registerSegment(Segment segments) { this.segments = segments; }
 
}
