class ParticleSystem extends ArrayList<ParticleOpacity> {
    PGraphics canvas;

    ParticleSystem(PGraphics canvas) {
        this.canvas = canvas;
    }

    // Returns false if all particles are dead
    boolean draw() {
        boolean allDead = true;

        for ( ParticleOpacity particle : this ) {
            if ( !particle.dead ) {
                allDead = false;
                particle.draw(canvas);
                particle.step();
            }
        }

        return allDead;
    }
}
