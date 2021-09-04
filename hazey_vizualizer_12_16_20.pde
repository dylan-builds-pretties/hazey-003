import processing.sound.*;

SoundFile[] file;
Amplitude[] amp;
int numsounds = 9;
float songtime = 162.16217;
float mouseClick;

float grid = 100;
float marginX = 110;
float marginY = 94;

float wave; 

float drumSmoothed;
float padSmoothed;
float bassSmoothed;
float pianoSmoothed;
float pad3Smoothed;
float fx1Smoothed;

float pushCircles;


void setup(){
  size(1920,1080,FX2D);
  
  file = new SoundFile[numsounds];
  amp = new Amplitude[numsounds];
  for (int i = 0; i < numsounds; i++){
    file[i] = new SoundFile(this, (i) + ".wav");
    amp[i] = new Amplitude(this);
    amp[i].input(file[i]);
  }
  
  for (int i = 0; i < numsounds; i++) {
    file[i].play();
  }
  
}

void draw(){
  background(255);
  
  noStroke();
  //Circles and Triangle
  push();
  translate(width/2,height/2);
  if(pad3Smoothed > 0.003){
    fill(50-wave*100+pad3Smoothed*100,180-wave*100,100+wave*500,20+pad3Smoothed*200);
    rotate(radians(-frameCount*1.1));
    circle(-290,-200,200+pad3Smoothed*3000);
    circle(290,-200,200+pad3Smoothed*3000);
    circle(0,320,200+pad3Smoothed*3000);
    pop();
    push();
    translate(width/2,height/2);
    fill(50-wave*100+pad3Smoothed*100,180-wave*100,100+wave*500,20+pad3Smoothed*200);
    rotate(radians(frameCount*1.1));
    circle(-290,-200,200+pad3Smoothed*3000);
    circle(290,-200,200+pad3Smoothed*3000);
    circle(0,320,200+pad3Smoothed*3000);
    
    
  //triangle(-290,-200,290,-200,0,320);
  }
  pop();
  
  //Matrix Circles
  for(float i = marginX; i <width-30; i+= grid){
    for(float j = marginY; j < height-30; j+=grid){
      pushMatrix();
      translate(i,j);
      rotate(radians(frameCount));
      strokeWeight(4);
      stroke(10,20,120+(padSmoothed*200),20+padSmoothed*200);
      fill(150-wave*100+amp[6].analyze()*100,80-wave*100,100+wave*500,50);//amp[6].analyze()*200);
      circle(0,0,padSmoothed*(2000));
      
      //FX1
      if(fx1Smoothed > 0.01){
        circle(0,0,150+frameCount/20);
      }
      popMatrix();
    }
  }
  
  
  
  //Grid lines
  strokeWeight(4+amp[6].analyze()*150);
  stroke(10,20,120+(amp[6].analyze()*200),20+amp[6].analyze()*1000);
  for(float i = 0; i <width; i+= grid){
    line(i,0,i,height);
  }
  for(float i = 0; i <height; i+= grid){
    line(0,i,width,i);
  }
  
  
  
  /*
    //Border
  noFill();
  strokeWeight(60);
  stroke(30,10,180);
  rect(0,0,1920,1080);
  */

  
  
  //Bass
  if(bassSmoothed > 0.01){
    for(int i = 0; i < 25; i = i+ 5){
      fill(i*2*bassSmoothed*100,i*2.5,200+i,25+bassSmoothed*30);
      noStroke();
      if(millis() < 53000){
        circle(width/2,height/2,50+(bassSmoothed*600*i));
      }
      if(millis() > 53000 && millis() < 111000){
        circle(width/2,height/2,50+(bassSmoothed*800*i));
      }
      if(millis() > 111000){
        circle(width/2,height/2,50+(bassSmoothed*1000*i));
      }
    }
  }
 
  
  //Drums + Bass
  for(int i = 0; i < 25; i = i+ 5){
    noFill();
    strokeWeight(i+1);
    stroke(i*2*bassSmoothed*100,i*2+10.5,200+i);
    if(millis() < 53000){
      circle(width/2,height/2,50+(drumSmoothed*200*i));
    }
    else if(millis() > 53000 && millis() < 111000){
      circle(width/2,height/2,50+(drumSmoothed*400*i));
    }
    else if(millis() > 111000){
      circle(width/2,height/2,50+(drumSmoothed*1000*i));
    }
  }
  
  //Piano + Pad1
  for(int i = 0; i < 5; i++){
    noFill();
    strokeWeight(i+1);
    stroke(170+i*2*amp[1].analyze(),i+5,100+i*5);
    circle(width/2,height/2,50+(amp[1].analyze()*1000*i));
    if(amp[1].analyze() > 0.001){
      stroke(170+i*2*amp[1].analyze(),i+5,100+i*5,pianoSmoothed*50000);
      ellipse(width/2,height/2,50+(amp[1].analyze()*1000*i),750+(amp[1].analyze()*1000*i));
    }
  }
  
  //circle(100,100,100+amp[5].analyze()*1000);
  
  
  
  pushCircles = pad3Smoothed*3000;
  fx1Smoothed = fx1Smoothed * 0.9 + amp[8].analyze()*0.1;
  drumSmoothed = drumSmoothed * 0.1 + amp[0].analyze() * 0.9;
  pianoSmoothed = pianoSmoothed * 0.9 + amp[1].analyze() * 0.1;
  padSmoothed = padSmoothed * 0.9 + amp[2].analyze() * 0.1;
  pad3Smoothed = pad3Smoothed * 0.9 + amp[7].analyze() * 0.1;
  bassSmoothed = bassSmoothed * 0.1 + amp[3].analyze() * 0.9;
  wave = cos(radians(frameCount));

  println(millis());
}

void mousePressed(){
  mouseClick = map(mouseX,0,width,0,songtime); 
  for (int i = 0; i < numsounds; i++){
    file[i].jump(mouseClick);
  }
}
