import java.util.*;

//Class implementation for Bentley-Ottman Algorithm
public class BentleyOttmann {

    private Queue<Event> Q;
    private NavigableSet<Segment> T;
    private ArrayList<Point> X;
    int posX = 450, posY = 70;

    BentleyOttmann(ArrayList<Segment> input_data) {
      
        this.Q = new PriorityQueue<>(new event_comparator());
        this.T = new TreeSet<>(new segment_comparator());
        this.X = new ArrayList<>();
        
        for (Segment s : input_data) {
          
            this.Q.add(new Event(s.first(), s, 0)); //Add segment top as event
            this.Q.add(new Event(s.secondd(), s, 1)); //Add segment bottom as event
            
        }
        
    }

    //Bentley-Ottman main 
    void SweepLine() {
      
        //Process event points while not empty
        text( "Check console for status of sweep line and events! ", 320, 50 );
        text("Intersections: ", 320, 70 ); 
        while (!this.Q.isEmpty()) {
               
            Event e = this.Q.poll();
            double l = e.getValue();
            //delay(100);
            //Segment top event
            if (e.getType() == 0) {
                  
                print("Sweep Line Status: Segment top event \n");
                //delay(300);
                //fill(255); stroke(255); text( "Sweep Line Status: Segment top event ", 10, 125 ); fill(0);stroke(0);
                //For each segment associated with the event add to SL Status and find intersections with neighbors
                for (Segment s : e.getSegments()) {
                  
                    this.recalculate(l);
                    this.T.add(s);
                    line((float)s.first().get_x_coord(),150,(float)s.first().get_x_coord(), 1000);
                    line((float)s.secondd().get_x_coord(),150,(float)s.secondd().get_x_coord(), 1000); 
                    //If left neighbor exists find intersections
                    if (this.T.lower(s) != null) {
                      
                        Segment r = this.T.lower(s);
                        this.calculateIntersection(r, s, l);
                        
                    }
                    
                    //If right neighbor exists find intersection
                    if (this.T.higher(s) != null) {
                      
                        Segment t = this.T.higher(s);
                        this.calculateIntersection(t, s, l);
                        
                    }
                    
                    //If both neighbors exist remove duplicate event
                    if (this.T.lower(s) != null && this.T.higher(s) != null) {
                      
                        Segment r = this.T.lower(s);
                        Segment t = this.T.higher(s);
                        
                        //Remove duplicate
                        this.removeDuplicate(r, t);
                        
                    }
                    
                }
                
            } else if (e.getType() == 1) { //Segment bottom event
                  
                print("Sweep Line Status: Segment bottom event\n");                  
                for (Segment s : e.getSegments()) {
                  
                    if (this.T.lower(s) != null && this.T.higher(s) != null) {
                      
                        Segment r = this.T.lower(s);
                        Segment t = this.T.higher(s);
                        
                        this.calculateIntersection(r, t, l);
                        
                    }
                    
                    //Remove segment
                    this.T.remove(s);
                    
                }
                
            } else if (e.getType() == 2) { //Intersection event
                  
                print( "Event Q: Point(intersection)\n");   
                Segment s1 = e.getSegments().get(0);
                Segment s2 = e.getSegments().get(1);
                print( "Sweep Line Status: Segment swap\n" );
                this.swap(s1, s2);
                
                if (s1.getValue() < s2.getValue()) {
                  
                    if (this.T.higher(s1) != null) {
                      
                        Segment t = this.T.higher(s1);
                        this.calculateIntersection(t, s1, l);
                        this.removeDuplicate(t, s2);
                        
                    }
                    
                    if (this.T.lower(s2) != null) {
                      
                        Segment r = this.T.lower(s2);
                        this.calculateIntersection(r, s2, l);
                        this.removeDuplicate(r, s1);
                        
                    }
                    
                } else {
                  
                    if (this.T.higher(s2) != null) {
                      
                        Segment t = this.T.higher(s2);
                        this.calculateIntersection(t, s2, l);
                        this.removeDuplicate(t, s1);
                        
                    }
                    
                    if (this.T.lower(s1) != null) {
                      
                        Segment r = this.T.lower(s1);
                        this.calculateIntersection(r, s1, l);
                        this.removeDuplicate(r, s2);
                        
                    }
                    
                }
                
                this.X.add(e.getPoint());
                
             }
          
        }
        
    }
    
    //Find intersection between 2 segments
    private boolean calculateIntersection(Segment s1, Segment s2, double l) {
      
        double x1 = s1.first().get_x_coord();
        double y1 = s1.first().get_y_coord();
        double x2 = s1.secondd().get_x_coord();
        double y2 = s1.secondd().get_y_coord();
        double x3 = s2.first().get_x_coord();
        double y3 = s2.first().get_y_coord();
        double x4 = s2.secondd().get_x_coord();
        double y4 = s2.secondd().get_y_coord();
        double r = (x2 - x1) * (y4 - y3) - (y2 - y1) * (x4 - x3);
        
        if (r != 0) {
          
            double t = ((x3 - x1) * (y4 - y3) - (y3 - y1) * (x4 - x3)) / r;
            double u = ((x3 - x1) * (y2 - y1) - (y3 - y1) * (x2 - x1)) / r;
            
            if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {
              
                double xC = x1 + t * (x2 - x1);
                double yC = y1 + t * (y2 - y1);
                
                if (xC > l) {
                  
                    this.Q.add(new Event(new Point(xC, yC), new ArrayList<>(Arrays.asList(s1, s2)), 2));
                    textSize(12); 
                    String formattedX = String.format("%.2f", xC); String formattedY = String.format("%.2f", yC);
                    text("X: "+ formattedX + "\t Y: " + formattedY +"\n",posX,posY);
                    if(posY == 140)
                    {
                      posY = 70; posX += 250;
                    }
                    else
                      posY += 14;
                    line((float)xC,150,(float)xC, 1000);
                    return true;
                    
                }
                
            }
            
        }
        
        return false;
        
    }

    private boolean removeDuplicate(Segment s1, Segment s2) {
      
        for (Event e : this.Q) {
          
            if (e.getType() == 2) {
              
                if ((e.getSegments().get(0) == s1 && e.getSegments().get(1) == s2) || (e.getSegments().get(0) == s2 && e.getSegments().get(1) == s1)) {
                  
                    this.Q.remove(e);
                    
                    return true;
                    
                }
                
            }
            
        }
        
        return false;
        
    }

    //Swap two segments in sweep line status DS 
    private void swap(Segment s1, Segment s2) {
      
        //Remove from DS
        this.T.remove(s1);
        this.T.remove(s2);
        
        double temp = s1.getValue();
        
        //Swap values
        s1.setValue(s2.getValue());
        s2.setValue(temp);
        
        //Add to DS
        this.T.add(s1);
        this.T.add(s2);
        
    }

    private void recalculate(double l) {
      
        Iterator<Segment> iter = this.T.iterator();
        
        while (iter.hasNext()) {
          
            iter.next().calculateValue(l);
            
        }
        
    }
    
    private void printOutput() {
      
      
      
    }

    public ArrayList<Point> get_intersections() { return this.X; }

    private class event_comparator implements Comparator<Event> {
      
        @Override
        public int compare(Event e1, Event e2) {
          
            if (e1.getValue() > e2.getValue()) { return 1; }
            if (e1.getValue() < e2.getValue()) { return -1; }
             
                    
            return 0;
            
        }
        
    }

    private class segment_comparator implements Comparator<Segment> {
      
        @Override
        public int compare(Segment s1, Segment s2) {
          
            if (s1.getValue() < s2.getValue()) { return 1; }
            if (s1.getValue() > s2.getValue()) { return -1; }
            
            return 0;
            
        }
        
    }
    
     
    
}
