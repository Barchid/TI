# Calcul fréquence :

On a des images qui ont la même fréquence partout (càd on a fréquence en haut, en bas etc à 360)

On dit que l'image est isotrope

Quand on fait TF, on obtient un cercle qui correspond aux freq dans toutes les directions

Pour mesurer freq, on calcul l'inverse du rayon autour du centre pour la première réitération du moti


==> f1 : 1/10 cycle.pixel^-1

==> f2 : 
	Pour réduire les erreurs du lissage, on mesure la distance du centre au cycle 5 et on divise
	1/100
	
# Propriétés des FFT
Avant, on avait 3 petits points (les deux raies secondaires de part et d'autre du centre).
Maintenant, comme on a une fréquence dans toutes les idrections, c'est come si on avait ces raies secondaires les unes à côté des autres ce qui fait un cercle.

Pour F1 : 
	le motif est + grand dans la TF car la période est + grande
	
Pour F2 : 
	Le mpotif est + petit parce que ....
	

# Lien entre Moiré et F1 F2
	Moire c'est l'addition des deux F1 F2
	
	Les FFT vont s'additionner

# Appliquer le scale et vérifier si respect théorème de Shannon
	Ca respecte car l'échantillonage respecte encore le théorème de Shannon
	
	Sous-echantillonage de facteur 8, ça respecte pas dingue mdr la pute dde sa mère de chienne
	
# Appliquer scale à facteur 8
	Respecte pas Shannon
	C'est l'image F1 qui foutl am erde car sa fréquence est plus grande du coup ça fout la merde, 
	F2 est 10 fois plus petite donc tout va bien
	
#
FFT
itérer sur les pixels
	si c'est >= 0.5, on met 0
	sinon, x1
	
# vers la fin du TP
	Eviter cet effet de repliement : 
		tu dois faire setBatchMode(true)
		Et finir avec setBatchMode(false)
		
		Car sinon on a un effet de repliement, on doit lui dire "oublie ça plz"
		
		On va prendre le spectre et on va multiplier par 0 pour le spectre qui pète les burnes et 1 pour le restep arce qyue blc
		
		getPixel et setPixel issou
		
		Je séléctionne l'autre image et je fais la multiplication des deux avec get et set pixels
		
		Sélectionner image 1
		Sélectionner image 2
		Faire multiplication 
		
		Ca, il va péter un cable parce que trop de trucs à faire par seconde mdr
		
		Indice : 
			deux for imbriqués
		
		Donc go setBatchMode(true) = je n'affiche pas l'image que je charge