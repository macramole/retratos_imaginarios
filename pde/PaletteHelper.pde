class PaletteHelper {
    ArrayList<Palette> palettes;
    Palette currentPalette = null;

    PaletteHelper() {
        palettes = new ArrayList();
    }
    PaletteHelper(String file) {
        this();
        loadFromFile(file);
    }

    void loadFromFile( String file ) {
        JSONArray fileData = loadJSONArray(file);

        if ( fileData.size() > 0 ) {
            try {
                fileData.getJSONObject(0);
                loadFromFileExpanded(fileData);
            } catch ( Exception e ) {
                loadFromFileMinimized(fileData);
            }

            if ( palettes.size() > 0 ) {
                currentPalette = palettes.get(0);
            }
        }

    }
    void loadFromFileExpanded( JSONArray fileData ) {
        for ( int i = 0 ; i < fileData.size() ; i++ ) {
            Palette newPalette = new Palette();
            JSONObject obj = fileData.getJSONObject(i);

            newPalette.name = obj.getString("name");
            JSONArray colors = obj.getJSONArray("colors");
            JSONArray weights = obj.getJSONArray("weights");

            for ( int j = 0 ; j < colors.size() ; j++ ) {
                JSONArray oneColor = colors.getJSONArray(j);
                color colorToAdd = color(
                    oneColor.getInt( 0 ),
                    oneColor.getInt( 1 ),
                    oneColor.getInt( 2 )
                );

                newPalette.addColor( colorToAdd, weights.getInt(j) );
            }

            palettes.add(newPalette);
        }
    }
    void loadFromFileMinimized( JSONArray fileData ) {
        for ( int i = 0 ; i < fileData.size() ; i++ ) {
            Palette newPalette = new Palette();

            JSONArray colors = fileData.getJSONArray(i);

            for ( int j = 0 ; j < colors.size() ; j++ ) {
                JSONArray oneColor = colors.getJSONArray(j);
                color colorToAdd = color(
                    oneColor.getInt( 0 ),
                    oneColor.getInt( 1 ),
                    oneColor.getInt( 2 )
                );
                int weight = 1;

                if ( oneColor.size() == 4 ) {
                    weight = oneColor.getInt( 3 );
                }

                newPalette.addColor( colorToAdd, weight );
            }

            palettes.add(newPalette);
        }
    }

    void next() {
        int index = palettes.indexOf( currentPalette );
        index++;

        if ( index >= palettes.size() ) {
            index = 0;
        }

        currentPalette = palettes.get(index);
    }

    int countColors() {
        return currentPalette.size();
    }

    color getColor() {
        return currentPalette.getColor();
    }
    color getColor(int index) {
        return currentPalette.getColor(index);
    }
    int getWeight( int index ) {
        return currentPalette.getWeight(index);
    }
    float getWeightNormalized( int index ) {
        return currentPalette.getWeightNormalized(index);
    }
    float getSumWeightsNormalized() {
        return currentPalette.sumWeightsNormalized;
    }
    void toggleSelectColor(int index) {
        currentPalette.toggleSelectColor(index);
    }
    boolean isSelected(int index) {
        return currentPalette.colors.get(index).selected;
    }
    int getCantSelected() {
        return currentPalette.getCantSelected();
    }
}
