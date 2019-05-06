// Appeler le plugin "SampleCfa"
run("SampleCfa "); 


// Récupérer composante rouge
setSlice(1);
run("Convolve...", "text1=[0.25 0.5 0.25\n0.5 1 0.5\n0.25 0.5 0.25\n] slice");

// Récupérer composante vert
setSlice(2);
run("Convolve...", "text1=[0 0.25 0\n0.25 1 0.25\n0 0.25 0\n] slice");

// Récupérer composante bleu
setSlice(3);
run("Convolve...", "text1=[0.25 0.5 0.25\n0.5 1 0.5\n0.25 0.5 0.25\n] slice");

// Combiner les trois slices en une image couleur
run("Stack to RGB");