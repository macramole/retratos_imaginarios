class ParticleOpacity {

    color currentColor;
    float x, y;
    float lastX, lastY;

    float angle = 0;
    float angleWidth = PI;

    float ancho = 1;
    int opacity = 10;

    int directionChangeMin = 0;
    int directionChangeMax = 15;
    int directionChangeSteps;
    // int STEPS_TO_CHANGE = 15;
    int currentStep = 0;

    int life = 1000;
    int age = 0;
    boolean dead = false;

    final int MAX_ANCHO = 10;
    int maxAncho;
    int anchoDirection = 0;

    // damping default, cuando la opacidad hace un salto grande se reduce un poco
    // lo hace mas desprolijo
    float penalizacionSalto;
    // probabilidad de que el la penalización sea mayor a la default
    float probabilidadPenalizacionSalto;

    int lifeLow = 1;
    int lifeHigh = 1000;

    int maxOpacity;

    //probabilidad que modifique su ancho
    float probabilidadAncho;

    ParticleOpacity(
        float x,
        float y,
        float angle,
        float angleWidth,
        int maxOpacity,
        int lifeLow,
        int lifeHigh,
        int directionChangeMin,
        int directionChangeMax,
        float probabilidadAncho,
        float penalizacionSalto,
        float probabilidadPenalizacionSalto)
    {
        this.angle = angle;
        this.angleWidth = angleWidth;
        this.maxOpacity = maxOpacity;
        this.lifeLow = lifeLow;
        this.lifeHigh = lifeHigh;
        this.directionChangeMin = directionChangeMin;
        this.directionChangeMax = directionChangeMax;
        this.probabilidadAncho = probabilidadAncho;
        this.penalizacionSalto = penalizacionSalto;
        this.probabilidadPenalizacionSalto = probabilidadPenalizacionSalto;
        reset();
        lastX = this.x = x;
        lastY = this.y = y;
    }

    ParticleOpacity( float x, float y, ParticleOpacityParams params ) {
        this(
            x,
            y,
            params.angle,
            params.angleWidth,
            params.maxOpacity,
            params.lifeLow,
            params.lifeHigh,
            params.directionChangeMin,
            params.directionChangeMax,
            params.probabilidadAncho,
            params.penalizacionSalto,
            params.probabilidadPenalizacionSalto
        )
    }

    void reset() {
        currentColor = palette.getColor();
        //  currentColor = color(255,0,0);
        directionChangeSteps = round(random(directionChangeMin,directionChangeMax));

        life = round(random(lifeLow,lifeHigh));
        age = 0;

        angle = random(angle - angleWidth / 2, angle + angleWidth / 2);

        if ( random(0,1) <= probabilidadPenalizacionSalto ) {
            penalizacionSalto = 0.95;
        }

        if ( random(0,1) <= probabilidadAncho ) {
            maxAncho = round(random(1,MAX_ANCHO));
        } else {
            maxAncho = 1;
        }

    }

    void draw(PGraphics canvas) {
        canvas.stroke(
          red(currentColor),
          green(currentColor),
          blue(currentColor),
          opacity
        );

        canvas.strokeWeight(ancho);

        canvas.beginShape();
            canvas.vertex(lastX,lastY);
            canvas.vertex(x,y);
        canvas.endShape();

        // canvas.line(lastX,lastY,x,y);
    }

  // float sigmoid(int t, int minValue) {
  //   //   float sigmoidValue = 1 / ( 1 + exp( -t ) );
  //   //   sigmoidValue = ( sigmoidValue + minValue + 1 ) * ( 255 / 2 );
  //   float sigmoidValue = 1 / ( 1 + exp( -t ) );
  //   return sigmoidValue;
  //
  // }

  void startAncho() {
      if ( anchoDirection == 0 ) {
          anchoDirection = 1;
      }
  }

  void doAncho() {
      ancho += 0.1 * anchoDirection;

      if ( ancho <= 1 ) {
          ancho = 1;
          anchoDirection = 0;
      }
      if ( ancho >= maxAncho ) {
          anchoDirection = -1;
      }
  }

  void setOpacity( int value ) {
      int currentSalto = opacity - value;

      if ( maxAncho > 1 && abs(currentSalto) > maxOpacity / 2 ) {
          startAncho();
      }

      opacity = round(value + currentSalto * penalizacionSalto);

  }

  void step() {
    age++;

    if (age >= life) {
        dead = true;
        return;
    }

    if ( currentStep >= directionChangeSteps ) {
      float direction = random(-0.7,0.7);
      angle += map(noise(x*0.03,y*0.03),0,1,0,QUARTER_PI) * direction;

    //   angle += map(noise(x*0.03,y*0.03),0,1,0,2*PI); // solo esto hace otra cosa pero queda copado

      currentStep = 0;
    }
    currentStep++;

    lastX = x;
    lastY = y;

    x += cos(angle);
    y -= sin(angle);

    // age++;

    int pixel = img.get(floor(x),floor(y));
    float b = brightness(pixel);

    if ( x > img.width || y > img.height ) {
        b = 1.0;
    }

    //if ( brightness < 128 ) {
      //ancho = map(brightness,0,127,2,1);
      //opacity = 255;
    //} else {
      //ancho = 1;
      //opacity = round(map(brightness,129,255,255,10));
    //}

    // if ( brightness > 127 ) {
    //   setOpacity( round(map(brightness,128,255,30,10)) );
    // } else {
    //   setOpacity( round(map(brightness,0,127,100,30)) );
    // }
    setOpacity( round(map(b,0,255,maxOpacity,0)) );

    doAncho();
  }
}
