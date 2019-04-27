// Calcul de la norme du gradient par masque de Sobel
run("Close All");
requires("1.41i");	// requis par substring(string, index)
setBatchMode(true);	// false pour déboguer
/****** Création des images ******/
sourceImage = getImageID();
filename = getTitle();
extension = "";
if (lastIndexOf(filename, ".") > 0) {
    extension = substring(filename, lastIndexOf(filename, "."));
    filename = substring(filename, 0, lastIndexOf(filename, "."));
}
filenameDerX = filename+"_der_x"+extension; // images des
filenameDerY = filename+"_der_y"+extension; // dérivées

/****** Calcul de la norme du gradient ******/
// récupération de la taille de l'image
w = getWidth();
h = getHeight();

// Approximation de la dérivée partielle pour (x,y)
// ------------------------------------------------
run("Duplicate...", "title=derivNormX");
derivNormX = getImageID();
run("32-bit");	// conversion en Float avant calcul des dérivées !!
run("Duplicate...","title=derivX");
derivX = getImageID();

run("Duplicate...","title=direction-gradient");
directionGradient = getImageID();

run("Duplicate...","title=derivNormY");
derivNormY = getImageID();
run("Duplicate...","title=derivY");
derivY = getImageID();

// Convolution avec le filtre de sobel Hx
selectImage(derivNormX);
run("Convolve...", "text1=[-1 0 1\n-2 0 2\n-1 0 1\n] normalize");
run("Square");

// Convolution avec le filtre de sobel Hy
selectImage(derivNormY);
run("Convolve...", "text1=[-1 -2 -1\n0 0 0\n1 2 1\n] normalize");
run("Square");

// Calculer la norme du gradient dans une nouvelle image
imageCalculator("Add create 32-bit", derivNormX, derivNormY);
gradNorm = getImageID();
run("Square Root");
selectImage(derivNormX);
close();
selectImage(derivNormY);
close();

/** 
 *  #########################################################################
 * Calcul de la direction du gradient 
 *  #########################################################################
 */
// Convolution avec le filtre de Sobel HX
selectImage(derivX);
run("Convolve...", "text1=[-1 0 1\n-2 0 2\n-1 0 1\n] normalize");

// Convolution avec le filtre de sobel Hy
selectImage(derivY);
run("Convolve...", "text1=[-1 -2 -1\n0 0 0\n1 2 1\n] normalize");

// Calcul de la direction du vecteur gradient :
for (i = 0; i < w; i++) {
	for (j = 0; j < h; j++) {
		// pixel pour dérivée partielle en X
		selectImage(derivX);
		px = getPixel(i, j);

		// pixel pour dérivée partielle en Y
		selectImage(derivY);
		py = getPixel(i, j);

		// calculer direction pour le pixel
		selectImage(directionGradient);
		val = atan2(py, px) * (180/PI); // application de la formule
		setPixel(i, j, val);
	}
}

selectImage(derivX);
//close();
selectImage(derivY);
//close();

selectImage(sourceImage);
run("Duplicate...", "title=maximaLocaux");
maximaLocaux = getImageID();

for (x = 0; x < w; x++) {
	for (y = 0; y < h; y++) {
		// Arrondir la direction du gradient au multiple de 45° le plus proche
		selectImage(directionGradient);
		theta = getPixel(x, y);
		theta = round((theta / 45)) * 45;

		selectImage(gradNorm);
		p = getPixel(x, y);
		p1 = 0;
		p2 = 0;
		if(theta == 0 || theta == 180 || theta == -180) {
			p1 = getPixel(x+1, y);
			p2 = getPixel(x-1, y);
		}

		if(theta == 45 || theta == -135) {
			p1 = getPixel(x+1, y-1);
			p2 = getPixel(x-1, y+1);
		}

		if(theta == 90 || theta == -90) {
			p1 = getPixel(x, y+1);
			p2 = getPixel(x, y-1);
		}

		if(theta == 135 || theta == -45) {
			p1 = getPixel(x-1, y-1);
			p2 = getPixel(x+1, y+1);
		}

		selectImage(maximaLocaux);
		if(p < p1 || p < p2) {
			setPixel(x, y, 0);
		} else {
			setPixel(x, y, p);
		}
	}
}


setBatchMode("exit and display");