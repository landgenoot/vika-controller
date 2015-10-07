
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.NoSuchElementException;

/**
 * Serial wrapper with priority queue implementation.
 * Every bus has its own priority queue which makes sure 
 * that new interactions are always send first on the bus.
 * Fade-out messages do have a lower priority.
 * 
 * @author Daan Middendorp <github-d@landgenoot.com>
 * @copyright TU Delft 2015
 */

class Message
{
  ArrayList<PriorityQueue<Byte[]>> messageQueues = new ArrayList<PriorityQueue<Byte[]>>();
  
  Thread deamon = new Thread(){
    public void run(){
      Controller controller = Controller.getInstance();
      while (true) {
        int bus = 0;
        if (controller.message != null) {
          byte[] resetAll = {
            (byte)77,
            (byte)255,
            (byte)0,
            (byte)70
          };
          controller.message.serialInstances[bus].write(
            resetAll
          );
          delay(1);
          controller.message.serialInstances[bus].write(
            resetAll
          );
          delay(1);
        }
        for (PriorityQueue<Byte[]> messageQueue : messageQueues) {
//          println(messageQueue.size());
          while (messageQueue.size() > 0) {
            try {
              byte[] temp = toPrimitives(messageQueue.remove());
              controller.message.serialInstances[bus].write(
                temp
              );
              
              delay(1);
            } catch (NoSuchElementException e) {}
          }
          bus++; 
        }
        try {
          Thread.sleep(200);
        } catch (InterruptedException e) {}
      }
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
              return (message1 != null && message1[2] == 95 ? -1 : 1);
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
    byte[] temp = toPrimitives(data);
    controller.message.serialInstances[bus].write(
      temp
    );
    delay(1);
    
    
//    messageQueues.get(bus).add(data);   
  }
  
  private byte[] toPrimitives(Byte[] oBytes)
  {
  
      byte[] bytes = new byte[oBytes.length];
      for(int i = 0; i < oBytes.length; i++){
          bytes[i] = oBytes[i];
      }
      return bytes;
  
  }
}
