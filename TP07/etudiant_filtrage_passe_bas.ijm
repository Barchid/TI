//filtre passe-bas sur l'image.
// le spectre du filtre est un disque binaire sur le plan de fourier.
// le filtrage est applique par produit du spectre de la FFT de l'image avec le spectre du filtre
// l'image filtree resulte de la FFT inverse
macro "filtrage passe-basFFT" {
// FFT de l'image à filtrer
run("FFT", "title='FFT du moire'f");
// recuperation de ID de la FFT
fourier = getImageID();

// recuperation de la taille W x H du plan de Fourier
W = getWidth();
H = getHeight();

// creation d'un masque binaire
// fond noir
newImage("masque", "8-bit", W, H, 1);
masque = getImageID();
setColor(0);
makeRectangle (0,0, W,H);
fill();
fc = 0.05; // définition de la fréquence de coupure (== le rayon du disque binaire)

// calcul du rayon du disque binaire à partir de la frequence de coupure fc
// attention, la FFT etant consideree comme une image par ImageJ, le rayon doit etre calcule en pixels

// Dans l'image de la FFT, nous calculons avec l'inverse du cycle par pixel
rayon = 1/fc;
print ("rayon =", rayon);
setColor(255);
makeOval (W/2-rayon,H/2-rayon, 2*rayon,2*rayon); // création du disque blanc (qui sera le disque qui acceptera des valeurs)
fill ();

// Filtrage passe-bas
// appliquer le masque sur la fft de l'image originale
setBatchMode(true); // Ne pas afficher une image à chaque fois que j'en sélectionne une autre
for (i = 0; i < W; i++) {
	for (j = 0;j < H; j++) {
		// Récupérer le masque pour le pixel (i,j)
		selectImage(masque);
		mp = getPixel(i, j);

		// Récupérer le pixel (i,j) de la transformée de Fourier
		selectImage(fourier);
		p = getPixel(i, j);

		// Produit p * mp devient le nouveau pixel en (i,j)
		setPixel(i, j, mp*p);
	}
}
setBatchMode(false); // Revenir à la normale

// REMARQUE : on peut aussi utiliser la ligne de code suivante (pour éviter de s'embrouiller avec une boucle
// imageCalculator("multiply", fourier, masque);

selectImage (fourier);
// Transformee de fourier inverse pour fournir l'image filtree
run("Inverse FFT");
image_filtree = getImageID();
selectImage (image_filtree);
}
