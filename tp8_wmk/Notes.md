Osef de normaliser sobel, ça donne la même chose

Pourquoi c'est nr : quand on est en 8 bit, 

Comme on est en valeur réelle, on ne sait pas où est le noir et où est le blanc
Toutes les valeurs inférieures à un seuil vont être mises en noir, toutes les valeurs sup seront en blanc

Toutes les valeurs au-dessus sont mises en noir et en-dessous en blanc --> il faut trouver le bon seuil pour  trouver le contour 

Appliquer l'équation du vecteur gradient sur ppers_dx et dy

On obtient une image toute noire car il ne sait pas blabla

Image en 8 bits ==> pas bon il manquera des infos 
Voir l'exemple dans le cours où il parle du gradient sur un bit pour ovir que les 8 bits non signés font qu'il y a deux infos qu'on a en moins par rapport aux 32 bits

Seuille trouvé pour les poivronnas (peppers.pgm): 9.53 | 12.71

Chaque tuile correspond à un vecteur X qui va être tatoué par étalement de spectre

On a deux matrices de la tâche de tuile avec un bit à cacher dedans 

On prend la tuile, on llui ajoute u0 - u1

On a une matrice y de taille (tuileW x tuileH) et cette tuile sera 

POurquoi décomposer en tuiles ? Bien ou pas ? OUI bien ! Car plus robuste. Si je fais un croc de l'image, on va quand même récupérer l'info sur d'autres tuiles

Comment décoder ?
	Deux manières de décoder 
	Même message caché dans chaque tuile 
	On va cacher partout 
	Soit on décode daans chaque tuile et ça fait pleins de messages 
	On fait ensuite un vote majoritaire : 
		Pour chaque vecteur M décodé qu'on réupère dans chaque tuile, on rregarde pour le premier bit quelle est la valeur majoritaire, même chose pour la suite 
	Onu alors on décode qu'une seule tuuile qui va être la bonne à partir de toutes 
	Si l'image est bruitée sur crtaines tuiles, osef car il y a beaucoup de tuiles qui ne sont pas bruitées 
	
Baisser le PSNR pour voir les valeurs normales de la FFT : PSNR imperceptible pour moi = 35


PSNR 35 : 
	final : 34.9931
	ber = 0
	sob = 35.0858
	
	
	
PSNR 20 : 
	final 20.086
	BER = 0
	sob final : 22.1882
	
PSNR 40 :
	final : 39.9366
	BER = 0
	sob final : 39.9897
	ecart-type 10 sans sob :
		ber = 0
		
	ecart-type : 20 sans sob 
		ber = 0
		
	ecart-type : 50 sans sob 
		ber = 0
		
	ecart-type 120 sans sob
		ber = 0.25
		
	ecart-type 110 sans sob
		ber = 0.1875
		
	AVEC SOB
		ecart-type 120
			ber = 0.1875 (3 bits erronés)
			
		ecart-type 100
			ber = 0.0625 (1 bit erroné)
	
Norm grad = 7.86 seuil