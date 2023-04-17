int num = 10;
int total = 0;
float aveX, aveY = 0.0;
float aveAngle, aveVel = 0.0;
float velX, velY = 0;
ArrayList<Fish> fishes = new ArrayList<Fish>();

float x0, x1, x2, x3, x4, x5, x6, x7;
float x11, x12, x13, x14, x15, x16;
float y11, y12, y13, y14, y15, y16;


void setup() {
  size(1600, 900);
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
  x6 = 900;
  x7 = 300;
  
  y11 = 900;
  y12 = 600;
  y13 = 550;
  y14 = 950;
  y15 = 1100;
  y16 = 1050;
}

void draw() {
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
   triangle( 250, -100, x0, 900, x0+170, 900);
   
   x1 += 1;
   fill(0,255,255,20);
   noStroke();
   if ( x1 >800) x1 = 0;
   triangle( 370, -250, x1, 900, x1+250, 900);

   x2 += 2;
   fill(0,255,255,10);
   noStroke();
   if ( x2 >800) x2 = 200;
   triangle( 260, -300, x2, 900, x2+270, 900);

   x3 += 3;
   fill(0,255,255,20);
   noStroke();
   if ( x3 >700) x3 =50;
   triangle( 250, -500, x3-150, 900, x3+350, 900);
   
   x4 -= 2;
   fill(0,255,255,10);
   if ( x4 <-150) x4 = 500;
   triangle( 270, -500, x4, 900, x4+250, 900);
   
   x5 -= 3;
    fill(0,255,255,20);
   noStroke();
   if ( x5 <20) x5 = 500;
   triangle( 270, -500, x5-200, 900, x5+450, 900);
   
   x6 -= 1;
   fill(0,255,255,10);
   noStroke();
   if ( x6 <-200) x6 =300;
   triangle( 270, -500, x6, 900, x6+220, 900);

   x7 -= 4;
   fill(0,255,255,10);
   noStroke();
   if ( x7 <-50) x7 =100;
   triangle( 270, -500, x7-100, 900, x7+300, 900);
   
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
  total++;
  fishes.add(new Fish(width/2, height/2, fishes.size(), 0));
}
