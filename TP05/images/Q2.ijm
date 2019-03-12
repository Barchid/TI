macro "direction FFT"
{
    // ouverture d'une image si necessaire - sinon la macro analyse l'image courante
    //open ("/home/bmathon/Enseignement/TI/tp6_TF/images/256_a.jpg");

    // recuperation de l'identifiant de l'image
    image = getImageID();

    // application de la TDF (FFT : Fast Fourier Transform)
    run("FFT");

    // recuperation de l'ID du module de la FFT
    fourier = getImageID();

    // recuperation de la taille W x H du module de la FFT
    W = getWidth();
    H = getHeight();

    // recherche de la raie maximale
    max_1 = 0; 
    i_max_1 = 0;
    j_max_1 = 0;
    
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

    // mise a zero de la raie maximale pour pouvoir l'observer sur l'image 
    // de la transformée de Fourier
    setPixel (i_max_1,j_max_1,0);

    print("Coordonnées de la raie maximale dans le plan de Fourier [-0.5 ; 0.5] x [-0.5 ; 0.5]");
	xFCentre = ((H/2) - i_max_1)/H;
	yFCentre = ((H/2) - j_max_1)/H;
	print("x = " + xFCentre);
	print("y = " + yFCentre);


	print("Coordonnées de la raie maximale dans l'image");
	print("x = " + i_max_1);
	print("y = " + j_max_1);

}
