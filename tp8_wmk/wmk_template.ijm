/*
 * =====================================================================================
 *
 *       Filename:  wmk_template.ijm
 *
 *    Description:  Spread-Spectrum Image Watermarking for student
 *        Version:  1.1
 *
 *         Author:  Benjamin Mathon
 *   Organization:  Lille 1 - UFR IEEA
 *
 * =====================================================================================
 */

macro "Spread-Spectrum Image Watermarking for student"
{
	/***** PARAMETERS *****/
	

	//size of watermark tile (power of two)
	widthTile = 32;
	heightTile = 32;

	//secret key (PRNG)
	secretKey = 1234; // c'est la grele
	
	//EMBED: distortion
	tpsnr = 20.0; // c'est le gamma, on veut un PSNR de 20
	//tpsnr = 27.5; // c'est le gamma, on veut un PSNR de 27.5
	//tpsnr = 35.0; // c'est le gamma, on veut un PSNR de 35 pour que ce soit imperceptible
	//tpsnr = 40;

	//binary message to embed or to compare with estimated message at decoding step
	msg = newArray(0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1); // le message de 2 octets qu'on souhaite insérer

	//number of bits of msg
	Nc = lengthOf(msg); // on peut réduire la taille du message ou l'augmenter


	/***** END OF PARAMETERS *****/




	//close all active images
	run("Close All");

	//disable "scale when converting" for 32-bit conversions
	run("Conversions...", " ");

	//images are hidden during macro execution
	setBatchMode(true);
	




	/***** choose your destiny!
	
	Embed: embed a message to an image
	Decode: decode a hidden message from an image
	
	*****/
	
	choice = newArray("Embed","Decode");
	Dialog.create("Select Choice");
	Dialog.addChoice("Choice:", choice);
	Dialog.show();
  	type = Dialog.getChoice();


	/***** Embedding process *****/
	
  	if (type == choice[0])
  	{
		/* open host image */
		
		open();

		/* convert to 32-bit */
		run("Duplicate...", "title=host");
		run("32-bit");

		print("\n\n****** Embedding ******\n");
		
		print("Number of bits to hide = "+Nc);
		print("Targeted PSNR = "+tpsnr);
	
		
		IDhost = getImageID();

		widthImg = getWidth();
		heightImg = getHeight();

		
		
		/* make secret carriers into a Nc-stack */
		IDcarriers = makeCarriers(Nc,widthTile,heightTile,secretKey);
		
	
	
		/* compute watermark image */
		IDWmk = makeWmkSignal(IDcarriers,widthImg,heightImg,msg);
		
		
		/* psychovisual masking using the norm of the gradient */
		
		// PUT YOUR CODE HERE
		// Calculer la norme du gradient de Sobel pour l'image hôte
		normGrad = makeGradientNorm(IDhost);

		// POUR CHAQUE [pixel (x,y)]
		for (x = 0; x < widthImg; x++) {
			for (y = 0; y < heightImg; y++) {
				selectImage(normGrad);
				gradPx = getPixel(x, y);

				selectImage(IDWmk);
				pix = getPixel(x, y);

				// Multiplier le signal de tatouage par le gradient de Sobel
				// pour ce pixel de coordonnée (x,y)
				setPixel(x, y, gradPx * pix);
			}
		}

		// N.B. : on peut aussi utiliser l'image calculator
		//imageCalculator("Multiply", IDWmk, normGrad);

		/* watermarking strength */
		
		selectImage(IDWmk);
		
		
		eqm = 0.0;
    	for (j= 0; j< widthImg; j++)
    		for (i= 0; i< heightImg; i++)
    		{
    			value = getPixel(j,i);
    			eqm += value*value;
    		}
      		
    	

		eqm = eqm / (heightImg*widthImg);
		gamma = sqrt( 255*255/( eqm*pow(10.,tpsnr/10.) ));
		
	
	
		run("Multiply...", "value="+gamma);
		
		/* update display LUT */
		resetMinAndMax();
		
		run("Duplicate...", "title=WmkImage");
		IDWmkImage = getImageID();
		

		/* add host image to watermark signal to produce watermarked image */
		imageCalculator("Add 32-bit", IDWmkImage, IDhost);

		selectImage(IDWmkImage);
		run("8-bit");

		/* final psnr */
		psnr = psnrImg(IDWmkImage, IDhost);
		print("Final PSNR = "+psnr);

		selectImage(IDhost);
		close();

		selectImage(IDWmkImage);
				
		
  	} //end of embedding process





	/***** Decoding process *****/
	
  	else if (type == choice[1])
  	{
  		
		/* open image for decoding */
		
		open();
		
		
		IDWmk = getImageID();

		/* estimated message after decoding */
		msgEst = newArray(Nc);

		

		print("\n\n****** Decoding ******\n");

		/* make secret carriers into a stack */
		IDcarriers = makeCarriers(Nc,widthTile,heightTile,secretKey);

		IDdecode = estimateWmkTile(IDWmk, IDcarriers);

		corrs = getCorrelations(IDdecode, IDcarriers);

		
		
		for(k=0;k<Nc;k++)
		{
			if (corrs[k] < 0)
				msgEst[k] = 1;
			else
				msgEst[k] = 0;
		}
		print("Original message = ");
		Array.print(msg);
		
		print("Estimated message = ");
		Array.print(msgEst);

		ber = bitErrorRate(Nc,msg,msgEst);

		print("ber = "+ber);

	} //end of decoding process


	//show images
	setBatchMode("exit and display");

} //end of macro


/**
 * Calcul le BER
 */
function bitErrorRate(Nc, msg, msgDecode) {
	// calcul de la distance de hamming (le nombre de bits différents 
	// entre les deux messages)
	distanceHamming = 0;
	for (i = 0; i < Nc; i++) {
		if(msg[i] != msgDecode[i]) {
			distanceHamming++;
		}
	}

	return distanceHamming / Nc;
}

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


/**
 * Paramètres :
 * 		IDCarriers sont les porteuses (chacun contient le message)
 * 		widthImg est la largeur de l'image à watermarker
 * 		heightImg est la hauteur de l'image à watermarker
 * 		msg est le message qui doit être placer dans le tatouage (tableau de bits)
 */
function makeWmkSignal(IDcarriers,widthImg,heightImg,msg)
{
	selectImage(IDcarriers);
	getDimensions(widthTile, heightTile, channels, Nc, frames);

	// Création d'une image noire qui sera le signal de tatouage
	newImage("WmkSignal", "32-bit black", widthImg, heightImg, 1);
	IDWmk = getImageID();

	// Création d'une image qui deviendra l'image concaténée des tuiles
	newImage("WmkTile", "32-bit black", widthTile, heightTile, 1);
	IDWmkTile = getImageID();


	//Application de la formule du vecteur de tatouage
	/* Spread-Spectrum */
	for(i=0; i< Nc; i++)
	{
		selectImage(IDcarriers);
		//indexes of stacks start at 1!!
		setSlice(i+1);
		
		if (msg[i] == 1)
			run("Multiply...", "value=-1 slice");
		imageCalculator("Add 32-bit", IDWmkTile, IDcarriers);
	}
	
	selectImage(IDWmkTile);

	/* update display LUT */
	resetMinAndMax();

	// Copier la tuile calculée
	makeRectangle(0, 0, widthTile, heightTile);
	run("Copy");
	run("Select None");

	// Répéter la tuile calculée plusieurs fois sur toute l'image
	// et la concatener pour obtenir le signal de tatouage
	selectImage(IDWmk);
	for(j = 0 ; j < widthImg; j = j + widthTile)
	{
		for(i = 0 ; i < heightImg; i = i + heightTile)
		{
			makeRectangle(j, i, widthTile, heightTile);
			run("Paste");
		}
	}
	run("Select None");
	return IDWmk;
}




function estimateWmkTile(IDWmk, IDcarriers)
{
	selectImage(IDcarriers);
	getDimensions(widthTile, heightTile, channels, Nc, frames);

	newImage("decode", "32-bit black", widthTile, heightTile, 1);
	IDdecode = getImageID();

	selectImage(IDWmk);
	widthWmk = getWidth();
	heightWmk = getHeight();

	for(j=0;j<widthWmk;j++)
	{
		for(i=0;i<heightWmk;i++)
		{
			selectImage(IDWmk);
			p = getPixel(j,i);

			selectImage(IDdecode);
			setPixel(j%widthTile,i%heightTile,p+getPixel(j%widthTile,i%heightTile));
		}
	}

	/* update display LUT */
	resetMinAndMax();
	return IDdecode;
}



function getCorrelations(IDdecode,IDcarriers)
{
	selectImage(IDcarriers);
	getDimensions(widthTile, heightTile, channels, Nc, frames);

	corrs = newArray(Nc);
	for(k=0;k<Nc;k++)
		corrs[k]=0.0;

	//indexes of stacks start at 1!!
	for(k = 1; k <= Nc; k++)
	{
		selectImage(IDcarriers);
		setSlice(k);

		for(j=0;j<widthTile;j++)
		{
			for(i=0;i<heightTile;i++)
			{
				selectImage(IDdecode);
				p1 = getPixel(j,i);

				selectImage(IDcarriers);
				p2 = getPixel(j,i);

				corrs[k-1]+=p1*p2;
				
			}
		}
		
		
	}

	return corrs;
	
}


function makeCarriers(Nc,width,height,secretKey)
{
	random("seed", secretKey);
	
	newImage("secret_key_"+secretKey, "32-bit black", width, height, Nc);
	IDcarriers = getImageID();
	
	//indexes of stacks start at 1!!
	for(k = 1; k <= Nc; k++)
	{
		setSlice(k);
		for(j = 0; j< width; j++)
			for(i = 0; i < height; i++)
			{
				value = genereGaussian();
				setPixel(j, i, value);
			}
	}

	//indexes of stacks start at 1!!
	for(k = 1; k <= Nc; k++)
	{
		setSlice(k);
		getRawStatistics(area,mean,max,std);
		run("Subtract...", "value="+mean+" slice");
		getRawStatistics(area,mean,max,std);
	}


	/* Gram-Schmidt process */
	GramSchmidt(IDcarriers);


	//indexes of stacks start at 1!!
	for(k = 1; k <= Nc; k++)
	{
		setSlice(k);
		getRawStatistics (area,mean,max,std);
		run("Divide...", "value="+std+" slice");
		getRawStatistics (area,mean,max,std);
	}

	/* update display LUT */
	resetMinAndMax();

	return IDcarriers;
	
}




function norm()
{
	h = getHeight();
	w = getWidth();

	res = 0.0;
	
	for (y=0; y< w; y++)
	{
		for (x=0; x< h; x++)
		{
			p = getPixel(y,x);
			res+=p*p;
		}
	}

	res = sqrt(res);
	return res;
}

function genereGaussian()
{
	//source: http://pricing.free.fr/gauss.htm
	do {
		x1 = 2.0 * random() - 1.0;
        x2 = 2.0 * random() - 1.0;
        w = x1 * x1 + x2 * x2;
        }
    while ( w >= 1.0 );

    w = sqrt( (-2.0 * log( w ) ) / w );
    y = x1 * w;

    return y;
}

function innerProduct(ID,k1,k2)
{
	selectImage(ID);
	getDimensions(w, h, channels, Nc, frames);
	res = 0.0;
	for(j=0;j<w;j++)
	{
		for(i=0;i<h;i++)
		{
			setSlice(k1);
			p1 = getPixel(j,i);
			setSlice(k2);
			p2 = getPixel(j,i);
			
			res+=p1*p2;
		}
	}		
	

	return res;
}

function GramSchmidt(ID)
{
	selectImage(ID);
	
	getDimensions(w, h, channels, Nc, frames);
	
	
	
	for(i=2;i<=Nc;i++)
	{
		newImage("temp", "32-bit black", w, h, 1);
		for(j=1;j<i;j++)
		{
			selectImage(ID);
			

			innerp = innerProduct(ID,i,j);

			setSlice(j);
			run("Duplicate...", "title=proj");
			sliceNorm = norm();
			run("Multiply...", "value="+innerp/(sliceNorm*sliceNorm)+" slice");
			imageCalculator("Add 32-bit", "temp", "proj");
			close("proj");
		}
		selectImage(ID);
		setSlice(i);
		imageCalculator("Subtract 32-bit", ID, "temp");
		close("temp");
	}
	
}

function psnrImg(ID1, ID2)
{
	selectImage(ID1);
	heightImg = getHeight();
	widthImg = getWidth();
  	eqm = 0.0;
	

  	for(j = 0 ; j < widthImg; j++)
	{
		for(i = 0 ; i < heightImg; i++)
    	{
    		selectImage(ID1);
    		x = getPixel(j,i);
    		selectImage(ID2);
    		y = getPixel(j,i);
    		eqm+= (x-y)*(x-y);
    	}
	}
  
  	eqm = eqm / (heightImg*widthImg);

  	return( 10*log( 255*255/eqm )/log(10));

}
