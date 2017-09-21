class Palette {
    String name;
    // HashMap<Integer, Integer> colors; // color => weight
    ArrayList<ColorAttributes> colors; // color => weight
    int sumWeights;
    int sumWeightsSelected;
    float sumWeightsNormalized;

    Palette() {
        colors = new ArrayList();
    }

    int size() {
        return colors.size();
    }

    void addColor(color c) {
        addColor(c, 1);
    }
    void addColor(color c, int weight) {
        colors.add( new ColorAttributes(c, weight) );
        normalizeWeights();
    }

    // get weighted random color
    color getColor() {
        float rnd = random(0, sumWeightsSelected);
        int currentOffset = 0;

        for ( ColorAttributes ca : colors ) {
            if ( !ca.selected ) {
                continue;
            }

            if ( rnd >= currentOffset && rnd < currentOffset + ca.weight ) {
                return ca.c;
            }

            currentOffset += ca.weight;
        }

        // throw new Exception("asd");
        println("BUG: Color not found at getColor() of class Palette");
        return color(255,0,0);
    }
    color getColor(int index) {
        return colors.get(index).c;
    }
    int getWeight( int index ) {
        return colors.get(index).weight;
    }
    float getWeightNormalized( int index ) {
        return colors.get(index).weight_normalized;
    }
    int getIndex( color theColor ) {
        for ( int i = 0 ; i < colors.size() ; i++ ) {
            ColorAttributes ca = colors.get(i);

            if ( ca.c == theColor ) {
                return i;
            }
        }
        return -1;
    }
    void selectColor(int index, boolean on) {
        colors.get(index).selected = on;
        normalizeWeights();
    }
    void toggleSelectColor(int index) {
        colors.get(index).selected = !colors.get(index).selected;
        normalizeWeights();
    }
    int getCantSelected() {
        int cant = 0;

        for ( int i = 0 ; i < colors.size() ; i++ ) {
            ColorAttributes ca = colors.get(i);

            if ( ca.selected ) {
                cant++;
            }
        }
        return cant;
    }

    //normalize weights between 0 and 1
    void normalizeWeights() {
        int maxWeight = 0;
        sumWeights = 0;
        sumWeightsNormalized = 0;
        sumWeightsSelected = 0;

        for ( ColorAttributes ca : colors ) {
            if ( ca.weight > maxWeight ) {
                maxWeight = ca.weight;
            }

            sumWeights += ca.weight;

            if ( ca.selected ) {
                sumWeightsSelected += ca.weight;
            }
        }
        for ( ColorAttributes ca : colors ) {
            ca.weight_normalized = ca.weight * 1.0 / maxWeight;
            sumWeightsNormalized += ca.weight_normalized;
        }
    }

    class ColorAttributes {
        color c;
        int weight;
        float weight_normalized; //weight between 0 and 1
        boolean selected;

        ColorAttributes(color c, int weight) {
            this.c = c;
            this.weight = weight;
            selected = true;
        }
    }

}
