import processing.serial.*;

Serial port;
int Arduino_data;
boolean flag = false; //basetime決定用フラグ
boolean new_flag = false; //関数カウントダウン用の調整用フラグ

int sound_flag = 0;
int base_time = 0;
int cur_time = 0;
int sa = 0;

void setup(){
  frameRate(60);
  size(800, 500);
  textSize(70);
  textAlign(CENTER);
  port = new Serial(this, "COM12", 9600);  //Serial.(this, ポート番号, シリアル通信速度)
  background(255);
  }

void serialEvent(Serial port){
  // シリアルポートからデータを受け取ったら
  if (port.available() >= 1){
    Arduino_data = port.read();
    if (Arduino_data == 1){
      println("Arduino_data == 1");
      flag = true;
      }
    else{
      println("Arduino_data == 0");
      flag = false;
      }    
    }
  }

void countdown(){
  cur_time = millis();
  sa = cur_time - base_time;
  println(sa, cur_time, base_time);
  if(sa>=0 && sa<1000){
    background(0);
    text("3", width/2, height/2);}
  else if(sa>=1000 && sa <2000){
    background(0);
    text("2", width/2, height/2);}
  else if(sa >= 2000 && sa < 3000){
    background(0);
    text("1", width/2, height/2);}
  else{
    sound_flag = 1;
    new_flag = false;}
  }

void draw(){
  if(flag){
    base_time = millis();
    //println(base_time);
    flag = false;
    new_flag = true;
      }
  if(new_flag){
    countdown();
    }
  }
