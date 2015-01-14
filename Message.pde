
import java.util.Comparator;
import java.util.PriorityQueue;

/**
 * Serial wrapper with priority queue implementation
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Message
{
  ArrayList<PriorityQueue<Byte[]>> messageQueues;
  
  Thread deamon = new Thread(){
    public void run(){
      System.out.println("Thread Running");
    }
  };
    
  private Serial[] serialInstances;
  
  public Message(Serial[] instances) {
    this.serialInstances = instances;
    
    for (int i = 0; i < serialInstances.length; i++) {
      messageQueues.add(
        new PriorityQueue<Byte[]>(
          10, new Comparator<Byte[]>() {
            public int compare(Byte[] message1, Byte[] message2) {
              return (message1[2] == 255 ? 1 : -1);
            }
        })
      );
    }
    
    deamon.start();
  }
  
  /**
   * Adds the data received by a flap to the right 
   * priority queue of a bus.
   * @param bus the bus identifier
   * @param data 
   */
  public void addToQueue(int bus, Byte[] data)
  {    
    messageQueues.get(bus).add(data);   
  }
}
