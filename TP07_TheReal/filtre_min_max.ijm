macro "filtre_min_max" {
	// Charger l'image et ses dimensions
	image = getImageID();
	H = getHeight();
	W = getWidth();

	// Cloner l'image pour calculer la a
	run("Duplicate...", "title=result");
	result = getImageID();

	// filtrage traitement
	setBatchMode(true);
	
	for (i = 0; i < W; i++) {
		for (j = 0; j < H; j++) {

			// Trouver les pixels min et max du voisinage
			min = 255;
			max = 0;
			
			selectImage(image);
			courant = getPixel(i, j); // récupérer le pixel courant
			
			// Pour chaque pixel du voisinage 3x3 autour du courant...
			for(x = (i-2); x <= (i+2); x++) {
				for(y = (j-2); y <= (j+2); y++) {
					if(x == i && y == j) {
						// on ne fait rien quand on est sur le pixel courant...
					}
					else {
						p = getPixel(x, y);
						if(p<min) {
							min = p;
						}
	
						if(p > max) {
							max = p;
						}	
					}
					// NOTE : getPixel() sur des index qui ne sont pas dans les dimensions de l'image renvoie 0.
					// Cependant on suppose que la stratégie d'effet de bord adoptée est l'effet miroir
					// et que l'image est celle des cakes. De ce fait, les bords qui seront réfléchis valent d'office 0 pour un voisinage
					// aussi petit que celui que l'on cherche. Donc nous n'avons pas à nous inquiéter des effets de bords ici.
				}
			}

			// SI le pixel courant est plus grand que le max du voisinage...
			if(courant > max){
				// Le pixel courant prend la valeur du max
				selectImage(result);
				setPixel(i, j, max);
			}

			// SI le pixel courant est plus petit que le min du voisinage...
			if(courant < min){
				// Le pixel courant prend la valeur du min
				selectImage(result);
				setPixel(i, j, min);
			}
		}
	}

	// fin filtrage
	setBatchMode(false);
	selectImage(result);
}