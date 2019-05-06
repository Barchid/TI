import ij.ImagePlus;
import ij.ImageStack;
import ij.plugin.filter.PlugInFilter;
import ij.process.ByteProcessor;
import ij.process.FloatProcessor;
import ij.process.ImageProcessor;

public class DCTPlug_ implements PlugInFilter {
	ImagePlus imp; // Fen�tre contenant l'image de r�f�rence
	int width; // Largeur de la fen�tre
	int height; // Hauteur de la fen�tre

	// Initialisation du plugin
	public int setup(String arg, ImagePlus imp) {
		this.imp = imp;
		return PlugInFilter.DOES_8G;
	}

	public void run(ImageProcessor ip) {

		// Lecture des dimensions de la fen�tre
		width = imp.getWidth();
		height = imp.getHeight();

		ImageProcessor dup = ip.duplicate().convertToFloat();
		ImageProcessor inv = ip.duplicate().convertToFloat();
		
		dup.add(-128);
		inv.add(-128);
		
		// Action de la DCT2D
		DCT2D.forwardDCT((FloatProcessor) dup);
		DCT2D.forwardDCT((FloatProcessor) inv);
		
		// Action de l'inverse
		DCT2D.inverseDCT((FloatProcessor) inv);
		inv.add(128);
		
		// Afficher les images
		ImagePlus dct2d = new ImagePlus("DCT2D", dup);
		ImagePlus dct2dinv = new ImagePlus("Inverse DCT2D", inv.convertToByte(false));
		
		dct2d.show();
		dct2dinv.show();
	}

	/**
	 * Centre les valeurs de niveaux de gris de l'image en param�tre en soustrayant
	 * 128 partout
	 * 
	 * @param bp l'image � ccentrer
	 */
	public void soustraire128(FloatProcessor bp) {
		for (int x = 0; x < bp.getWidth(); x++) {
			for (int y = 0; y < bp.getHeight(); y++) {
				bp.putPixel(x, y, bp.getPixel(x, y) - 128);
			}
		}
	}
}
