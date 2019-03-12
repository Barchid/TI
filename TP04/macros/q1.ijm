macro "q1" {
	image = getImageID();
	W = getWidth();
	H = getHeight();
	xmin = findGreyLevMin();
	xmax = findGreyLevMax();
	
	// equation de la LUT :
	// y = a * x + b où 
	//		y est le niveau de gris de l'image transformée
	//		x est le niveau de gris de l'image initiale

	// application de la formule trouvée (c.f. rapport)
	a = 255/(xmax - xmin);
	b = -a*xmin;
	
	// POUR CHAQUE [pixel]
	for (j=0; j<H; j++) 
	{
		for (i=0; i<W; i++) 
		{
			p = getPixel(i,j);
			// calculer la valeur transformée avec l'équation de la LUT (y = ax + b)
			pnew = a*p + b;

			// remplacer le pixel de l'image initiale par celui de l'image transformée
			setPixel(i,j,pnew);
	  	}
	}

	function findGreyLevMin() {
		image = getImageID();
		W = getWidth();
		H = getHeight();
		xmin = 255;
		
		for (j=0; j<H; j++) 
		{
			for (i=0; i<W; i++) 
			{
				p = getPixel(i,j);
				if ( xmin > p)
				{
					xmin = p;
				}
	      	}
		}
		return xmin;
	}

	/**
	 * Trouver le niveau de gris de l'im
	 */
	function findGreyLevMax() {
		image = getImageID();
		W = getWidth();
		H = getHeight();
		xmax = 0;
		
		for (j=0; j<H; j++) 
		{
			for (i=0; i<W; i++) 
			{
				p = getPixel(i,j);
				if ( xmax < p)
				{
					xmax = p;
				}
	      	}
		}
		return xmax;
	}
}
