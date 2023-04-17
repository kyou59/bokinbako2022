import processing.net.*;
 
Client myClient; //Juliusとの連携で必要
String word="";

int movieWidth = 900 ;
int movieHeight = 900;
int FR = 60;
boolean isOpen = false; 

//地面に触れることによる速度の減退
final float damp = 0.95;

// テキストクラス
class Text {
  //表示するテキスト
  public String text;
  //X座標
  public float X;
  //Y座標
  public float Y;
  //X速度
  public float speedX;
  //Y速度
  public float speedY;
  //テキストサイズ
  public int size;
  
  //コンストラクタ
  public Text(String text, float X, float Y, float speedX, float speedY) {
   // 指定されたtext,X,Y,speedを設定
    this.text = text;
    this.X = X;
    this.Y = Y;
    this.speedX = speedX;
    this.speedY = speedY;
    this.size = int(random(8, 44));
    
  }
}
ArrayList<Text> texts = new ArrayList<Text>();

// 重力加速度
final float GRAVITY = 9.8;
final float reaction = 0.7;


void setup() {
  fullScreen();
  myClient = new Client(this,"localhost",10500); //Juliusとの連携で必要
  //フォントを設定
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  //動画の大きさを設定
  surface.setSize(movieWidth, movieHeight);
  //myMovie = new Movie(this, "drop.mp4");
  //myMovie.loop();
  //myMovie.play();
  
  frameRate(FR);
}
void draw() {
  String tmpword = getWord(); //ここでJuliusで認識した音声を読み取る
  String tmpword2 = "";
  
  if(!(tmpword.equals(tmpword2))||frameCount==1) {
    isOpen = true;
  } else {
    isOpen = false;
  }
  tmpword2 = tmpword;
    //新しい文字列を受け取ったときだけけ新しいテキストを追加
  if(isOpen) {
    // テキスト初速(マイナスは上方向)
    float initSpeedX = random(-30, 30);
    float initSpeedY = random(-20, 0);
    // テキスト一覧にテキストを追加
    texts.add(new Text(tmpword, width/2, height/2, initSpeedX, initSpeedY));
  }

  // 白に塗りつぶし
  background(200);
  //image(myMovie, 0, 0);
  // テキストのスタイル設定
  // テキストの塗りつぶし
  fill(0,0,0);


  // テキストの数だけ描画する
  for(int i = texts.size() -1; i >= 0; i--) {
    // テキストデータを一覧から取得
    Text text = texts.get(i);
    //テキストサイズを指定
    textSize(text.size);
    // テキストを描画
    text(text.text, text.X, text.Y);
    // テキストの次の位置を計算する
    // スピードに加速度を加算
    text.speedY += GRAVITY / 5;
    // X座標
    text.X += text.speedX / 5;
    // Y座標に速度分追加
    text.Y += text.speedY / 5;
    if (text.X > width || text.X < 0) text.speedX = -text.speedX;
    if (text.Y > height) {
      text.speedY *= -reaction;
      text.speedX *= damp;
      text.Y = height;    //テキストは画面の外に外れない
    }
    
  }
}

//これ以降がJuliusとの連携部分
 
String getWord(){
  String word = "";
  if (myClient.available()>0){
    String dataIn = myClient.readString();
    String[] sList = split(dataIn, "WORD");
    for(int i=1;i<sList.length;i++){
      String tmp = sList[i];
      String[] tList = split(tmp, '"');
      word += tList[1];
    }
  }
  if (word != ""){
    println(word);
  }
  return word;
}
