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
AudioInput input;
AudioRecorder recorder;
SoundFile soundfile;
Amplitude amp;
FFT fft;
OscP5 osc; //OSCP5クラスのインスタンス
NetAddress client; //ProcessingのOSC送出先のネットアドレス
AudioPlayer player; //カウントダウン音再生用

int CHUNK = 4096;  // 窓長
int WAVE_HEIGHT = 80;  // 波形の高さ
int DURING = 2;  // 録音時間

String scene = "start";
int time1 = 0;
String filename = "null";
int take = 0;
float amp_max = 0;
float f_max = 0;
int f_max_index = 0;

String lines[];
String words = "";


void setup(){
  frameRate(60);
  size(800, 500);
  textSize(70);
  textAlign(CENTER);
  background(255);
  
  //認識・カウントダウン用
  port = new Serial(this, "COM12", 9600);  //Serial.(this, ポート番号, シリアル通信速度)
  minim = new Minim(this);  // 初期化
  player = minim.loadFile("./countdown_sound.mp3");
  
  //録音・解析用
  input = minim.getLineIn(Minim.MONO);  // インプット
  textFont(createFont("Arial", 12));  // フォント
  stroke(255);  // 色
  
  client = new NetAddress("127.0.0.1",6700); //(Pythonの受信ポート)
  osc = new OscP5(this, 6701); // OSCの初期化 (Processingの受信ポート)
  }

//コイン認識部
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

//カウントダウン用
void countdown(){
  player = minim.loadFile("./countdown_sound.mp3");
  player.play(); 
  //sound_flag = 1;
  new_flag = false;
  scene = "start";
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
    }
  common();
  if (scene == "start") start_scene();
  if (scene == "recording") recording_scene();
  if (scene == "processing") processing_scene();
  if (scene == "end") end_scene();
}


// 毎回呼び出される
void common() {
  background(0);
}
  // スタート画面
void start_scene() {
  text("Press SPACE to record.", 5, 15);
  time1 = int(input.sampleRate()*DURING/input.bufferSize());
  amp_max = 0;
  f_max = 0;
  f_max_index = 0;
  filename = "rec" + String.valueOf(take) + ".wav";
  recorder = minim.createRecorder(input, filename);  // 
  
  take++;
  scene = "recording";
}

// 録音中
void recording_scene() {
  text("Currently recording...", 5, 15);
  //println("begin");
  recorder.beginRecord();
  for (int i = 0; i < input.bufferSize(); i++) {
    point(i, height/2 + input.left.get(i)*WAVE_HEIGHT);
  }
  time1--;
  if (time1 == 0) scene = "processing";
  //println("Label"+time1);
}

// 処理中
void processing_scene() {
  text("processing...", 5, 15);
  recorder.endRecord();
  println("end");
  recorder.save();
  println("finish");
  send_msg();
  soundfile = new SoundFile(this, filename);
  amp = new Amplitude(this);
  amp.input(soundfile);
  fft = new FFT(this, CHUNK);
  fft.input(soundfile);
  soundfile.play();
  scene = "end";
}

// 終了画面
void end_scene() {
  amp_max = max(amp_max, amp.analyze());
  float[] tmp = fft.analyze();
  for(int i = 1; i < tmp.length; i++) {
    if(tmp[i] > f_max) {
      f_max = tmp[i];
      f_max_index = i;
    }
  }
  text(amp_max * 2, 5, 15);  // 音量
  text(f_max_index * input.sampleRate()/CHUNK/2, 5, 30);  // 周波数
  text("Press SPACE to restart.", 5, 45);
  //sound_flag=0;
}

// 　イベント処理
void keyReleased() {
  if (key == ' ') {
    if (scene == "start") {
      scene = "recording";
      println("start");
      recorder = minim.createRecorder(input, filename);  // 
      
      take++;
    }
    if (scene == "end") scene = "start";
  }
}

//メッセージの送信
void send_msg(){
  OscMessage msg = new OscMessage("/wave2text");
  msg.add(filename); //録音したwaveファイルのfilenameを送信
  osc.send(msg, client);//OSCメッセージ送信
}

void oscEvent(OscMessage msg) {
  // アドレス /texts に文字列を受信したら，それを表示する
  if (msg.checkAddrPattern("/done")) {
    int done = msg.get(0).intValue(); //メッセージを受け取ったタイミングでtxtファイルを読み込むための通信
    words = readFile();
    println(words);

  }
}

String readFile() {
  lines = loadStrings("result.txt");
  String texts = lines[0];
  texts = texts.substring(1); //1文字目の"?"を削除
  return texts;
}

//player.playのために必要？
void stop() {
  player.close();
  minim.stop();
  super.stop();
}
