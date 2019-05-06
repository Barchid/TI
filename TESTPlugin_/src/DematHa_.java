import ij.ImagePlus;
import ij.ImageStack;
import ij.plugin.filter.Convolver;
import ij.plugin.filter.PlugInFilter;
import ij.process.ByteProcessor;
import ij.process.ImageProcessor;

public class DematHa_ implements PlugInFilter {
	ImagePlus imp; // Fenêtre contenant l'image de référence
	int width; // Largeur de la fenêtre
	int height; // Hauteur de la fenêtre

	// Initialisation du plugin
	public int setup(String arg, ImagePlus imp) {
		this.imp = imp;
		return PlugInFilter.DOES_8G;
	}

	public void run(ImageProcessor ip) {

		// Lecture des dimensions de la fenêtre
		width = imp.getWidth();
		height = imp.getHeight();

		ImageProcessor plan_rouge = this.planR(ip);
		ImageProcessor plan_vert = this.est_G_hamilton(ip); // estimation par hamilton
		ImageProcessor plan_bleu = this.planB(ip);

		// Calcul des échantillons de chaque composante de l'image CFA via HA97
		ImageStack samples_stack = imp.createEmptyStack();
		samples_stack.addSlice("rouge", plan_rouge); // Composante R
		samples_stack.addSlice("vert", plan_vert);// Composante G
		samples_stack.addSlice("bleu", plan_bleu); // Composante B

		// Création de l'image résultat
		ImagePlus cfa_samples_imp = imp.createImagePlus();
		cfa_samples_imp.setStack("Échantillons couleur via Hamilton avec CFA G-R-G", samples_stack);
		cfa_samples_imp.show();
	}
	
	ImageProcessor est_G_hamilton(ImageProcessor cfa_ip) {
		width = cfa_ip.getWidth();
		height = cfa_ip.getHeight();
    		ImageProcessor est_ip = cfa_ip.duplicate();
    		for(int j=0;j<height;j=j+2){
    			for(int i=1;i<width;i=i+2){
    			
    				int pCourant = cfa_ip.getPixel(i,j) & 0xff;
    				
    				int pXGauche = cfa_ip.getPixel(i-1,j) & 0xff;
    				int pXDroite = cfa_ip.getPixel(i+1,j) & 0xff;
    				int pXGaucheG = cfa_ip.getPixel(i-2,j) & 0xff;
    				int pXDroiteD = cfa_ip.getPixel(i+2,j) & 0xff;
    				
    				int pYHaut = cfa_ip.getPixel(i,j-1) & 0xff;
    				int pYBas = cfa_ip.getPixel(i,j+1) & 0xff;
    				int pYHautH = cfa_ip.getPixel(i,j-2) & 0xff;
    				int pYBasB = cfa_ip.getPixel(i,j+2) & 0xff;
    				
    				int gradX= Math.abs(pXGauche-pXDroite)+Math.abs(2*pCourant-pXGaucheG-pXDroiteD);
    				int gradY= Math.abs(pYHaut-pYBas)+Math.abs(2*pCourant-pYHautH-pYBasB);
    				
    				// SI Δx < Δy
    				if(gradX<gradY){
    					
    					est_ip.putPixel(i,j,((pXGauche+pXDroite)/2+(2*pCourant-pXGaucheG-pXDroiteD)/4));
    				}
    				// SI Δx > Δy
    				else if(gradX>gradY){
    					est_ip.putPixel(i,j,((pYHaut+pYBas)/2+(2*pCourant-pYHautH-pYBasB)/4));
    				}
    				// SI Δx = Δy
    				else{
    					est_ip.putPixel(i,j,((pYHaut+pXGauche+pXDroite+pYBas)/4+(4*pCourant-pYHautH-pXGaucheG-pXDroiteD-pYBasB)/8));
    				}
    			}
    		}
    		
    		for(int j=1;j<height;j=j+2){
    			for(int i=0;i<width;i=i+2){
    			
    				int pCourant = cfa_ip.getPixel(i,j) & 0xff;
    				
    				int pXGauche = cfa_ip.getPixel(i-1,j) & 0xff;
    				int pXDroite = cfa_ip.getPixel(i+1,j) & 0xff;
    				int pXGaucheG = cfa_ip.getPixel(i-2,j) & 0xff;
    				int pXDroiteD = cfa_ip.getPixel(i+2,j) & 0xff;
    				
    				int pYHaut = cfa_ip.getPixel(i,j-1) & 0xff;
    				int pYBas = cfa_ip.getPixel(i,j+1) & 0xff;
    				int pYHautH = cfa_ip.getPixel(i,j-2) & 0xff;
    				int pYBasB = cfa_ip.getPixel(i,j+2) & 0xff;
    				
    				int gradX= Math.abs(pXGauche-pXDroite)+Math.abs(2*pCourant-pXGaucheG-pXDroiteD);
    				int gradY= Math.abs(pYHaut-pYBas)+Math.abs(2*pCourant-pYHautH-pYBasB);
    				if(gradX<gradY){
    					
    					est_ip.putPixel(i,j,((pXGauche+pXDroite)/2+(2*pCourant-pXGaucheG-pXDroiteD)/4));
    				}
    				else if(gradX>gradY){
    					est_ip.putPixel(i,j,((pYHaut+pYBas)/2+(2*pCourant-pYHautH-pYBasB)/4));
    				}
    				else{
    					est_ip.putPixel(i,j,((pYHaut+pXGauche+pXDroite+pYBas)/4+(4*pCourant-pYHautH-pXGaucheG-pXDroiteD-pYBasB)/8));
    				}
    			}
    		}
    		
    		return (est_ip);
	}

	/**
	 * Calcul le plan R par interpolation bilinéaire
	 * 
	 * @param ip
	 * @return
	 */
	public ImageProcessor planR(ImageProcessor ip) {
		// Déclaration d'un noyau et d'un objet Convolver pour la convolution
		float[] kernel = { 1, 2, 1, 2, 4, 2, 1, 2, 1 };
		for (int i = 0; i < kernel.length; i++) {
			kernel[i] = kernel[i] / 4;
		}
		ImageProcessor red = cfa_samples(ip, 0);
		Convolver conv = new Convolver();
		conv.setNormalize(false); // SANS normalisation (par défaut, convolve() normalise)
		// Composante R estimée par interpolation bilinéaire grâce à la convolution
		conv.convolve(red, kernel, 3, 3);
		return red;
	}

	/**
	 * Calcul le plan B par interpolation bilinéaire
	 * 
	 * @param ip
	 * @return
	 */
	public ImageProcessor planB(ImageProcessor ip) {
		// Déclaration d'un noyau et d'un objet Convolver pour la convolution
		float[] kernel = { 1, 2, 1, 2, 4, 2, 1, 2, 1 };
		for (int i = 0; i < kernel.length; i++) {
			kernel[i] = kernel[i] / 4;
		}
		ImageProcessor blue = cfa_samples(ip, 2);
		Convolver conv = new Convolver();
		conv.setNormalize(false); // SANS normalisation (par défaut, convolve() normalise)
		// Composante R estimée par interpolation bilinéaire grâce à la convolution
		conv.convolve(blue, kernel, 3, 3);
		return blue;
	}

	/**
	 * Retourne, à partir de l'image CFA en paramètre "cfa_ip", l'image en niveaux
	 * de gris sur 8 bits correspondant au plan φrouge, φvert ou φbleu suivant la
	 * valeur de k
	 * 
	 * @param cfa_ip l'image CFA utilisée pour le calcul
	 * @param k      un entier représentant la composante (rouge, vert ou bleu)
	 *               utilisée pour calculer le bon φk
	 * @return l'image φk
	 */
	public ImageProcessor cfa_samples(ImageProcessor cfa_ip, int k) {
		width = cfa_ip.getWidth();
		height = cfa_ip.getHeight();

		// Création de l'image à retourner
		ImageProcessor phi = new ByteProcessor(width, height);

		// SI φR
		if (k == 0) {
			// Ajout des niveaux de rouge
			for (int x = 1; x < width; x = x + 2) {
				for (int y = 0; y < height; y = y + 2) {
					phi.putPixel(x, y, cfa_ip.getPixel(x, y));
				}
			}
		}
		// SI φV
		else if (k == 1) {
			// Ajout des niveaux de rouge
			for (int x = 0; x < width; x = x + 2) {
				for (int y = 0; y < height; y = y + 2) {
					phi.putPixel(x, y, cfa_ip.getPixel(x, y));
				}
			}

			for (int x = 1; x < width; x = x + 2) {
				for (int y = 1; y < height; y = y + 2) {
					phi.putPixel(x, y, cfa_ip.getPixel(x, y));
				}
			}
		}
		// SI φB
		else {
			for (int x = 0; x < width; x = x + 2) {
				for (int y = 1; y < height; y = y + 2) {
					phi.putPixel(x, y, cfa_ip.getPixel(x, y));
				}
			}
		}

		return phi;
	}
}
