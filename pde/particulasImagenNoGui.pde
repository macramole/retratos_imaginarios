ParticleSystem particles;
// PaletteHelper palette;
Palette palette;

// GUI gui;
// int clickRadius = 20;
int cantParticles = 1000;
float imgOpacity = 0;
float noiseOpacity = 0;
float probabilidadAncho = 0.05;
float penalizacionSalto = 0.6;
float probabilidadPenalizacionSalto = 0.5; //mas probabilidad bordes menos precisos
int lifeMin = 600;
int lifeMax = 1000; //not currently of use
int maxOpacity = 50;
int directionChangeMin = 10;
int directionChangeMax; //not currently of use
color bgColor;

//radians
float currentAngle = 0;
float currentAngleWidth = 2 * PI;

boolean paused = false;

PImage img;
PGraphics canvas;

final int MAX_LAYERS = 8;
PImage[] layers;
int[] layersOpacity;
boolean needToCreateLayer = false;
boolean allParticlesDead;
int qtyLayers = 0;
boolean fadeLayer = false;

final int RETRATOS_CANT = 7;

PImage[] retratos;
int retratoCurrent = -1;

final int DEBUG_SHOW_ONLY = -1; //-1 for no debugging

PImage border;

ParticleOpacityParams[] particleOpacityParams = {
    // 1 //
    new ParticleOpacityParams(
        0, // float angle,
        2 * PI, // float angleWidth,
        50, // int maxOpacity,
        600, // int lifeLow,
        600, // int lifeHigh,
        10, // int directionChangeMin,
        10, // int directionChangeMax,
        0.05, // float probabilidadAncho,
        0.6, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    ),
    // 2 //
    new ParticleOpacityParams(
        0, // float angle,
        2 * PI, // float angleWidth,
        50, // int maxOpacity,
        200, // int lifeLow,
        800, // int lifeHigh,
        1, // int directionChangeMin,
        1, // int directionChangeMax,
        0.01, // float probabilidadAncho,
        0.9, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    ),
    // 3 //
    new ParticleOpacityParams(
        0, // float angle,
        2 * PI, // float angleWidth,
        50, // int maxOpacity,
        600, // int lifeLow,
        600, // int lifeHigh,
        10, // int directionChangeMin,
        10, // int directionChangeMax,
        0.05, // float probabilidadAncho,
        0.6, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    ),
    // 4 //
    new ParticleOpacityParams(
        0, // float angle,
        2 * PI, // float angleWidth,
        50, // int maxOpacity,
        600, // int lifeLow,
        600, // int lifeHigh,
        10, // int directionChangeMin,
        10, // int directionChangeMax,
        0.05, // float probabilidadAncho,
        0.6, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    ),
    // 5 //
    new ParticleOpacityParams(
        0, // float angle,
        0, // float angleWidth,
        50, // int maxOpacity,
        0, // int lifeLow,
        800, // int lifeHigh,
        10, // int directionChangeMin,
        10, // int directionChangeMax,
        0.02, // float probabilidadAncho,
        0.88, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    ),
    // 6 //
    new ParticleOpacityParams(
        0, // float angle,
        2 * PI, // float angleWidth,
        50, // int maxOpacity,
        600, // int lifeLow,
        600, // int lifeHigh,
        10, // int directionChangeMin,
        10, // int directionChangeMax,
        0.05, // float probabilidadAncho,
        0.6, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    ),
    // 7 //
    new ParticleOpacityParams(
        0, // float angle,
        2 * PI, // float angleWidth,
        50, // int maxOpacity,
        600, // int lifeLow,
        600, // int lifeHigh,
        10, // int directionChangeMin,
        10, // int directionChangeMax,
        0.05, // float probabilidadAncho,
        0.6, // float penalizacionSalto,
        0.5 // float probabilidadPenalizacionSalto
    )
};

void setup() {
  size(800,800);
  // size( window.innerWidth , window.innerHeight );
  //background( palette[ floor(random(0, palette.length)) ] );

  // noiseDetail(1);
  retratos = new PImage[RETRATOS_CANT];
  for ( int i = 1 ; i <= RETRATOS_CANT ; i++ ) {
      retratos[i-1] = loadImage("data/images/" + i + ".jpg");
  }

  border = loadImage("data/border.png");

  // particles = new ArrayList();
  canvas = createGraphics(width, height);

  particles = new ParticleSystem(canvas);
  palette = new Palette();

  loadPalette();
  // palette = new PaletteHelper("palettes.json");

  // gui = new GUI(this);

  layers = new PImage[RETRATOS_CANT];
  layersOpacity = new int[RETRATOS_CANT];

  reset();
  noSmooth();
  startNextPortrait();
  // addNewParticle();
  background(bgColor);
}

void draw() {
  background(bgColor);

  // acá debería chequear si necesita crear un layer
  // draw debería devolver false cuando se mueren todas las particulas
  if ( !paused ) {
    canvas.beginDraw();
        allParticlesDead = particles.draw();
    canvas.endDraw();
    image(canvas, 0, 0);
  }

  // drawImage();
  // drawNoise();

  drawLayers();
  checkLayers();

  drawBorder();
  // gui.draw();
}

void loadPalette() {
    // palette.addColor( color(0,255,0) );

    // [13,19,50],
    // [230,117,119],
    // [246,246,244],
    // [79,36,63],
    // [242,76,61]

    // palette.addColor( color(13,19,50) );
    palette.addColor( color(83,99,178,2) );
    palette.addColor( color(230,117,119,2) );
    palette.addColor( color(246,246,244,2) );
    // palette.addColor( color(79,36,63) );
    palette.addColor( color(115,56,94,1) );
    palette.addColor( color(242,76,61,2) );
}

void drawBorder() {
    image(border,0,0);
}

void drawImage() {
    if ( imgOpacity < 1 ) { return; }

    tint(255, imgOpacity);
    image(img,0,0);
    tint(255);
}

void drawNoise() {
    if ( noiseOpacity < 1 ) { return; }

    for ( int x = 0 ; x < width ; x ++ ) {
        for ( int y = 0 ; y < height ; y++ ) {
            // println( map( noise(x,y), 0, 1, 0, 255 ) );
            set(x,y, color( map( noise(x*0.03,y*0.03), 0, 1, 0, noiseOpacity ) ) ) ;
        }
    }
}


void addParticless() {
    for ( int i = 0 ; i < cantParticles ; i++ ) {
        addNewParticle(
            width/2 + random(-300, 300),
            height/2 + random(-300, 300)
        );
    }
}

void addNewParticle(float x, float y) {
    ParticleOpacity p = new ParticleOpacity( x, y, particleOpacityParams[retratoCurrent] );
    particles.add( p );

    needToCreateLayer = true;
}

void copyCanvasToLayer() { //processing.js fix
    canvas.loadPixels();
    layers[qtyLayers] = createImage(width, height, ARGB);
    layers[qtyLayers].loadPixels();

    for ( int i = 0 ; i < width * height ; i++ ) {
        layers[qtyLayers].pixels[i] = canvas.pixels[i];
    }

    layers[qtyLayers].updatePixels();
}
void lessOpacity(PImage layer, int cuanto) { //processing.js fix
    layer.loadPixels();
    for ( int i = 0 ; i < width * height ; i++ ) {
        color pixel = layer.pixels[i];
        color newPixel = color(
            red(pixel),
            green(pixel),
            blue(pixel),
            alpha(pixel)-cuanto,
            );
        layer.pixels[i] = newPixel;
    }
    layer.updatePixels();
}
void startNextPortrait() {

    // retratoCurrent = 0; //debugging
    if ( DEBUG_SHOW_ONLY > -1 ) {
        if ( retratoCurrent != DEBUG_SHOW_ONLY ) {
            retratoCurrent = DEBUG_SHOW_ONLY;
        } else {
            retratoCurrent = RETRATOS_CANT;
        }
    } else {
        retratoCurrent++;
    }

    if ( retratoCurrent < RETRATOS_CANT ) {
        img = retratos[retratoCurrent];
        addParticless();
        // RETRATOS_CANT--; //debugging
    }

}
void checkLayers() {
    if ( allParticlesDead && needToCreateLayer ) {
        needToCreateLayer = false;
        copyCanvasToLayer();
        // layers[qtyLayers] = ((PImage)canvas).copy();
        reset();
        layersOpacity[qtyLayers] = 255;
        qtyLayers++;
        // gui.addLayer();
        if ( retratoCurrent < RETRATOS_CANT ) {
            startNextPortrait();
        }
    }
    fadeLayer = true;
    if ( fadeLayer ) {
        if ( layersOpacity[qtyLayers-1] > 0 ) {
            layersOpacity[qtyLayers-1] -= 1;
            // lessOpacity( layers[qtyLayers-1], 0 );
        } else {
            fadeLayer = false;
        }
    }
}
void drawLayers() {
    for ( int i = 0 ; i < RETRATOS_CANT ; i++ ) {
        PImage layer = layers[i];
        if ( layer != null && layersOpacity[i] > 0 ) {
            tint(255, layersOpacity[i]);
            image(layer,0,0);
        }
    }
    noTint();
}
void changeLayerOpacity(int layerNum, int opacity) {
    layersOpacity[layerNum] = opacity;
}
void layerHistory(int value) {
    // gui.updateLayerOpacity(value);
}

void mouseWheel(MouseEvent event) {
    // gui.onScroll(event);
}

// void keyTyped() {
//   switch(key) {
//      case ' ':
//        paused = !paused;
//        break;
//      case 'r':
//        reset();
//        break;
//      case 'v':
//         // gui.toggleVisible();
//         break;
//   }
// }

void mouseClicked() {
    // gui.onClick();
}

// void controlEvent(ControlEvent theControlEvent) {
//     gui.controlEvent(theControlEvent);
// }

void reset() {
  canvas.beginDraw();
  // canvas.background(204,204,204,0); // este es el color que viene por default del canvas
  canvas.background(255,0);
  // canvas.background(0,0);
  canvas.endDraw();
  // canvas = createGraphics(width, height, P3D);
  particles.clear();
}
