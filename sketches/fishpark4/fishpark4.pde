int num = 10;
int total = 0;
float aveX, aveY = 0.0;
float aveAngle, aveVel = 0.0;
float velX, velY = 0;
ArrayList<Fish> fishes = new ArrayList<Fish>();


void setup() {
  size(1600, 900);
  smooth();
  frameRate(30);
  for (int i = 0; i < num; i++) {
    fishes.add(new Fish(width/2, height/2, num));
  }
}

void draw() {
  background(47,106,222);
  aveX = calcAveX(fishes);
  aveY = calcAveY(fishes);
  aveVel = calcAveVel(fishes);
  aveAngle = calcAveAngle(fishes);
  velX = aveVel*cos(radians(aveAngle));
  velY = aveVel*sin(radians(aveAngle));
  
  //ここでfishesに入ってる個々のfishの変数をアップデートして描画する
  for (Fish f: fishes) {
    f.setCtrDir(aveX, aveY);
    f.setCont(fishes);
    f.setK(velX, velY);
    f.move();
    f.display();
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

//キー入力があったら新しいFishを作成,fishesに追加する
void keyPressed() {
  fishes.add(new Fish(width/2, height/2, fishes.size()));
}
