class ParticleOpacityParams {
    float angle;
    float angleWidth;
    int maxOpacity;
    int lifeLow;
    int lifeHigh;
    int directionChangeMin;
    int directionChangeMax;
    float probabilidadAncho;
    float penalizacionSalto;
    float probabilidadPenalizacionSalto;

    // ParticleOpacityParams() {}

    ParticleOpacityParams(
        float angle,
        float angleWidth,
        int maxOpacity,
        int lifeLow,
        int lifeHigh,
        int directionChangeMin,
        int directionChangeMax,
        float probabilidadAncho,
        float penalizacionSalto,
        float probabilidadPenalizacionSalto) {

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
    }
}
