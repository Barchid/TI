# Notes
Constater que la valeur est > 255 est important

Val min et max de norm gradient qu'on a calculé 
	min = 0
	max = 1416774
	
POurquoi on n'obtient pas même chose que ImageJ ?
	On a normalisé le filtre mais ImageJ ne normalise pas 
	La valeur la plu élevée est bien le même pixel que celle retrouvée 
	TOut est mis à l'échelle chez nous 
	Dû à la normalisation du filtre
	
Approcher la dérivéee d'une fonction 1D en discret 
	Valeur à droite - valeur à gauche / 2
	
	
Le masque de Sobel il fait un lissage suivant la direction perpendiculaire à la direction de dérivation 
	Un filtre gaussien mono-dimensionnelle
		Filtre gaussien est [1 2 1]^-1
		
	On combine les opérations lissage et dérivation
	
Calcule à faire :
	Pas de brghtness mdr
	Quand on fait findEdge - Norme à nous, ça fait 0 donc on a bien la même chose 
	
Trouver seuil satisfaisant ?
	Non, on a des pixels qui ne sont pas des contours et des pixels contours qui en arrière plan qui ne sont pas pris dans les pixels candidats 
	