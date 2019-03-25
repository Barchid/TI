image = getImageID();
makeGradientNorm(image);

function makeGradientNorm(image) {
	//Duplication de l'image pour obtenir dx et dy
	selectImage(image);
	run("Duplicate...", "sobelX");
	sobelX = getImageID();

	run("Duplicate...", "sobelY");
	sobelY = getImageID();

	//Calcul des convolution par filtre de Sobel
	selectImage(sobelY);
	run("Convolve...", "text1=[-0.125 -0.25 -0.125\n0 0 0\n0.125 0.25 0.125] normalize");
	run("Square");

	selectImage(sobelX);
	run("Convolve...", "text1=[-0.125 0 0.125\n-0.25 0 0.25\n-0.125 0 0.125] normalize");
	run("Square");

	//sobelX² + sobelY²
	imageCalculator("Add 32-bit", sobelX, sobelY);

	// racine de la somme
	run("Square Root");
	normGrad = getImageID();

	return normGrad;
}