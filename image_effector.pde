// --------------------------------------------------------------------------------
//  July 2014
//  Exam of di Formati Multimediali
//  7iacura
//  (run with Processing 3)
// -------------------------------------------------------------------------------- 

// flags
boolean f_drawHist = false; 
boolean f_drawGui = true; 
boolean f_drawCenter = false;

// Variable for capture image
PImage g_image;

// dimension of the viewport
int g_width = 640;
int g_height = 480;

// variable contains the font
PFont g_font; 

//histograms
float[] g_histogram = new float[256];
float g_maxHist; 
String p_histName = "Brightness";
int f_chHist = 0;

// filters
int g_filterW = 3;
int g_filterH = 3; 

color drawFxColorButton = color(248, 179, 27);
int drawhitFx = -1;

color drawImageColorButton = color(248, 179, 27);
int drawhitImage = -1;

int activeEffect = -1;
int f_paramFx = 5;

// mouse position
int mouse_X;
int mouse_Y;

// variable with font
PFont g_font2;

// histograms
color colorHist = color(255, 255, 255, 200); 

// filters
float factor = 1.0;
float bias = 0.0; 

// ---------------------------------------------------
// filter FUNCTIONS  
// ---------------------------------------------------

void doPixelate(int p_dim, boolean p_dot)
{
  // creates a pixelization of images in dots or in squares (with dimension p_dim);
  // the choosen form is selected in p_dot

  float r, g, b;
  r = g = b = 0.0;
  int av_r, med_r, av_g, med_g, av_b, med_b;
  color c = color(r, g, b);
  background(0);

  // double loop to select all pixels from (0,0) with step-dimension of p_dim
  for(int i = 0; i <= g_width - p_dim; i += p_dim){
    for (int j = 0; j <= g_height - p_dim; j += p_dim){
      
      av_r = med_r = av_g = med_g = av_b = med_b = 0;
      
      // double loop to select all pixels in each block of dimension p_dim
      for(int h = 0; h < p_dim; h++){
        for(int l = 0; l < p_dim; l++){
          
          c = getColorFromImage(i + h, j + l);
          av_r = av_r + (int)red(c);
          av_g = av_g + (int)green(c);
          av_b = av_b + (int)blue(c);
          
        }
      }
      
      // average values of three channels into each block
      med_r = av_r / (p_dim * p_dim);
      med_g = av_g / (p_dim * p_dim);
      med_b = av_b / (p_dim * p_dim);
      fill(med_r, med_g, med_b); noStroke();
      
      if(p_dot){ 
        ellipse(i, j, p_dim, p_dim); 
      } else { 
        rect(i, j, p_dim, p_dim);
      }
    }
  }
  
//  updatePixels();
} 

// blur matrix
float[] g_filter = { 
  0.0, 0.2, 0.0, 
  0.2, 0.2, 0.2, 
  0.0, 0.2, 0.0
}; 

void doBlur()
{
  loadPixels();
  
  int loc, floc;
  float r, g, b;
  int imageX, imageY;

  // double loop to select all pixels
  for (int i = 0; i < g_width; i++) {
    for (int j = 0; j < g_height; j++) {

      r = g = b = 0.0;
      
      // double loop to analyze neighbourhood for each pixel
      for (int k = 0; k < g_filterW; k++) {
        for (int w = 0; w < g_filterH; w++) {

          floc = k + w * g_filterW;
          imageX = (i - g_filterW / 2 + k + g_width) % g_width; 
          imageY = (j - g_filterH / 2 + w + g_height) % g_height; 
          loc = imageX + imageY * g_width;
          r += red(g_image.pixels[loc]) * g_filter[floc]; 
          g += green(g_image.pixels[loc]) * g_filter[floc]; 
          b += blue(g_image.pixels[loc]) * g_filter[floc];
        }
      }

      loc = i + j * g_width;
      r = min(max((factor * r + bias), 0), 255); 
      g = min(max((factor * g + bias), 0), 255); 
      b = min(max((factor * b + bias), 0), 255); 
      pixels[loc] = color(r, g, b, 255);
    }
  }
  
  updatePixels();
} 


// ---------------------------------------------------
// histograms FUNCTIONS  
// ---------------------------------------------------

void cleanHistograms()
{
  // clean all data to reboot histogram
  for (int x = 0; x < 256; x++) {
    g_histogram[x] = 0 ;
  }
  g_maxHist=0;
}

void calcHistograms( int p_type )
{
  // recalculates histogram depending on input type in p_type (r, g, b, etc... )
  int locs, iv;  
  float r, g, b;
  float Y,Cb,Cr;
  int iY,iCb,iCr;

  for (int i = 0; i < g_width; i++) {
    for (int j = 0; j < g_height; j++) {

      locs = i + j*g_width;
      r = red(g_image.pixels[locs]);
      g = green(g_image.pixels[locs]);
      b = blue(g_image.pixels[locs]);
      
      Y =         0.299*r     + 0.587*g     + 0.114*b;
      Cb = 128 -  0.168736*r  - 0.331264*g  + 0.5*b;
      Cr = 128 +  0.5*r       - 0.418688*g  - 0.081312*b;
      iY = (int)Y;
      iCb = (int)Cb;
      iCr = (int)Cr;

      switch (p_type) {
      case 1:
        iv = int(red(color(r, g, b, 255))%256);
        p_histName = "Red";
        colorHist = color(255, 0, 0, 200);
        break;
      case 2:
        iv = int(green(color(r, g, b, 255))%256);
        p_histName = "Green";
        colorHist = color(0, 255, 0, 200);
        break;
      case 3:
        iv = int(blue(color(r, g, b, 255))%256);
        p_histName = "Blue";
        colorHist = color(0, 0, 255, 200);
        break;
      case 4:
        iv = int(red(color(iY, iY, iY, 255))%256);
        p_histName = "Luminance";
        colorHist = color(100, 100, 100, 200);
        break;
      case 5:
        iv = int(red(color(iCb, iCb, iCb, 255))%256);
        p_histName = "Cb";
        colorHist = color(0, 255, 255, 200);
        break;
      case 6:
        iv = int(red(color(iCr, iCr, iCr, 255))%256);
        p_histName = "Cr";
        colorHist = color(255, 0, 255, 200);
        break;  
      default: 
        iv = int(brightness(color(r, g, b, 255))%256);
        p_histName = "Brightness";
        colorHist = color(255, 255, 255, 200);
        break;
      }
      g_histogram[iv] += 1 ; 

      g_maxHist = max(g_maxHist, g_histogram[iv]);
    }
  }
}

void normHistograms()
{
  // normalizes histogram with max value found in the search in calcHistogram
  for (int x = 0; x < 256; x++) {
    g_histogram[x] = (g_histogram[x])/(g_maxHist);
  }
}

// ---------------------------------------------------
// process buttons FUNCTIONS  
// ---------------------------------------------------

void hitFx(int p_index)
{
  drawhitFx = p_index;
  activeEffect = p_index;
}

void hitImg(int p_index)
{
  drawhitImage = p_index;
  loadDiskImage(p_index+1);
  activeEffect = -1;
}

void processGui()
{
  // process mouse click on the buttons 
  // if effect: hitFx( button number )  [0,1,2]
  // if image : hitImg( button number ) [0,1,2,3]

  if (mouse_X >= 20 && mouse_X <= 120) {
    if (mouse_Y >= 40 && mouse_Y <= 60) {
      hitFx(0);
      fill(drawFxColorButton);
      rect(20, 40, 100, 20);
    }
    if (mouse_Y >= 65 && mouse_Y <= 85) {
      hitFx(2);
      fill(drawFxColorButton);
      rect(20, 65, 100, 20);
    }
    if (mouse_Y >= 90 && mouse_Y <= 110) {
      hitFx(1);
      fill(drawFxColorButton);
      rect(20, 90, 100, 20);
    }
    if (mouse_Y >= 145 && mouse_Y <= 165) {
      //image 1
      hitImg(0);
      fill(drawImageColorButton);
      rect(20, 145, 100, 20);
    }
    if (mouse_Y >= 170 && mouse_Y <= 190) {
      hitImg(1);
      fill(drawImageColorButton);
      rect(20, 170, 100, 20);
    }
    if (mouse_Y >= 195 && mouse_Y <= 215) {
      hitImg(2);
      fill(drawImageColorButton);
      rect(20, 195, 100, 20);
    }
    if (mouse_Y >= 220 && mouse_Y <= 240) {
      hitImg(3);
      fill(drawImageColorButton);
      rect(20, 220, 100, 20);
    }
  }
}


// ---------------------------------------------------
// generic FUNCTIONS  
// ---------------------------------------------------

color getColorFromImage( int p_x, int p_y )
{
  int loc = p_x + p_y * g_width;

  float r = red(g_image.pixels[loc]);
  float g = green(g_image.pixels[loc]);
  float b = blue(g_image.pixels[loc]);

  return color(r, g, b);
} 

// load disk images | callbacks
void loadDiskImage( int p_image )
{
  g_image = loadImage("image_"+p_image+".jpg");
  cleanHistograms();
  calcHistograms(f_chHist);
  normHistograms();

  // Use the default video input
//  background(0, 0, 0);   // Red, Green, Blue
}


// ---------------------------------------------------
// init FUNCTIONS  
// ---------------------------------------------------


// init function for initialization the canvas and paramenters
void setup() {

  // setup fonts
  g_font = loadFont("Univers-66.vlw");
  textFont(g_font, 12);
  g_font2= loadFont("CourierNew36.vlw");

  size(640, 480);

  colorMode(RGB, 255, 255, 255, 255);
  //  rectMode(CENTER);

  g_image = loadImage("image_1.jpg");

  // Use the default video input
  background(0, 0, 0);   // Red, Green, Blue

  // histogram
  cleanHistograms();  
  calcHistograms(0);
  normHistograms();
} 


// ---------------------------------------------------
// DRAW FUNCTIONS  
// ---------------------------------------------------

void drawHistogram(String p_text, int p_x, int p_y, int p_w, int p_h, color p_color_bg, color p_color)
{
  stroke(65);
  fill(p_color_bg);
  rect(p_x, p_y, p_w, p_h);

  float dimRect = p_w / 255.0 ;

  rect(p_x, p_y-18, 100, 18);
  fill(65);
  text( p_text, p_x+5, p_y-5 );


  for ( int x=0; x<255; x++ )
  {
    fill(p_color);
    rect( p_x+x*dimRect, p_h +p_y, dimRect, - g_histogram[x] * p_h );
    noStroke();
  }
} 


void drawGUI()
{
  // background
  stroke(60);
  fill(60);
  rect(0, 0, 150, g_height);

  // effects
  fill(255);
  textFont(g_font, 14);
  text("Effects", 15, 30);

  stroke(0); 
  fill(150); 
  rect(20, 40, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Blur", 27, 55);

  stroke(0); 
  fill(150); 
  rect(20, 65, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Pixelate Dot", 27, 80);

  stroke(0); 
  fill(150); 
  rect(20, 90, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Pixelate Rect", 27, 105);

  // images
  fill(255);
  textFont(g_font, 14);
  text("Images", 15, 135);

  stroke(0); 
  fill(150); 
  rect(20, 145, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Image 1", 27, 160);

  stroke(0); 
  fill(150); 
  rect(20, 170, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Image 2", 27, 185);

  stroke(0); 
  fill(150); 
  rect(20, 195, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Image 3", 27, 210);

  stroke(0); 
  fill(150); 
  rect(20, 220, 100, 20);
  fill(50); 
  textFont(g_font, 12);
  text("Image 4", 27, 235);

  // gui
  fill(200); 
  textFont(g_font, 12);
  text("+ : effect", 15, 350);
  text("- : effect", 15, 370);
  text(f_paramFx, 100, 360);
  text("h : histogram", 15, 390);
  text("c : histogram channel", 15, 410);
  text("g : GUI", 15, 430);
  text("d : info", 15, 450);
}

void drawCenter()
{
  color c = getColorFromImage(mouse_X, mouse_Y);
  
  // coordinates of mouse allow to display info box (into the window)
  if (mouse_X <= 525 && mouse_Y >= 80) {
    fill(0, 0); 
    stroke(0);
    rect(mouse_X, mouse_Y-80, 115, 80);
    fill(c);
    rect(mouse_X+2, mouse_Y-78, 111, 32);
    fill(60);
    rect(mouse_X+2, mouse_Y-44, 111, 42);
    fill(255, 255, 0); 
    textFont(g_font2, 12);
    text("x: "+mouse_X, mouse_X+5, mouse_Y-33);
    text("y: "+mouse_Y, mouse_X+5, mouse_Y-20);
    text("c: "+(int)red(c)+" "+(int)green(c)+" "+(int)blue(c), mouse_X+5, mouse_Y-5);
  }
  if (mouse_X <= 525 && mouse_Y < 80) {
    fill(0, 0); 
    stroke(0);
    rect(mouse_X, mouse_Y, 115, 80);
    fill(c);
    rect(mouse_X+2, mouse_Y+2, 111, 32);
    fill(60);
    rect(mouse_X+2, mouse_Y+36, 111, 42);
    fill(255, 255, 0); 
    textFont(g_font2, 12);
    text("x: "+mouse_X, mouse_X+5, mouse_Y+47);
    text("y: "+mouse_Y, mouse_X+5, mouse_Y+60);
    text("c: "+(int)red(c)+" "+(int)green(c)+" "+(int)blue(c), mouse_X+5, mouse_Y+75);
  }
  if (mouse_X > 525 && mouse_Y >= 80) {
    fill(0, 0); 
    stroke(0);
    rect(mouse_X-115, mouse_Y-80, 115, 80);
    fill(c);
    rect(mouse_X-113, mouse_Y-78, 111, 32);
    fill(60);
    rect(mouse_X-113, mouse_Y-44, 111, 42);
    fill(255, 255, 0); 
    textFont(g_font2, 12);
    text("x: "+mouse_X, mouse_X-110, mouse_Y-33);
    text("y: "+mouse_Y, mouse_X-110, mouse_Y-20);
    text("c: "+(int)red(c)+" "+(int)green(c)+" "+(int)blue(c), mouse_X-110, mouse_Y-5);
  }
  if (mouse_X > 525 && mouse_Y < 80) {
    fill(0, 0); 
    stroke(0);
    rect(mouse_X-115, mouse_Y, 115, 80);
    fill(c);
    rect(mouse_X-113, mouse_Y+2, 111, 32);
    fill(60);
    rect(mouse_X-113, mouse_Y+36, 111, 42);
    fill(255, 255, 0); 
    textFont(g_font2, 12);
    text("x: "+mouse_X, mouse_X-110, mouse_Y+47);
    text("y: "+mouse_Y, mouse_X-110, mouse_Y+60);
    text("c: "+(int)red(c)+" "+(int)green(c)+" "+(int)blue(c), mouse_X-110, mouse_Y+75);
  }
} 


// draw canvas | every frame
void draw() 
{
  mouse_X = mouseX;
  mouse_Y = mouseY;

  switch(activeEffect)
  {
  case 0: 
    doBlur();
    break;
  case 1: 
    doPixelate(f_paramFx, false);
    break;
  case 2: 
    doPixelate(f_paramFx, true);
    break;
  case -1:
    background(g_image);
    break;
  }

  if ( f_drawHist )
    drawHistogram(p_histName, g_width-210, 30, 200, 80, color(214, 214, 214, 255), colorHist);

  if ( f_drawGui )
    drawGUI();

  if ( f_drawCenter )
    drawCenter();
    
  if (mousePressed == true) mousePressed();
}

// ---------------------------------------------------
// callback FUNCTIONS  
// ---------------------------------------------------

// keyboard callback
void keyPressed() 
{
  if (key == '+') {
    f_paramFx ++;
    if (f_paramFx > 32 ) 
      f_paramFx = 32;
  } else
    if (key == '-') {
    f_paramFx --;
    if (f_paramFx < 1 ) 
      f_paramFx = 1;
  } else
    if (key == 'h')
    f_drawHist = !f_drawHist;
  else
    if ( key == 'g' )
    f_drawGui = !f_drawGui;
  else
    if (key == 'c') {
    f_chHist++;
    cleanHistograms();  
//    calcHistograms(f_chHist%7);
    if (f_chHist < 7) { calcHistograms(f_chHist); }
    else { f_chHist = 0; calcHistograms(f_chHist); }
    normHistograms();
  }
  if (key == 'd' )
    f_drawCenter = !f_drawCenter;

  if (key == '1') 
    hitImg(0);
  if (key == '2')
    hitImg(1); 
  if (key == '3')
    hitImg(2);
  if (key == '4')
    hitImg(3);
} 

void mousePressed()
{
  if (f_drawGui)
    processGui();
}

void mouseReleased()
{
  drawhitFx = -1;
  drawhitImage = -1;
}