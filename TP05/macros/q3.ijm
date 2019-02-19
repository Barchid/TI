bins = 256;
maxCount = 0;
histMin = 0;
histMax = 0;

getHistogram(values, counts, bins);
Plot.create("Histogram", "Pixel Value", "Count", values, counts);
n = 0;
sum = 0;
min = 9999999;
max = -9999999;

// tableau représentant l'histogramme cumulé pour chaque niveau de gris
histogrammeCumule = newArray(bins);

for (i=0; i<bins; i++) {
    count = counts[i];
    if (count>0) {
        n += count;
        sum += count*i;
        if (i<min) min = i;
        if (i>max) max = i;
    }
    // l'histogramme cumulé d'un niveau de gris est le 
    // nombre de pixels ayant un niv de gris inférieur
    // au niveau de gris calculé
    histogrammeCumule[i] = n;
}
Plot.create("Histogramme cumulé initial", "Pixel value", "Cumulated count", values, histogrammeCumule);

W = getWidth();
H = getHeight();
image = getImageID();

// realisation de l'égalisation
for(j=0; j<H; j++) 
{
	for(i=0; i<W; i++) 
	{
		// POUR CHAQUE pixel
		p = getPixel(i,j);
		
		// application de la formule vue en cours
		// ######################################

		// la nouvelle valeur du niveau de gris du pixel est
		// la valeur maximale du niveau de gris dans l'image résultante (ici, on veut 255)
		// normalisée par le nombre total de pixel, le tout divisé par la valeur de l'histgramme
		// cumulé pour le niveau de gris initial calculé.
		egalisation = (255/n)*histogrammeCumule[p];
		setPixel(i,j,egalisation);
	}
}

// calcul de l'histogramme transformé
getHistogram(values, counts, bins)
Plot.create("Histogramme normalisé", "Pixel value", "Count", values, counts);
n = 0;
// calcul de l'histogramme cumulé du résultat
for (i=0; i<bins; i++) {
    n += counts[i];
    // l'histogramme cumulé d'un niveau de gris est le 
    // nombre de pixels ayant un niv de gris inférieur
    // au niveau de gris calculé
    histogrammeCumule[i] = n;
}
Plot.create("Histogramme cumulé après transformation", "Pixel value", "Cumulated count", values, histogrammeCumule);