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
x = np.ones((101,1)).dot(axe.reshape((1,101)))
y = axe.reshape((101,1)).dot(np.ones((1,101)))

# Position de la source
xs = 0.5
ys = 0.5

# Calcul de la distance
d = np.sqrt((x - xs) * (x - xs) + (y - ys) * (y - ys)) # matrice 101x101 représentant le calcul de la distance pour chaque point (x,y)

# calcul de l'intensité
intensite = 100/(2*np.pi)

# calcul de l'éclairement de chaque point
eclairement = (intensite * (0.5)**2) / ((d**2 + 0.5**2)**(2))

# Création d'une figure matplotlib
fig1 = plt.figure()

# Création des axes sur la figure fig1
axes = fig1.gca(projection=Axes3D.name)
axes.set_xlabel('x')
axes.set_ylabel('y')
#axes.set_zlabel('d')
axes.set_zlabel('eclairement')

# Affichage de la fonction distance sur fig1
#axes.plot_surface(x, y, d, cmap='coolwarm', rstride=5, cstride=5, antialiased=True)

# Affichage de la fonction eclairement sur fig1
axes.plot_surface(x, y, eclairement, cmap='coolwarm', rstride=5, cstride=5, antialiased=True)

max = np.max(eclairement)
min = np.min(eclairement)
print(((max-min)/max) * 100)

fig2 = plt.figure()

# Visualisation de la fonction distance sous forme d'image en niveaux de gris
#plt.imshow(d, cmap='gray')

# Visualisation de la fonction eclairement sous la forme d'image en niveaux de gris
plt.imshow(eclairement, cmap='gray')

# Affichade des figures matplotlib à l'écran
plt.show()