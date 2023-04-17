// basic_image_sample1

int num = 80;

int X = 0;
int Y = 0;
int dir_x = 1;
int dir_y = 1;
int speed = 3;

float[] x  =new float[num];
float[] y  =new float[num];
float[] r  =new float[num];
float[] dx  =new float[num];
float[] dy  =new float[num];

float[] ctrDirX =new float[num];    
float[] ctrDirY =new float[num];    
float[] vel =new float[num];
float[] velAngle =new float[num];
float[] contX =new float[num];    
float[] contY =new float[num];    
float[] kX =new float[num];    
float[] kY =new float[num];    

float aveX, aveY, aveAngle, aveVel;
float velX, velY;

PImage img;

void setup() {
  for (int i=0; i<num; i++) {
    r[i]     = 10;
    x[i]     = 250+80*cos(radians((360/num)*i));
    y[i]     = 250+80*sin(radians((360/num)*i));
    velAngle[i] = (360/num)*i;
    vel[i]   = random(0, 5.5);
    dx[i]    = vel[i]*cos(radians(velAngle[i]));
    dy[i]    = vel[i]*sin(radians(velAngle[i]));
  }
  
  size(1600, 900);       //画面比
  //colorMode( RGB, 255 );
  //background(47,106,222);  //背景青
  smooth();
  frameRate( 30 );
  img = loadImage( "アートボード1.png" );
}

void draw() {
  colorMode( RGB, 255 );
  background(47,106,222);
  for(int i=0; i<num; i++){
    image(img, x[i], y[i]);    
  }

//群れの中心に向かう部分
  aveX = 0;
  aveY = 0;
  for (int i=0; i<num; i++) {
    aveX += x[i];
    aveY += y[i];
  }
  aveX /= num;
  aveY /= num;
  
  if (mousePressed == true) {
    aveX = mouseX;
    aveY = mouseY;
    //stroke(0, 0, 255);  //線の色
    //fill(0, 0, 255); //色
    //ellipse(aveX, aveY, 10, 10);  //円の描画
    image(img, aveX, aveY);
  } 

   for (int i=0; i<num; i++) {
    ctrDirX[i] = aveX - x[i];
    ctrDirY[i] = aveY - y[i];
  }

//周りと同じ方向、同じ速度になるように動く部分
  aveVel   = 0;
  aveAngle = 0;
  for (int i=0; i<num; i++) {
    aveVel   += sqrt(dx[i]*dx[i]+dy[i]*dy[i]);
    aveAngle += degrees(atan2(dy[i], dx[i]));
  }
  aveVel   /= num;
  aveAngle /= num;

  velX = aveVel*cos(radians(aveAngle));
  velY = aveVel*sin(radians(aveAngle));

//互いに近づきすぎたら離れる
  for (int i=0; i<num; i++) {
    contX[i]=0;
    contY[i]=0;
    for (int j=0; j<num; j++) {
      if (i!=j) {
        float dist=sqrt((x[j]-x[i])*(x[j]-x[i])+(y[j]-y[i])*(y[j]-y[i]));
        if (0<dist&&dist<100) {
          contX[i] = -1*(x[j]-x[i]);
          contY[i] = -1*(y[j]-y[i]);
          float temp = sqrt(contX[i]*contX[i]+contY[i]*contY[i]);
          contX[i]/=temp;
          contY[i]/=temp;
        }
      }
    }
  }

//　各個体の動く方向と速度を決める
  for (int i=0; i<num; i++) {
    kX[i] = 0.03*ctrDirX[i]+4.0*velX+5.0*contX[i];
    kY[i] = 0.03*ctrDirY[i]+4.0*velY+5.0*contY[i];

    float tempVel = sqrt(kX[i]*kX[i]+kY[i]*kY[i]);
    if (tempVel>2) {
      kX[i]=2*kX[i]/tempVel;
      kY[i]=2*kY[i]/tempVel;
    }

    dx[i] += (kX[i]-dx[i])*0.02;
    dy[i] += (kY[i]-dy[i])*0.02;

    x[i] += dx[i];
    y[i] += dy[i];
    
    if (x[i]>1600)x[i]=0;
    if (x[i]<0)x[i]=1600;
    if (y[i]>900)y[i]=0;
    if (y[i]<0)y[i]=900;
    //if (x[i]>1600)x[i]=1600;
    //if (x[i]<0)x[i]=0;
    //if (y[i]>900)y[i]=900;
    //if (y[i]<0)y[i]=0;
  }

  //X += dir_x * speed;
  //Y += dir_y * speed;

  //if ( ( X < 0 ) || ( X > width - img.width ) ) {
  //  dir_x = - dir_x;
  //}

  //if ( ( Y < 0 ) || ( Y > height - img.height ) ) {
  //  dir_y = - dir_y;
  //}

  //image( img, X, Y );
}
