// Histogramme cumulé
getRawStatistics(surf, moy, min, max, std, h); // h[0..255] <-> histo
print(surf);
print(moy);
print(min);
print(max);
hc=newArray(256);
hc[0]=h[0];
for (i=1;i< h.length;i++) {
    hc[i] = hc[i-1]+h[i] ;
}
Plot.create("Histogramme cumulé de "+getTitle, "Niveau", "hc", hc);
Plot.show();

// Chercher le niveau de gris qui permet 