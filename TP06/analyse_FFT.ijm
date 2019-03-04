// ouverture d'une image si necessaire - sinon la macro analyse l'image courante
//open ("/home/bmathon/Enseignement/TI/tp6_TF/images/256_a.jpg");
// recuperation de l'identifiant de l'image
image = getImageID();

// application de la TDF (FFT : Fast Fourier Transform)
run("FFT");

// recuperation de l'ID du module de la FFT
fourier = getImageID();

// recherche et affichage de la raie maximale
print("\nCalcul de la raie maximale :");
coordRaieMax = rechercheMaxEtMaj();

print("\nCalcul de la raie secondaire 1 :");
coordRaieSec1 = rechercheMaxEtMaj();

print("\nCalcul de la raie secondaire 2 :");
coordRaieSec2 = rechercheMaxEtMaj();

// si les coordonnées en X des deux raies secondaires = 0, alors on est dans une texture verticale.
if(coordRaieSec1[0] == 0 && coordRaieSec2[0] == 0) {
	print("Classe : VERTICALE");
}

// si les coordonnées en Y des deux raies secondaires = 0, alors on est dans une texture horizontale.
if(coordRaieSec1[1] == 0 && coordRaieSec2[1] == 0) {
	print("Classe : HORIZONTALE");
}

// si les coordonnées en X des deux raies secondaires = 0, alors on est dans une texture verticale.
if(coordRaieSec1[0] != 0 && coordRaieSec1[1] != 0 && coordRaieSec2[0] != 0 && coordRaieSec2[1] != 0) {
	print("Classe : DIAGONALE");
}

// 
/**
 * Fonction qui cherche le pixel de meilleur niveau de gris de l'image et
 * change son niveau de gris à 0. Utile pour trouver les raies dans la transformée de Fourier 
 * et les mettre en évidence sur une image.
 * 
 * retourne un tableau correspondant aux coordonnées dans le plan de Fourier.
 */
function rechercheMaxEtMaj() {
	max_1 = 0; 
	i_max_1 = 0;
	j_max_1 = 0;

	// récupération des coordonnées de l'image
	W = getWidth();
	H = getHeight();
	
	for (j=0; j<H; j++)
	{
	    for (i=0; i<W; i++) 
	    {
	        p = getPixel(i,j);
	        if ( max_1 < p)
	        {
	            max_1 =p;
	            i_max_1 = i;
	            j_max_1 =j;
	        } 
	    }
	}
	setPixel (i_max_1,j_max_1,0);

	print("# Dans le plan de Fourier");
	print("----> x = " + ((W/2) - i_max_1)/W);
	print("----> y = " + ((H/2) - j_max_1)/H);
	print("# Dans le plan de l'image");
	print("----> x = " + i_max_1);
	print("----> y = " + j_max_1);

	// retourne les coordonnées dans le plan de Fourier
	return newArray(((W/2) - i_max_1)/W, (H/2) - j_max_1)/H);
}