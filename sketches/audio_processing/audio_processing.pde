import ddf.minim.*;

Minim minim;
AudioInput input;
AudioRecorder recorder;

int CHUNK = 1024;  // チャンクサイズ
int WAVE_HEIGHT = 80;  // 波形の高さ
int DURING = 5;  // 録音時間

String scene = "start";
int time = 0;

void setup() {
  size(512, 200);  // ウィンドウの設定
  minim = new Minim(this);  // 初期化
  input = minim.getLineIn(Minim.MONO, 1024);  // インプット
  recorder = minim.createRecorder(input, "myrecording.wav");  // レコーダー
  textFont(createFont("Arial", 12));  // フォント
  stroke(255);  // 色
}

// 画面遷移
void draw() {
  common();
  if (scene == "start") start_scene();
  if (scene == "recording" && time > 0) recording_scene();
  if (scene == "recording" && time == 0) processing_scene();
  if (scene == "end") end_scene();
}

// 毎回呼び出される
void common() {
  background(0);
}

// スタート画面
void start_scene() {
  text("Press SPACE to record.", 5, 15);
  time = int(input.sampleRate()*DURING/input.bufferSize());
}

// 録音中
void recording_scene() {
  text("Currently recording...", 5, 15);
  recorder.beginRecord();
  for (int i = 0; i < input.bufferSize(); i++) {
    point(i, height/2 + input.left.get(i)*WAVE_HEIGHT);
  }
  time--;
}

// 処理中
void processing_scene() {
  text("processing...", 5, 15);
  recorder.endRecord();
  recorder.save();
  scene = "end";
}

void end_scene() {
  text("Press SPACE to restart.", 5, 15);
}

// 　イベント処理
void keyReleased() {
  if (key == ' ') {
    if (scene == "start") scene = "recording";
    if (scene == "end") scene = "start";
  }
}
