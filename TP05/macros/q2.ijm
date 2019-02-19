macro "q2" {
	image = getImageID();
	W = getWidth();
	H = getHeight();
	
	// définir l'offset (à la main)
	offset = -204;
	
	// définir le gain (à la main)
	gain = 2.55;
	
	// POUR CHAQUE [pixel]
	for (j=0; j<H; j++) 
	{
		for (i=0; i<W; i++) 
		{
			p = getPixel(i,j);
			// appliquer la transformation affine avec le gain et l'offset définis
			// g(x,y) = b*i(x,y) + a
			pnew = offset + gain*p;
	
			// modifier 
			setPixel(i,j,pnew);
	  	}
	}
}
