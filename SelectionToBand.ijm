/*
 * process image before 
 * 			spot-detector/colocalization in Icy
 * 			or Mitobo/particles2D in Fiji
 * Gilles Courtand - INCIA - 2020 
 * 
 */


// open image
ImgName=getTitle();
ImgDir=getDirectory("image");
selectWindow(ImgName);

//correct colors ch1:grey ch2:red ch3:green
Stack.setDisplayMode("color");
Stack.setChannel(1);
run("Grays");
Stack.setChannel(2);
run("Red");
Stack.setChannel(3);
run("Green");

//change color mode in "Composite" to see all the channels in same time
Stack.setDisplayMode("composite");

//select the best slice and click ok
waitForUser("select the best slice and click ok");
run("Reduce Dimensionality...", "channels keep");
ImgName2=getTitle();
//user select the cell with "segmented line" tool
setTool("polyline");
//makeLine and right click to finish
waitForUser("Trace selection and right click to finish");
//double click on the tool button to modifie the selection width
//change color mode before straigthen
Stack.setDisplayMode("color");

//run("Straighten...", "title=[P20#4-3_x63_S2-L-DMN#2-Deconvolution (adjustable)-02-2.czi] line=20 process");
run("Straighten...")
//stack to hyperstack (because Straighten convert channels to slices)
run("Make Composite", "display=Color");
//correct colors ch1:grey ch2:red ch3:green
run("Grays");
Stack.setChannel(2);
run("Red");
Stack.setChannel(3);
run("Green");

setOption("ScaleConversions", false);
run("16-bit");

print(ImgName2);
selectWindow(ImgName2);
close();

//save the file
saveAs("Tiff", "");
//colors are not preserved !!!
run("Close All");

