import processing.serial.*;
import ddf.minim.*;
import processing.sound.*;
import netP5.*;
import oscP5.*;
import java.io.UnsupportedEncodingException;

Serial port;
//以下コイン認識-カウントダウン用
int Arduino_data;
boolean flag = false; //basetime決定用フラグ
boolean new_flag = false; //関数カウントダウン用の調整用フラグ

//int sound_flag = 0;
int base_time = 0;
int cur_time = 0;
int sa = 0;

//以下録音・解析用
Minim minim;
AudioIn input;
Amplitude rms;
// AudioInput input;
AudioRecorder recorder;
SoundFile soundfile;
Amplitude amp;
FFT fft;
OscP5 osc; //OSCP5クラスのインスタンス
NetAddress client_py, client_pro; //ProcessingのOSC送出先のネットアドレス
AudioPlayer player; //カウントダウン音再生用


// グローバル変数
int take = 0; // 何回目の録音か記録するため必要
int duration = 5; //5秒間録音
int recordingDelay = 0; //endrecordまでdelayかける用のcounter
String words = ""; // 音声認識の結果
boolean isRecording;
int trans_num = 29; //水槽に表示する魚のファイル名

int bands = 512;
float[] spectrum = new float[bands];

float amp_max = 10; // 音量の最大値を格納

//String filename = "rec" + str(trans_num) + ".wav";

// 水槽
int num = 10;
int total = 0;
float aveX, aveY = 0.0;
float aveAngle, aveVel = 0.0;
float velX, velY = 0;
ArrayList<Fish> fishes = new ArrayList<Fish>();

float x0, x1, x2, x3, x4, x5, x6, x7;
float x11, x12, x13, x14, x15, x16;
float y11, y12, y13, y14, y15, y16;

// Tsubasa t1 = new Tsubasa(); // 引数に録音したい時間[s]を与える

void setup(){
  textSize(70);
  textAlign(CENTER);
  // background(255);
  
  isRecording = false;
  
  //認識・カウントダウン用
  port = new Serial(this, "COM6", 9600);  //Serial.(this, ポート番号, シリアル通信速度)
  minim = new Minim(this);  // 初期化
  player = minim.loadFile("./countdown_sound.mp3");
  
  //録音・解析用
  // input = minim.getLineIn(Minim.MONO);  // インプット
  
  client_py = new NetAddress("127.0.0.1",6700); //(Pythonの受信ポート)
  osc = new OscP5(this, 6701); // OSCの初期化 (Processing(main)の受信ポート)
  client_pro = new NetAddress("127.0.0.1",6702); //(Processing(turringpattern)の受信ポート)
  
  input = new AudioIn(this, 0);
  input.start();
  rms = new Amplitude(this);
  rms.input(input);
  
  // 水槽用
  size(1920, 1200);
  smooth();
  frameRate(30);
  for (int i = 0; i < num; i++) {
    fishes.add(new Fish(width/2, height/2, num, i));
  }
  x0 = 300;
  x1 = 0;
  x2 = 600;
  x3 = 150;
  x4 = 1500;
  x5 = 1500;
  x6 = 1080;
  x7 = 300;
  
  y11 = 1080;
  y12 = 600;
  y13 = 550;
  y14 = 950;
  y15 = 1100;
  y16 = 1050;
  
  
}

//コイン認識部
void serialEvent(Serial port){
  // シリアルポートからデータを受け取ったら
  if (port.available() >= 1){
    Arduino_data = port.read();
    if (Arduino_data == 1){
      // println("Arduino_data == 1");
      flag = true;
      }
    else{
      // println("Arduino_data == 0");
      flag = false;
      }    
    }
}

//カウントダウン用
void countdown(){
  player = minim.loadFile("./countdown_sound.mp3");
  player.play(); 
  //sound_flag = 1;
  new_flag = false;
  print(take);
}


void draw(){
  
  if(flag){
    flag = false;
    new_flag = true;
    }
  if(new_flag){
    countdown();
    delay(3500);
    isRecording = true;
    }
  if(isRecording){
    if(recordingDelay > duration*100){    
      OscMessage send_msg = new OscMessage("/turingpattern");
      send_msg.add(amp_max);
      osc.send(send_msg,client_pro);//音量，周波数，フレーズを送信 
      recordingDelay = 0;
      amp_max = 1;
      isRecording = false;
    }
    else{
      // float diameter = map(rms.analyze(), 0.0, 1.0, 0.0, width);
      amp_max = max(amp_max, rms.analyze());
      delay(1);
      recordingDelay++;
    }
  
  }
  common();
}


// 毎回呼び出される
void common() {
  background(40, 40, 255);
  //background(47,106,222);
  aveX = calcAveX(fishes);
  aveY = calcAveY(fishes);
  aveVel = calcAveVel(fishes);
  aveAngle = calcAveAngle(fishes);
  velX = aveVel*cos(radians(aveAngle));
  velY = aveVel*sin(radians(aveAngle));
     
   //light
   x0 += 4;
   noStroke();
   fill(0,255,255,10);
   if ( x0 >550) x0 = 100;
   triangle( 250, -100, x0, 1080, x0+170, 1080);
   
   x1 += 1;
   fill(0,255,255,20);
   noStroke();
   if ( x1 >800) x1 = 0;
   triangle( 370, -250, x1, 1080, x1+250, 1080);

   x2 += 2;
   fill(0,255,255,10);
   noStroke();
   if ( x2 >800) x2 = 200;
   triangle( 260, -300, x2, 1080, x2+270, 1080);

   x3 += 3;
   fill(0,255,255,20);
   noStroke();
   if ( x3 >700) x3 =50;
   triangle( 250, -500, x3-150, 1080, x3+350, 1080);
   
   x4 -= 2;
   fill(0,255,255,10);
   if ( x4 <-150) x4 = 500;
   triangle( 270, -500, x4, 1080, x4+250, 1080);
   
   x5 -= 3;
    fill(0,255,255,20);
   noStroke();
   if ( x5 <20) x5 = 500;
   triangle( 270, -500, x5-200, 1080, x5+450, 1080);
   
   x6 -= 1;
   fill(0,255,255,10);
   noStroke();
   if ( x6 <-200) x6 =300;
   triangle( 270, -500, x6, 1080, x6+220, 1080);

   x7 -= 4;
   fill(0,255,255,10);
   noStroke();
   if ( x7 <-50) x7 =100;
   triangle( 270, -500, x7-100, 1080, x7+300, 1080);
   
   //bubble
   y11 -= 9;
   x11 =random(470,500);
   fill(255,255,255,20);
   noStroke();
   if ( y11 <-50) y11 =2500;
   ellipse(x11,y11,40,30); 
   ellipse(x11,y11-2,34,24);
   ellipse(x11-4,y11-6,10,6);
   
   y12 -= 6;
   x12 =random(70,100);
   fill(255,255,255,20);
   noStroke();
   if ( y12 <-50) y12 =950;
   ellipse(x12,y12,40,30); 
   ellipse(x12,y12-2,34,24);
   ellipse(x12-4,y12-6,10,6);
   
   y13 -= 7;
   x13 =random(1570,1600);
   fill(255,255,255,20);
   noStroke();
   if ( y13 <-50) y13 =1100;
   ellipse(x13,y13,40,30); 
   ellipse(x13,y13-2,34,24);
   ellipse(x13-4,y13-6,10,6);
   
   y14 -= 8;
   x14 =random(1370,1400);
   fill(255,255,255,20);
   noStroke();
   if ( y14 <-50) y14 =1400;
   ellipse(x14,y14,40,30); 
   ellipse(x14,y14-2,34,24);
   ellipse(x14-4,y14-6,10,6);

   y15 -= 9;
   x15 =random(970,1000);
   fill(255,255,255,20);
   noStroke();
   if ( y15 <-50) y15 =1200;
   ellipse(x15,y15,40,30); 
   ellipse(x15,y15-2,34,24);
   ellipse(x15-4,y15-6,10,6);

   y16 -= 8;
   x16 =random(720,750);
   fill(255,255,255,20);
   noStroke();
   if ( y16 <-50) y16 =1400;
   ellipse(x16,y16,40,30); 
   ellipse(x16,y16-2,34,24);
   ellipse(x16-4,y16-6,10,6);
  
  //ここでfishesに入ってる個々のfishの変数をアップデートして描画する
  for (Fish f: fishes) {
    f.setCtrDir(aveX, aveY);
    f.setCont(fishes);
    f.setK(velX, velY);
    f.move();
    f.display();
  }
}

void oscEvent(OscMessage msg) {
    //ここでturingpatternからunion.pngの生成完了の合図を受取り，transさせる
    if (msg.checkAddrPattern("/createdunion")){
      println("received at createdunion");
      String union_filename = msg.get(0).stringValue();
      OscMessage send_msg = new OscMessage("/trans");
      // send_msg.add(union_filename); //生成したturingpatternで生成したpngファイルのfilenameを送信
      send_msg.add(str(trans_num) +".png"); //生成してほしいpngファイルのファイルネームを送信
      osc.send(send_msg, client_py);//OSCメッセージ送信
    }
    // union.pngが生成された通知を受け取る
    if (msg.checkAddrPattern("/createdtrans")){
      int createdunion = msg.get(0).intValue(); //メッセージを受け取ったタイミングでtxtファイルを読み込むための通信
      println("created " +str(trans_num) +".png");
      trans_num++;
    }
    
  }

// 　イベント処理
void keyReleased() {
  if (key == ' ') {
    flag = true; // Arduinoからの信号の代わり
  }
  
  if (key == 'p' || key == 'P') {
    total++;
    println("total; "+total);
    fishes.add(new Fish(width/2, height/2, fishes.size(), 0));
  }
}


//ここらへんは，平均に関するパラメタを求める関数
float calcAveX(ArrayList<Fish> fishes) {
  float aveX = 0.0;
  for (Fish f: fishes) {
    aveX += f.posX;
  }
  aveX /= fishes.size();
  return aveX;
}

float calcAveY(ArrayList<Fish> fishes) {
  float aveY = 0.0;
  for (Fish f: fishes) {
    aveY += f.posY;
  }
  aveY /= fishes.size();
  return aveY;
}
  
float calcAveVel(ArrayList<Fish> fishes) {
  float aveVel = 0.0;
  for (Fish f: fishes) {
    aveVel += sqrt(f.dx * f.dx + f.dy * f.dy);
  }
  aveVel /= fishes.size();
  return aveVel;
}
  
float calcAveAngle(ArrayList<Fish> fishes) {
  float aveAngle = 0.0;
  for (Fish f: fishes) {
    aveAngle += degrees(atan2(f.dy, f.dx));
  }
  aveAngle /= fishes.size();
  return aveAngle;
}


//player.playのために必要？
void stop() {
  player.close();
  minim.stop();
  super.stop();
}
