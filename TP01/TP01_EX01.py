# Importer le module numpy pour manipuler des vecteurs / matrices
import numpy as np

# Importer le module matplotlib.pyplot pour l'affichage de figures
import matplotlib.pyplot as plt

# Permettre l'affichage de surfaces 3D
from mpl_toolkits.mplot3d import Axes3D

# Fermeture des figures précédemment ouvertes
plt.close('all')

# Définition des échantillons sur un axe
axe = np.linspace(0, 1, 101)

# Définition des éléments de surface
x = np.ones((101,1)).dot(axe.reshape((1,101))) # position x des points de 1 à 100
y = axe.reshape((101,1)).dot(np.ones((1,101))) # position y des points de 1 à 100

# Position de la source (le point situé juste en dessous de la source de lumière)
xs = 0.5 #0.5m car elle est au centre
ys = 0.5 #0.5m car elle est à 1/2 metre du carré

# Calcul de la distance
d = np.sqrt((x - xs) * (x - xs) + (y - ys) * (y - ys))
    # application de pythagore !
    # distance entre P et la source en x et en y
    
# Création d'une figure matplotlib
fig1 = plt.figure()

# calcul de l'intensité
intensite = 100 / (2*np.pi)

# calcul de l'eclairement
ep = (intensite*(0.5))/((d**2) + (0.5**2))**(3/2)


# Création des axes sur la figure fig1
axes = fig1.gca(projection=Axes3D.name)
axes.set_xlabel('x') # position x des points
axes.set_ylabel('y') # position y des points
axes.set_zlabel('ep') # distance des points x,y par rappot à la source

# Affichage de la fonction distance sur fig1
axes.plot_surface(x, y, ep, cmap='coolwarm', rstride=5, cstride=5, antialiased=True)

# Visualisation de la fonction distance sous forme d'image en niveaux de gris
fig2 = plt.figure()
plt.imshow(ep, cmap='gray')

max = np.max(ep)
min = np.min(ep)
print(((max-min)/max) * 100)

# Affichade des figures matplotlib à l'écran
plt.show()