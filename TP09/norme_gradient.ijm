// Calcul de la norme du gradient par masque de Sobel
//run("Close All");
requires("1.41i");	// requis par substring(string, index)
//setBatchMode(true);	// false pour déboguer
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
run("Duplicate...", "title="+filenameDerY);
run("Duplicate...", "title="+filenameDerX);

// Convolution avec le filtre de sobel Hx
selectWindow(filenameDerX);
run("32-bit");	// conversion en Float avant calcul des dérivées !!
run("Convolve...", "text1=[-1 0 1\n-2 0 2\n-1 0 1\n]");
run("Square");
derivX = getImageID();

// Convolution avec le filtre de sobel Hy
selectWindow(filenameDerY);
run("32-bit");	// conversion en Float avant calcul des dérivées !!
run("Convolve...", "text1=[-1 -2 -1\n0 0 0\n1 2 1\n]");
run("Square");

// Calculer la norme du gradient dans une nouvelle image
imageCalculator("Add create 32-bit", filenameDerX, filenameDerY);
gradNorm = getImageID();
run("Square Root");

setBatchMode("exit and display");