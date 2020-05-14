
//ouvrir image
//---> reconstruction de la mosaique avec le plugin grid collection stitching
//---> attention l'image n'est plus étalonnée TODO: ajouter une ligne à la macro
//run("Properties...", "channels=2 slices=3 frames=1 unit=um pixel_width=0.3244015 pixel_height=0.3244015 voxel_depth=1");
//---> l'image comporte 2 canaux  (ch1=green, ch2=red) et 3 slices


//nettoyer le roi-manager
roiManager("reset") 
//récupérer le nom de l'image
imgName=getTitle();
i=indexOf(imgName,".");
imgName=substring(imgName,0,i);
print(imgName);
//run("Channels Tool...");
Stack.setDisplayMode("color");
Stack.setChannel(2);
run("Red");
Stack.setChannel(1);
run("Green");
Dialog.create("Title");
waitForUser("title", "sélectionner le plan le plus net");
Stack.getPosition(channel, slice, frame);

run("Properties...", "channels=2 slices=3 frames=1 unit=um pixel_width=0.3244 pixel_height=0.3244 voxel_depth=1");
Stack.setDisplayMode("composite");
run("Duplicate...", "title=&imgName slices=slice ");
Stack.setDisplayMode("color");

waitForUser("title", "sélectionner le muscle");
roiManager("Add");

setBackgroundColor(0, 0, 0);
run("Clear Outside");

run("Split Channels");
selectWindow("C1-"+imgName);

//run("Z Project...", "projection=[Max Intensity]");

run("Subtract Background...", "rolling=30 sliding");

run("Tubeness", "sigma=0.3244 use");
run("8-bit");
run("Enhance Contrast...", "saturated=0.1 normalize equalize");
run("Gaussian Blur...", "sigma=6");
//ajout d'un traitement pour améliorer (augmenter) la segmentation
run("Enhance Contrast...", "saturated=0.1 normalize");
run("Subtract Background...", "rolling=100");

roiManager("select", 0)
//run("Find Maxima...", "noise=10 output=[Segmented Particles] light");
run("Find Maxima...", "noise=20 output=[Segmented Particles] light");

C2="C2-"+imgName ;
run("Set Measurements...", "area mean standard centroid shape add redirect=&C2 decimal=2");
run("Analyze Particles...", "size=30-600 circularity=0.40-1.00 add");
//run("Analyze Particles...", "size=30.00-600 circularity=0.40-1.00 show=[Overlay Masks] display in_situ");

roiManager("multi-measure measure_all");
roiManager("Save", "");
	
/*		
run("Input/Output...", "jpeg=2 gif=-1 file=.xls save_column");
path=pathDataDir+ImgName+"result.csv";	
saveAs("results", path);
*/
