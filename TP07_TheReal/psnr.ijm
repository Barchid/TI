/*
 * =====================================================================================
 *
 * Filename:  psnr.txt
 * Description:  compute the PSNR between two grayscale images
 * Author:  Benjamin Mathon (BM), benjamin.mathon@univ-lille1.fr
 * Organization:  University of Lille
 *
 * =====================================================================================
 */


setBatchMode(true); //images are hidden during macro execution

n = nImages();
list = newArray(n);
for (i=1; i<=n; i++)
{
    selectImage(i);
    list[i-1] = getTitle();
}

Dialog.create("Compute PSNR");
Dialog.addChoice("First image:", list);
Dialog.addChoice("Second image:", list);
Dialog.show();
image1 = Dialog.getChoice();
image2 = Dialog.getChoice();

//print("\\Clear"); //clear log window
//print("First image = " + image1);
//print("Second image = " + image2);

selectImage(image1);
type1 = is("grayscale");
heightImg1 = getHeight();
widthImg1 = getWidth();

selectImage(image2);
type2 = is("grayscale");
heightImg2 = getHeight();
widthImg2 = getWidth();

if (!type1 || !type2)
{
    print("Only works on 8-bit images.");
}
else if (heightImg1 != heightImg2 || widthImg1 != widthImg2)
{
    print("Dimensions must be equal.");
}
else
{
    eqm = 0.0;	
    for(j = 0 ; j < widthImg1; j++)
    {
        for(i = 0 ; i < heightImg1; i++)
        {
            selectImage(image1);
            x = getPixel(j,i);
            selectImage(image2);
            y = getPixel(j,i);
            eqm += (x-y) * (x-y);
        }
    }  
    eqm = eqm / (heightImg1*widthImg1);
    psnr = 10*log( 255*255 / eqm ) / log(10);
    print("PSNR(" + image1 + "," + image2 + ") = " + psnr);
}

setBatchMode("exit and display"); //show images