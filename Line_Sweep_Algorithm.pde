
import java.util.*;

ArrayList<Segment> segments = new ArrayList<Segment>();
ArrayList<Point>   points   = new ArrayList<Point>();

BentleyOttmann sweepLine = null;

boolean startPoint = true;
boolean endPoint   = false;

Point prevPoint = null;
Point currPoint = null;

Segment segment = null;

int j = 0;
int k = 0;

public class Point {

    private double x_coord;
    private double y_coord;

    Point(double x, double y) {
      
        this.x_coord = x;
        this.y_coord = y;
        
    }

    public double get_x_coord() { return this.x_coord; }

    public void set_x_coord(double x_coord) { this.x_coord = x_coord; }

    public double get_y_coord() { return this.y_coord; }

    public void set_y_coord(double y_coord) { this.y_coord = y_coord; }
    
    void draw() {
      
      fill(0, 255, 0);
      circle((float)x_coord, (float)y_coord, 10);
      
    }

}

public class Segment {

    private Point p1;
    private Point p2;
    double value;

    Segment(Point p1, Point p2) {
      
        this.p1 = p1;
        this.p2 = p2;
        
        this.calculateValue(this.first().get_x_coord());
        
    }

    public Point first() {
      
        if (p1.get_x_coord() <= p2.get_x_coord()) {
          
            return p1;
            
        } else {
          
            return p2;
            
        }
        
    }

    public Point secondd() {
      
        if (p1.get_x_coord() <= p2.get_x_coord()) {
          
            return p2;
            
        } else {
          
            return p1;
            
        }
        
    }

    public void calculateValue(double value) {
      
        double x1 = this.first().get_x_coord();
        double x2 = this.secondd().get_x_coord();
        double y1 = this.first().get_y_coord();
        double y2 = this.secondd().get_y_coord();
        
        this.value = y1 + (((y2 - y1) / (x2 - x1)) * (value - x1));
        
    }

    public void setValue(double value) { this.value = value; }

    public double getValue() { return this.value; }
    
    void draw() {
      
      fill(0);
      line((float)p1.get_x_coord(), (float)p1.get_y_coord(), (float)p2.get_x_coord(), (float)p2.get_y_coord());
      
    }

}

public class Event {

    private Point point; //Event Point
    private ArrayList<Segment> segments; //Collection of segments associated with the event 
    private double value;
    private int type; //0-Segment Top, 1-Segment Bottom, 2-Intersection Point

    Event(Point p, Segment s, int type) {
      
        this.point = p;
        this.segments = new ArrayList<>(Arrays.asList(s));
        this.value = p.get_x_coord();
        this.type = type;
        
    }

    Event(Point p, ArrayList<Segment> s, int type) {
      
        this.point = p;
        this.segments = s;
        this.value = p.get_x_coord();
        this.type = type;
        
    }

    public void addPoint(Point p) { this.point = p; }

    public Point getPoint() { return this.point; }

    public void addSegment(Segment s) { this.segments.add(s); }

    public ArrayList<Segment> getSegments() { return this.segments; }

    public void setType(int type) { this.type = type; }

    public int getType() { return this.type; }

    public void setValue(double value) { this.value = value; }

    public double getValue() { return this.value; }

}

////////////////////////////////////////////////////////////
void setup(){
  background(255);

  //draw line
  line(0,150, 1200, 150);
  
  size(1200,800);
  frameRate(60);
  
  fill(0);
  textSize(30);
  text("Sweep Line Algorithm Animation", 10, 30);
  
  textSize(20);
  text("Press 'p' to run animation", 10, 60);
  
}

void draw(){
  //background(255);
   
   
  line(0,150, 1200, 150);
  for (Point p : points) { p.draw(); }
  
  for (Segment s  : segments) { s.draw(); }
  
  if (sweepLine != null){
  
  while(!sweepLine.Q.isEmpty()) {
    
    Event e = sweepLine.Q.poll();
    
    strokeWeight(2);
    line((float)e.point.get_x_coord(), 1200, (float)e.point.get_x_coord(), 150);
    
    if (e.getType() == 0) {
      
      text("Segment Top", 10, 80);
      
    } else if (e.getType() == 1) {
      
      text("Segment bottom", 10, 80);
      
    } else if (e.getType() == 2) {
      
      text("Intersection", 10, 80);
      
    }
    
  }
  }
 
}

void keyPressed(){
  
  if( key == 'p' ) {
    
      sweepLine = new BentleyOttmann(segments);
      sweepLine.SweepLine();
      sweepLine.printOutput();
      
  } else if( key == 'c' ) { segments.clear(); points.clear(); } 
  
}

void mousePressed(){
  
  double mouseXC = mouseX;
  double mouseYC = mouseY;

  if (startPoint) {
    
    prevPoint = new Point(mouseXC, mouseYC);
    startPoint = false;
    endPoint = true;
    
  } else if (endPoint) {
    
    currPoint = new Point(mouseXC, mouseYC);
    
    segment = new Segment(prevPoint, currPoint);

    segments.add(segment);
    
    points.add(prevPoint);
    points.add(currPoint);
    
    startPoint = true;
    endPoint = false;
    
  };
  
}   

void mouseReleased(){
  
  if (!endPoint){
    prevPoint = null;
    currPoint = null;
  }
  
}
 
    
  
