// Macro exemple

// Recherche du minimum de l'image pour les etudiants

// M1 IVI

macro "minimum" {

// recuperation du ID de l'image
image = getImageID();


// recuperation de la taille de l'image
W = getWidth();
H = getHeight();

// recherche du min 

min = 255;

for (j=0; j<H; j++) 
{
	for (i=0; i<W; i++) 
	{
		p = getPixel(i,j);
		if ( min > p)
		{
			min = p;
		}
 
      	}
}

print ("min =", min);

} // fin macro

