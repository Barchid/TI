abstract public class DCT1D{

	// ---------------------------------------------------------------------------------
	/**
	 * Transformation DCT 1D directe (méthode de classe)
	 * @param f(m) Signal 1D d'entrée (double[])
	 * @return F(u) Signal transformé (double[])
	 */ 
	public static double[] forwardDCT(double[] f) {
		int M = f.length;	// Taille du signal
		double k = Math.sqrt(2.0 / M); // Facteur de normalisation
		double[] F = new double[M];	// résulat
		for (int u = 0; u < M; u++) {
			double cu = 1.0;
			if (u == 0)
				cu = 1.0 / Math.sqrt(2);	// Facteur de normalisation
			double somme = 0.0;
			for (int m = 0; m < M; m++) {
				somme = somme + f[m] * Math.cos(Math.PI * (m + 0.5) * u / M);
			}
			F[u] = k * cu * somme;
		}
		return F;
	}

	// ---------------------------------------------------------------------------------
	/**
	 * Transformation DCT 1D inverse (méthode de classe)
	 * @param F(u) Signal 1D transformé (double[])
	 * @return f(m) signal inverse (double[])
	 */
	public static double[] inverseDCT(double[] F) {
		int M = F.length;	// Taille du signal
		double k = Math.sqrt(2.0 / M);	// Facteur de normalisation
		double[] f = new double[M];	// résulat
		for (int m = 0; m < M; m++) {
			double somme = 0;
			for (int u = 0; u < M; u++) {
				double cu = 1.0;
				if (u == 0)
					cu = 1.0/Math.sqrt(2);	// Facteur de normalisation dépendant de u
				somme = somme + cu * F[u] * Math.cos(Math.PI * (m + 0.5) * u / M);
			}
			f[m] = k * somme;
		}
		return f;
	}
}