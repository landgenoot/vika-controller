
class Controller
{
  
 ArrayList<Flap> flaps = new ArrayList<Flap>();
 ArrayList<Segment> segments = new ArrayList<Segment>();
  
 public Controller()
 {
   
 }
 
 public void registerFlap(Flap flap) { flaps.add(flap); }
 
 public void registerSegment(Segment segment) { segments.add(segment); }
 
}
