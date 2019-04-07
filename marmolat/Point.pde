class Point {
  float x,y;
  float xv = 0;
  float yv = 0;
  float maxSpeed = 3000000;
  boolean finished = false;
  color c;

  Point(float _x, float _y, color _c){
    this.x = _x;
    this.y = _y;
    this.c = _c;
  } 

  void update(){
    stroke(hue(c)+10*sin(millis()*0.002),saturation(c),brightness(c)+8*sin(millis()*0.004),100);
    this.xv = cos(  noise(this.x*.01,this.y*.01)*TWO_PI  );
    this.yv = -sin(  noise(this.x*.01,this.y*.01)*TWO_PI  );

    if(this.x>width){
      //this.x = 1;
      this.finished = true;
    }
    else if(this.x<0){
      //this.x = width-1;
      this.finished = true;
    }
    if(this.y>height){
      //this.y = 1;
      this.finished = true;
    }
    else if(this.y<0){
      //this.y = height-1;
      this.finished = true;
    } 

    if(this.xv>maxSpeed){
      this.xv = maxSpeed;
    }
    else if(this.xv<-maxSpeed){
      this.xv = -maxSpeed;
    }
    if(this.yv>maxSpeed){
      this.yv = maxSpeed;
    }
    else if(this.yv<-maxSpeed){
      this.yv = -maxSpeed;
    }

    this.x += this.xv;
    this.y += this.yv;
    line(this.x+this.xv, this.y+this.yv,this.x,this.y );
  }
}