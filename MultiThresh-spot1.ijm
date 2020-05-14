//selectWindow("Capture.tif");
//channel 0
run("Enhance Contrast...", "saturated=0.3");
run("8-bit");
//
run("Maximum Entropy Multi-Threshold", "number=2");
rename("bright");
run("Duplicate...", "title=weak");
selectWindow("bright");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(250, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
//run("Options...", "iterations=1 count=1 black do=Open");
//run("Options...", "iterations=1 count=1 black do=Close");

selectWindow("weak");
setThreshold(1, 255);
run("Convert to Mask");
//run("Options...", "iterations=1 count=1 black do=Open");
//run("Options...", "iterations=1 count=1 black do=Close");
run("Watershed", "slice");

selectWindow("bright");
run("Analyze Particles...", "size=0.02-0.3 circularity=0.30-1.00 show=Masks add in_situ");

selectWindow("weak");
run("Analyze Particles...", "size=0.02-0.3 circularity=0.30-1.00 show=Masks add in_situ");

imageCalculator("Add create", "bright","weak");

selectWindow("weak");
close();
selectWindow("bright");
close();
