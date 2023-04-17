class Fish {
  //個々のFishインスタンスがもつ変数
  float posX, posY;
  float dx, dy;
  float ctrDirX, ctrDirY;
  float vel, velAngle;
  float contX, contY;
  float kX, kY;
  int fSize;
  PImage img;
  
  //コンストラクタ，new Fish() したときに実行される関数
  Fish(float x, float y, int fishCount, int index) {
    //total++;
    posX = x;
    posY = y;
    ctrDirX = 0.0;
    ctrDirY = 0.0;
    vel = random(0, 5.5);
    dx = -vel * cos(radians(velAngle));
    dy = -vel * sin(radians(velAngle));
    contX = 0.0;
    contY = 0.0;
    kX = 0.0;
    kY = 0.0;
    fSize = 150;
    if(total == 0){
      velAngle = (360 / fishCount) * index;
      String imagePath = "sakura" + (index % 2) + ".png";
      img = loadImage(imagePath);
      img.resize(fSize, 0);
    } else {
      try{
      velAngle = (360 / fishCount) * total;
      String imagepath = total + ".png";
      img = loadImage(imagepath);
      img.resize(fSize, 0);
      }
      catch(NullPointerException e){
        velAngle = (360 / fishCount) * index;
        img = loadImage("sakura0.png");
        img.resize(fSize, 0);
    }
   }
  }
  
  //ここらへんはctrDirX・Y, kX, kY, contX, contYとかの変数を求める関数たち
  void setCtrDir(float aveX, float aveY) {
    ctrDirX = aveX - posX;
    ctrDirY = aveY - posY;
  }
  
  void setK(float velX, float velY) {
    kX = 0.03 * ctrDirX + 4.0 * velX + 7.5 * contX;
    kY = 0.03 * ctrDirY + 4.0 * velY + 7.5 * contY;

    float tempVel = sqrt(kX*kX+kY*kY);
    if (2 < tempVel) {
      kX = 2 * kX / tempVel;
      kY = 2 * kY / tempVel;
    }
  }
  
  void setCont(ArrayList<Fish> fishes) {
    contX = 0.0;
    contY = 0.0;
    for (Fish f: fishes) {
      float d = sqrt((posX-f.posX)*(posX-f.posX)+ (posY-f.posY)*(posY-f.posY));
      if (0 < d && d < 400) {
        contX = -1 * (f.posX - posX);
        contY = -1 * (f.posY - posY);
        float temp = sqrt(contX*contX+contY*contY);
        contX /= temp;
        contY /= temp;
      }
    }
  }
  
  //画像を描画する
  void display() {
    image(img, posX, posY);
  }
  
  //魚の座標(posX, posY)をdx, dy分移動させる．画面端に行ってたら反対側に移動する
  void move() {
    dx += (kX - dx) * 0.02;
    dy += (kY - dy) * 0.02;
    
    posX += dx;
    posY += dy;
    
    if (posX > width) posX = 0;
    if (posX < 0) posX = width;
    if (posY > height) posY = 0;
    if (posY < 0) posY = height;
  }
  
 
}
