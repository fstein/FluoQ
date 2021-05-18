//This Macro was written by Frank Stein - For comments,critique or to report bugs - please contact me via frank.stein@embl.de
//FluoQ is licensed under the GNU General Public License as published by the Free Software Foundation (http://www.gnu.org/licenses/gpl.txt )
//getStringWidth(string)
var nooftrch;var noofratioch;var transmissiono;var noofcolocch;var dir_save;var cAresultsno;var Asegch;var Athresholdmethods;var AallROIsSD;var AallROIs;var AnormallROIsSD;var AnormallROIs;var ASlice;var Aamountrois;var Adefaults;var amountrois;var Asubfolderpath;var maxseriesnumber;var Aseriesname;var Afilepathes;var Aparentfolder;var Aseries;var date;var dir;var resultstring;var resultstringpath;var norm;var dirorig;var stimulation;var spforig;var Exptype;var origtitle2;var sresultstringpath;var sresultstring;var dir_saveorig;var tmp_file_dir; var tmp_file;var timestamp;var timestamp2;var medianFRETchange;var SDmeanFRETchange;var SDEmeanFRETchange;var SDmedianFRETchange;var meanFRETchange;var Dirarray;var Dirarrayfilename;var meanFRETchange;var AFRETsc;var scwidth;var scheight;var minparticlesize_signalreach;var thresholdmask;var minvalue_signalreach;var thresholdpic;var nResultsorig;var nResults2;var plotidsc;var ROIsfullpath;var stimulustoplots;var normalize;var AParametersc;var expfilename;var Acells;var Aintensitychangesc;var FRETcalcchoice;var background;var background_;var minvalue_i;var minvalue_;var maxvalue_d;var maxvalue_a;var maxvalue_n;var maxvalue_ic;var maxvalue_i;var processcounter;
var msAorigtitle;var Awindowstitlearray;var msAExperimentnumber;var Atoanal;var Atoanalch;var Atoanalchno;var Asegchno;var msAframes;var msAsavepath;var msAmean;var msAmeanSD;var msAmeanSDE;var msAmedian;var msAmedianSD;var msAROI;var Awindownames;var Achnames;var Achextension;var Achcolor;var Aminvalue;var Amaxvalue;var Abackground;
var msAmeanFRETchange;var msASDmeanFRETchange;var msASDEmeanFRETchange;var msAmedianFRETchange;var msASDmedianFRETchange;var msAROIFRETchange;var msAROIFRETchangeSD;var Amean;var Anormmean;var ASD;var AnormSD;var ASDE;var AnormSDE;var Amedian;var Anormmedian;var ASDM;var AnormSDM;var Amax;var Amin;var Aclasses;var AclassROIs;
macro "FluoQ Macro" {
	requires("1.48h");
	macroname="FluoQ - Fluorescence Quantification";
	shortnotice="FluoQ";
	version2="4-00";
	tmp_version="tmp01";
	version=""+version2+" from 17.10.2018";
	macroinfo="FluoQ version: "+version;
	plotwidth=round(450*1.5);
	plotheight=round(200*1.5);
	setFIJIsettings();//Sets up basic Fiji settings, that every user starts with similar presettings
	waitForUser(macroinfo,""+macroname+"\n \nPlease select your working directory in the next step.\nThis folder should contain your single images or your microscopy output file(s).\nFiles in any subfolder will also be recognized.");
	closeimages();//closes all open images
	closewindows();//close all open windows
	check_memory();
	dir = getDirectory("Choose your working directory:");
	if(lengthOf(dir)==0)exit("No working directory was chosen!");
	Acolor=newArray("black","red","blue","green","orange","magenta","pink","yellow","darkGray","gray","lightGray");
	Achanneltype=newArray("Denominator channel for ratiometric imaging (e.g. donor for FRET)","Numerator channel for ratiometric imaging (e.g. acceptor/transfer for FRET)","Intensiometric channel","Cell staining channel for cell segmentation","Nuclear staining channel for cell segmentation (using voronoi algorithm)","Transmission channel","Ignore channel");
	AmeasureTitle=newArray("Area","Mean gray value","Standard deviation","Modal gray value","Min gray value","Max gray value","Perimeter","Circularity","Aspect ratio","Roundness","Solidity","Integrated density","Raw Integrated density","Median","Skewness","Kurtosis","Center of mass - X","Center of mass - Y","Centroid - X","Centroid - Y","Bounding rectangle -X","Bounding rectangle -Y","Bounding rectangle -Width","Bounding rectangle -Height","Fit ellipse -Major","Fit ellipse -Minor","Fit ellipse -Angle","Feret's diameter - length","Feret's diameter - X","Feret's diameter - Y","Feret's diameter - Angle","Feret's diameter - min length");
	AmeasureAbbrev=newArray("Area","Mean","StdDev","Mode","Min","Max","Perim.","Circ.","AR","Round","Solidity","IntDen","RawIntDen","Median","Skew","Kurt","XM","YM","X","Y","BX","BY","Width","Height","Major","Minor","Angle","Feret","FeretX","FeretY","FeretAngle","MinFeret");
	AsetMeasurements=newArray("area","mean","standard","modal","min","min","perimeter","shape","shape","shape","shape","integrated","integrated","median","skewness","kurtosis","center","center","centroid","centroid","bounding","bounding","bounding","bounding","fit","fit","fit","feret's ","feret's ","feret's ","feret's ","feret's ");
	Ameasuretit=newArray("Mean gray value","Modal gray value","Median gray value","Integrated density","Skewness of pixel distribution","Kurtosis of pixel distribution");
	Ameasure=newArray("Mean","Mode","Median","RawIntDen","Skew","Kurt");
	Asetmeasure=newArray("mean","modal","median","integrated","skewness","kurtosis");
	Atrch_method=newArray("None","Manually define two pixel classes","top-hat filter","built-in 'Subtract background'","use outer rim of each cell","built-in 'Subtract background' - exclude cytosol","built-in 'Find Edges'","built-in 'FeatureJ Laplacian'","combine 'Find Edges' and 'Subtract background'");
	tmp_dir = getDirectory("temp");
	tmp_file=tmp_dir+"Temp file "+macroname+"-Ver"+tmp_version+".txt";
	tmp_file_dir=dir+"Temp file "+macroname+"-Ver"+tmp_version+".txt";
	main_Dialog();//Opens the main Dialog to define all parameter and variables
	dir_save=dir+"Results of "+origtitle2+File.separator;
	dir_saveorig=dir_save;
	maxseriesnumber=1;
	getimportparameter();//Get the import Parameter (like filepathes) and performs a quality check (checks if all channel exists)
	experimentchoose_dialog();//let the user choose the experiments he wants to analyze
	experiment_exists=File.exists(dir_save);
	File.makeDirectory(dir_save);
	editnames_dialog();//let the user change the name(s) of their experiment(s)
	if(List.get("saveRfile"))write_resultstring_header();//Writes the header of the final text file that contain all single traces. Could be loaded into R
	initialise_arrays();//initialises some important arrays for the proper function of the macro
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Loop through all experiments
	if(maxseriesnumber<1)exit("No experiment was chosen.");
	for(loop=1;loop<=maxseriesnumber;loop++){
		setloopparameter();
		loopp=loop-1;
		showStatus("Analysis of "+List.get("origtitle")+"- experiment "+loop+"/"+maxseriesnumber);
		showProgress(loop/maxseriesnumber);
		wait(2000);
	//open images
		Aframes=newArray(parseFloat(List.get("chnumber")));
		for(ch=0;ch<parseFloat(List.get("chnumber"));ch++){
			cht=ch+1;
			if(List.get("chtype"+cht)!=Achanneltype[6]){
				open_channel(List.get("import"),List.get("importpath"),dir,Achextension[ch],List.get("series"),Awindownames[ch],List.get("origtitle"));	
				selectWindow(Awindownames[ch]);
				wait(100);
				Aframes[ch]=nSlices;
				if(ch>0){
					if(Aframes[ch]!=Aframes[ch-1]&&List.get("chtype"+ch)!=Achanneltype[6])exit(""+Awindownames[ch]+" has not the same number of Slices as all previously opened channels!");
				};
				if(Exptype==1){
					if(nSlices==1)exit(""+Awindownames[ch]+" is not a stack");
				};
			};
		};
		Bitdorig=bitDepth();
		frames=nSlices;
		date=getdateoffile(List.get("importpath"));
		if(Exptype==1){
			if(loop==1){
				if(round(List.get("stopafterframe"))==0)stopafterframeb=true;
				if(round(List.get("stopafterframe"))!=0)stopafterframeb=false;		
			};
			if(stopafterframeb)List.set("stopafterframe",frames);
			if(parseFloat(List.get("stopafterframe"))>frames)List.set("stopafterframe",frames);
			if(parseFloat(List.get("stopafterframe"))<parseFloat(List.get("Stimulusafterframe")))List.set("stopafterframe",frames);
		};
		if(List.get("import")==2&&Exptype==1){
			check_spf();//Checks if the user entered the right time between each frame
		};
	//process images
		processcounter=0;
		run("ROI Manager...");
		selectWindow("ROI Manager");
		setLocation(scwidth-220,0);
		Aframes=newArray(parseFloat(List.get("chnumber")));
		for(ch=0;ch<parseFloat(List.get("chnumber"));ch++){
			cht=ch+1;
			if(List.get("chtype"+cht)!=Achanneltype[6]){
				selectWindow(Awindownames[ch]);
				if(List.get("runbatchmode")){
					setBatchMode("hide");
				};
				if(List.get("chtype"+cht)!=Achanneltype[5]){
					process_pictures(Awindownames[ch],Achnames[ch],List.get("BM"),List.get("thresholding"),List.get("mradius"),Aminvalue[ch],Abackground[ch],Achcolor[ch],List.get("Asmothenings"));	
				};
				if(List.get("chtype"+cht)==Achanneltype[5]){
					process_pictures_transmission(Awindownames[ch],List.get("thresholding"),List.get("mradius_transmission"),Aminvalue[ch],Abackground[ch],Achcolor[ch],List.get("Asmothenings_transmission"));	
				};
				Aframes[ch]=nSlices;
				if(ch>0){
					if(Aframes[ch]!=Aframes[ch-1]&&List.get("chtype"+ch)!=Achanneltype[6])exit(""+Awindownames[ch]+" has not the same number of Slices as all previously opened channels!");
				};
				Aminvalue[ch]=minvalue_;
				Amaxvalue[ch]=maxvalue_i;
				if(List.get("BM")!=2)Abackground[ch]=background_;
				List.set("minvalue_"+cht,minvalue_);
				List.set("maxvalue_"+cht,maxvalue_i);
				if(List.get("BM")!=2)List.set("background_"+cht,background_);
			};
		};
		frames=nSlices;
	//Calculate Sensitized emission corrected channels
		if(List.get("ComputeSE")){
			SE_channel=calculate_SE(List.get("SEtransfer_corr"),List.get("SEdonor"),List.get("SEacceptor"),List.get("SEtransfer"),parseFloat(List.get("SEalpha")),parseFloat(List.get("SEbeta")),parseFloat(List.get("SEgamma")),parseFloat(List.get("SEdelta")));
			/*imageCalculator("Add create stack", SE_channel,List.get("SEdonor"));
			run("Rename...", "title=[SE FRET denominator]");
			imageCalculator("Divide create 32-bit stack", SE_channel,"SE FRET denominator");
			run("Rename...", "title=["+List.get("SEratiochannel")+"]");
			selectWindow("SE FRET denominator");
			wait(100);
			close();*/
			print(SE_channel);
			imageCalculator("Divide create 32-bit stack", SE_channel,List.get("SEdonor"));
			wait(100);
			run("Rename...", "title=["+List.get("SEratiochannel")+"]");
			selectWindow(List.get("SEratiochannel"));
			wait(100);
			run("Fire");
			resize();	
			getLocationAndSize(x, y, width, height);
			if((2*width)<=scwidth)setLocation(width,0);
		};
	//Calculate ratio images
		for(rp=1;rp<=noofratioch;rp++){
			imageCalculator("Divide create 32-bit stack", List.get("acceptorchannel"+rp),List.get("donorchannel"+rp));
			run("Rename...", "title=["+List.get("ratiochannel"+rp)+"]");
			selectWindow(List.get("ratiochannel"+rp));
			wait(100);
			run("Fire");
			resize();	
			getLocationAndSize(x, y, width, height);
			if((2*width)<=scwidth)setLocation(width,0);
		};
	//Create ROIs
		if(Exptype==0){
			//roiManager("reset");
			roiManager("Associate", "true");
			thresholdchannel=create_thresholdchannel(List.get("segmentationchannel"));
			create_ROIs(thresholdchannel,loop);
		};
		if(Exptype==1){
			thresholdchannel=create_thresholdpic(List.get("segmentationchannel"),List.get("segmentationprojection"));
			create_ROIs(thresholdchannel,loop);
		};
	//Cell classification
		if(List.get("CellClassification")&&amountrois>0){
			AclassROIs=manual_cell_classification(thresholdchannel,Aclasses);
		};
	//Calculate channels to quantify colocalization
		if(amountrois>0){
			for(cc=1;cc<=noofcolocch;cc++){
				calculate_colocalization(List.get("ColocName_POI"+cc),List.get("ColocName_Marker"+cc),cc);
			};
		};
	//Calculate channels to quantify translocation
		if(amountrois>0){
			for(tc=1;tc<=nooftrch;tc++){
				transform_markermask(thresholdmask);
				if(List.get("Markerchannel"+tc)=="None"){
					create_translocationchannel(List.get("POIchannel"+tc),List.get("Localchannel"+tc),List.get("method_trch"),loop);
				};
				if(List.get("Markerchannel"+tc)!="None"){
					calculate_translocationratio(List.get("POIchannel"+tc),List.get("Markerchannel"+tc),List.get("POI_marker"+tc),List.get("POI_background"+tc),List.get("POI_ratio"+tc));
				};
			};
		};
		if(isOpen(thresholdmask)){
			selectWindow(thresholdmask);
			wait(100);
			close();
		};
		ASlice = newArray(frames);
		Atime=newArray(frames);
		ASlice=newArray(frames);
		for(f=1;f<=frames;f++){
			i=f-1;
			ASlice[i]=f;
		};
	//Different Experimenttypes
	//Exptype==0
		if(Exptype==0){
			analyze_exptype0(List.get("segmentationchannel"));	
		};
	//Exptype==1
		if(Exptype==1){
		//frames Parameter 
			for(f=0;f<frames;f++){
				Atime[f]=round(f*parseFloat(List.get("spf")));
			};
			Amean=newArray(frames*Atoanal.length);
			Anormmean=newArray(frames*Atoanal.length);
			ASD=newArray(frames*Atoanal.length);
			AnormSD=newArray(frames*Atoanal.length);
			ASDE=newArray(frames*Atoanal.length);
			AnormSDE=newArray(frames*Atoanal.length);
			Amedian=newArray(frames*Atoanal.length);
			Anormmedian=newArray(frames*Atoanal.length);
			ASDM=newArray(frames*Atoanal.length);
			AnormSDM=newArray(frames*Atoanal.length);
			Amax=newArray(frames*Atoanal.length);
			Amin=newArray(frames*Atoanal.length);
			getLocationAndSize(x, y, width, height);
			amountrois=roiManager("count");
			if(stimulation)AFRETsc=newArray(amountrois*Atoanal.length);
			if(List.get("Fitequations")){
				AParametera=newArray(amountrois*Atoanal.length);
				AParameterb=newArray(amountrois*Atoanal.length);
				AParameterc=newArray(amountrois*Atoanal.length);
				AParameterd=newArray(amountrois*Atoanal.length);
				AParameterR=newArray(amountrois*Atoanal.length);
			};
			if(isOpen("Log")){
				print("\\Clear");
			};
			if(amountrois>0){
				//a[slice+ROIno*frames+channelno*amountrois*frames];
				AallROIs=newArray(frames*amountrois*Atoanal.length);
				AallROIsSD=newArray(frames*amountrois*Atoanal.length);
				AnormallROIs=newArray(frames*amountrois*Atoanal.length);
				AnormallROIsSD=newArray(frames*amountrois*Atoanal.length);
				//for(ch=0;ch<Awindownames.length;ch++){
				for(ch=0;ch<Awindownames.length;ch++){
					channelno=Atoanal.length+1;
					for(ch2=0;ch2<Atoanal.length;ch2++){
						if(ch==Atoanal[ch2]){
							channelno=ch2;
						};
					};
					multimeasureresultsplot(Awindownames[ch],"Plot - "+Achnames[ch]+" "+List.get("Measure")+" intensity of all ROIs versus time",""+Achnames[ch]+" "+List.get("Measure")+" intensity",dir_save,Atime,channelno);	
				};
				if(List.get("saveanalysis")){
					for(channelno=0;channelno<Atoanal.length;channelno++){
						ochannelno=Atoanal[channelno];
						for(slice=0;slice<frames;slice++){
							Aslideresult=newArray(amountrois);
							Anormslideresult=newArray(amountrois);
							for(ROIno=0;ROIno<amountrois;ROIno++){
								Aslideresult[ROIno]=AallROIs[slice+ROIno*frames+channelno*amountrois*frames];
								Anormslideresult[ROIno]=AnormallROIs[slice+ROIno*frames+channelno*amountrois*frames];						
							};
							Amean[slice+channelno*frames]=calMean(Aslideresult);
							Anormmean[slice+channelno*frames]=calMean(Anormslideresult);
							if(amountrois>1&&!List.get("onecellexp")){
								ASD[slice+channelno*frames]=calSD(Aslideresult);
								AnormSD[slice+channelno*frames]=calSD(Anormslideresult);
							};
							if(amountrois>1&&!List.get("onecellexp")){
								ASDE[slice+channelno*frames]=calSDE(Aslideresult);
								AnormSDE[slice+channelno*frames]=calSDE(Anormslideresult);
							};
							if(amountrois>2&&!List.get("onecellexp")){
								Amedian[slice+channelno*frames]=calMedian(Aslideresult);
								Anormmedian[slice+channelno*frames]=calMedian(Anormslideresult);
							};
							if(amountrois>2&&!List.get("onecellexp")){
								ASDM[slice+channelno*frames]=calQuartilsdiff(Aslideresult);
								AnormSDM[slice+channelno*frames]=calQuartilsdiff(Anormslideresult);
							};
							if(amountrois>2&&!List.get("onecellexp")){
								Amax[slice+channelno*frames]=calMax(Aslideresult);
							};
							if(amountrois>2&&!List.get("onecellexp")){
								Amin[slice+channelno*frames]=calMin(Aslideresult);
							};
						};
						channel=Awindownames[ochannelno]; 
						for(ROIno=0;ROIno<amountrois;ROIno++){
							AsingleROItrace=extract_array(AallROIs,ROIno,channelno,amountrois,frames);
							AsingleROItraceSD=extract_array(AallROIsSD,ROIno,channelno,amountrois,frames);
							if(stimulation)AFRETsc[ROIno+channelno*amountrois]=CalAmplitudeChange(Atime,AsingleROItrace,parseFloat(List.get("Stimulusafterframe")),FRETcalcchoice,parseFloat(List.get("Equilibrationtime")),parseFloat(List.get("stopafterframe")));
							if(List.get("Fitequations")){
								AParametersc=decaysc(Atime,AsingleROItrace,parseFloat(List.get("Stimulusafterframe")),parseFloat(List.get("Equilibrationtime")),parseFloat(List.get("Fitequation")),true,dir_save,"Single cell response fitting of "+Achnames[ochannelno],ROIno+1,amountrois,parseFloat(List.get("stopafterframe")));
								AParametera[ROIno+channelno*amountrois]=AParametersc[0];
								AParameterb[ROIno+channelno*amountrois]=AParametersc[1];
								AParameterR[ROIno+channelno*amountrois]=AParametersc[AParametersc.length-1];
								if(AParametersc.length>3)AParameterc[ROIno+channelno*amountrois]=AParametersc[2];
								if(AParametersc.length>4)AParameterd[ROIno+channelno*amountrois]=AParametersc[3];
							};
						};
					};
					print_all_in_results(AallROIs,Atoanal,Awindownames,Achnames,dir_save,List.get("origtitle"));
					if(stimulation){
						print_mean_amplitude_changes(AFRETsc,Atoanal,Awindownames,Achnames,dir_save,List.get("origtitle"));		
					};
					plot_all_channels(Atoanal,Awindownames,Achnames,dir_save,List.get("origtitle"));
				};
				run("Set Measurements...", "  mean standard redirect=None decimal=3");
			};
		//Multiexperiment analysis
			if(maxseriesnumber>1&&List.get("saveanalysis")){
				msAorigtitle[loopp]=List.get("origtitle");
				msAExperimentnumber[loopp]=loop;
				msAframes[loopp]=frames;
				msAsavepath[loopp]=dir_save;
				msAROI[loopp]=amountrois;	
			};
			if(maxseriesnumber>1&&amountrois>0&&List.get("saveanalysis")){
				run("Set Measurements...", "  mean standard redirect=None decimal=3");
				run("Clear Results");
				for(i=0;i<Atoanal.length;i++){
					channelno=Atoanal[i];
					if(!List.get("onecellexp")&&stimulation){
						msAmeanFRETchange[loopp+i*maxseriesnumber]=meanFRETchange[i];
						msASDmeanFRETchange[loopp+i*maxseriesnumber]=SDmeanFRETchange[i];
						msASDEmeanFRETchange[loopp+i*maxseriesnumber]=SDEmeanFRETchange[i];
						if(amountrois>2){
							if(!List.get("onecellexp"))msAmedianFRETchange[loopp+i*maxseriesnumber]=medianFRETchange[i];
							if(!List.get("onecellexp"))msASDmedianFRETchange[loopp+i*maxseriesnumber]=SDmedianFRETchange[i];	
						};
					};
					if(List.get("onecellexp")&&stimulation){
						for(ROIno=0;ROIno<amountrois;ROIno++){
							msAROIFRETchange[loopp+ROIno*maxseriesnumber+i*parseFloat(List.get("ROIstoremember"))*maxseriesnumber]=AFRETsc[ROIno+i*amountrois];
							if(ROIno==(parseFloat(List.get("ROIstoremember"))-1))ROIno=amountrois-1;
						};
					};
				//Write in Resultstable
					if(!List.get("onecellexp")){
						tablename="All mean "+Awindownames[channelno]+" "+norm+List.get("Measure")+" traces of "+origtitle2;
						print_in_master_results_mean(extract_array2(Amean,i,frames),extract_array2(ASD,i,frames),extract_array2(ASDE,i,frames),extract_array2(Anormmean,i,frames),extract_array2(AnormSD,i,frames),extract_array2(AnormSDE,i,frames),tablename,List.get("origtitle"));
						tablename="All median "+Awindownames[channelno]+" "+norm+List.get("Measure")+" traces of "+origtitle2;
						print_in_master_results_median(extract_array2(Amedian,i,frames),extract_array2(ASDM,i,frames),extract_array2(Anormmedian,i,frames),extract_array2(AnormSDM,i,frames),tablename,List.get("origtitle"));
					};
					if(List.get("onecellexp")){
						for(ROIno=0;ROIno<amountrois;ROIno++){
							ROI=ROIno+1;
							tablename="All "+List.get("Measure")+" "+Awindownames[channelno]+" single ROI traces of "+origtitle2;
							print_in_master_results(extract_array(AallROIs,ROIno,i,amountrois,frames),extract_array(AallROIsSD,ROIno,i,amountrois,frames),tablename,"ROI "+ROI+" of "+List.get("origtitle"));
							//if(ROIno==(ROIstoremember-1))ROIno=amountrois-1;
						};
					};
				};
			};//end of Multiexperiment analysis
		};//end of Exptype==1 condition
	//Save windows	 
		save_windows();
		update_parameterlist();
 		save_parameter();
 		List.set("spf",spforig);
 		if(Exptype==1){
			if(stopafterframeb)List.set("stopafterframe",0);
		};
		check_memory();
		if(List.get("runbatchmode")){
			run("Close All");
			setBatchMode(false);
		};
 	};//end of maxseriesnumber-loop 
 	if(maxseriesnumber>1&&List.get("saveanalysis")){
 		output_multiexperimentresults();
 	};
	saveparameter(); //Save all used parameters in a temp file
	if(List.get("cls")){
		closeimages();
	};
	closewindows();
	delete_all_global_variables();
	//run("Tile");
	beep();
	waitForUser(macroinfo,"Analysis complete!\n(Results were saved in folder "+dir_saveorig+" )");
};
function delete_all_global_variables(){
	run("Collect Garbage");
	Asegch=false;
	cAresultsno=false;
	Athresholdmethods=false;
	AallROIsSD=false;
	AallROIs=false;
	AnormallROIsSD=false;
	AnormallROIs=false;
	ASlice=false;
	Aamountrois=false;
	Adefaults=false;
	amountrois=false;
	Asubfolderpath=false;maxseriesnumber=false;
	Aseriesname=false;
	Afilepathes=false;
	Aparentfolder=false;
	Aseries=false;
	date=false;
	dir=false;
	resultstring=false;
	resultstringpath=false;
	norm=false;
	dirorig=false;
	stimulation=false;
	spforig=false;
	Exptype=false;
	origtitle2=false;
	sresultstringpath=false;
	sresultstring=false;
	tmp_file_dir=false;
	tmp_file=false;
	macroname=false;
	version=false;
	version2=false;
	macroinfo=false;
	timestamp=false;
	timestamp2=false;
	medianFRETchange=false;
	SDmeanFRETchange=false;
	SDmedianFRETchange=false;
	meanFRETchange=false;
	Dirarray=false;
	Dirarrayfilename=false;
	meanFRETchange=false;
	AFRETsc=false;
	scwidth=false;
	scheight=false;
	minparticlesize_signalreach=false;
	thresholdmask=false;minvalue_signalreach=false;thresholdpic=false;AmeansecondROISD=false;AimeanwholecellSD=false;AimeanfirstROISD=false;AimeansecondROISD=false;nResultsorig=false;nResults2=false;
	plotidsc=false;ROIsfullpath=false;stimulustoplots=false;normalize=false;AParametersc=false;version=false;expfilename=false;Acells=false;Aintensitychangesc=false;Decaystart=false;FRETcalcchoice=false;
	background=false;background_=false;minvalue_i=false;minvalue_=false;maxvalue_d=false;maxvalue_a=false;maxvalue_n=false;maxvalue_ic=false;maxvalue_i=false;saveorig=false;processcounter=false;
	msAorigtitle=false;msAExperimentnumber=false;Atoanal=false;msAframes=false;msAsavepath=false;msAmean=false;msAmeanSD=false;msAmedian=false;msAmedianSD=false;msAROI=false;Awindownames=false;
	Achnames=false;Achextension=false;Achcolor=false;Aminvalue=false;Amaxvalue=false;Abackground=false;
	msAmeanFRETchange=false;
	msASDmeanFRETchange=false;
	msASDEmeanFRETchange=false;
	msAmedianFRETchange=false;
	msASDmedianFRETchange=false;
	msAROIFRETchange=false;
	msAROIFRETchangeSD=false;
	Amean=false;
	ASD=false;
	Amedian=false;
	ASDM=false;
	Amax=false;
	Amin=false;
};
function closewindows(){
	if(isOpen("Log")){
		selectWindow("Log");
		run("Close"); 
	};
	if(isOpen("ROI Manager")){
		selectWindow("ROI Manager");
		run("Close"); 
	};
	if(isOpen("Results")){
		selectWindow("Results");
		run("Close");	
	};
	if(isOpen("Threshold")){
		selectWindow("Threshold");
		run("Close") ;
	};
	if(isOpen("Synchronize Windows")){
		selectWindow("Synchronize Windows");
		run("Close");
	};
	if(isOpen("B&C")){
		selectWindow("B&C");
		run("Close");
	};
};
function open_channel(import,importpath,dir,filenamecontains,series,channelname,origtitle){//import = importmethod, dir=directory, importpath=path, filenamecontains=either string or channel number, series=which series
	//import=1 : Images exist in subfolder
	//import=2 : LOCI Bioformat importer
	//import=3 : Manually open pictures.
	channelexists=false;
	if(import==1){//images exist in subfolder
		filelist = getFileList(dir);
		for(i=0;i<filelist.length;i++){
			containstring=indexOf(filelist[i], filenamecontains);
			if(containstring>=0){
				channelexists=true;
				importpath=dir+filelist[i];	
				i=filelist.length;
			};
		};
		if(!channelexists)exit(""+channelname+" does not exist.");
		if(channelexists){
			number=filelist.length;
			run("Image Sequence...", "open=["+dir+"] number=["+number+"] starting=1 increment=1 scale =100 file=["+filenamecontains+"] sort");	
		};	
	};
	if(import==2){	//import with LOCI-bioformat importer
		series="series_list="+List.get("series");
		if(!List.get("seriesgrouping")){
			if(ch==0&&List.get("OpenRois")){
				if(parseFloat(List.get("chnumber"))>1)run("Bio-Formats Importer", "open=["+importpath+"] color_mode=Default display_rois use_virtual_stack view=Hyperstack stack_order=XYCZT "+series+""); 
				if(parseFloat(List.get("chnumber"))==1)run("Bio-Formats Importer", "open=["+importpath+"] color_mode=Default display_rois view=Hyperstack stack_order=XYCZT "+series+""); 
			};
			if(ch!=0||!List.get("OpenRois")){
				if(parseFloat(List.get("chnumber"))>1)run("Bio-Formats Importer", "open=["+importpath+"] color_mode=Default use_virtual_stack view=Hyperstack stack_order=XYCZT "+series+""); 
				if(parseFloat(List.get("chnumber"))==1)run("Bio-Formats Importer", "open=["+importpath+"] color_mode=Default view=Hyperstack stack_order=XYCZT "+series+""); 
			};
		};
		if(List.get("seriesgrouping")){
			setBatchMode(true);
			run("Bio-Formats Importer", "open=["+importpath+"] color_mode=Default open_all_series view=Hyperstack stack_order=XYCZT concatenate_series");
			openi=nImages;
			Acloseimages=newArray();
			for (i=0; i<openi; i++) {
		       		selectImage(i+1);
		       		wait(100);
		       		ititle=getTitle();
		       		shouldbeclosed=true;
		       		for(j=0;j<Awindownames.length;j++){
		       			if(ititle==Awindownames[j])shouldbeclosed=false;
		       		};
		       		if(ititle==Awindowstitlearray[loopp])shouldbeclosed=false;
		       		if(shouldbeclosed)Acloseimages=Array.concat(Acloseimages,ititle);
		      	};
		      	for(i=0;i<Acloseimages.length;i++){
		      		selectWindow(Acloseimages[i]);
		      		wait(100);
		      		close();
		      	};
			selectWindow(Awindowstitlearray[loopp]);
			setBatchMode("exit and display");
		};
		wait(100);
		IDorig=getImageID();
		pIDorig=getTitle();
		nameoffile=getInfo("image.filename");
		check2=false;
		selectImage(IDorig);
		wait(100);
		Stack.getDimensions(width, height, channels, slices, frames);
		wait(100);
		if(List.get("import")==2){
			if(List.get("Swapdimensions")){
				Stack.setDimensions(channels, frames,slices);
				selectImage(IDorig);
				wait(100);
				Stack.getDimensions(width, height, channels, slices, frames);
				wait(100);
			};
		};
		if(channels<parseFloat(List.get("chnumber")))exit(""+channelname+" does not contain enough channels.");
	//For different channels and a Z-Stack - will do Z-Project with sum slices
		if(channels>=parseFloat(List.get("chnumber"))&&slices>1){
			List.set("checkzstack",true);
			if(frames==1){
				if(channels<filenamecontains)exit(""+channelname+" does not exist in the Hyperstack");
				if(channels>=filenamecontains){
					Stack.setChannel(filenamecontains);
					channelexists=true;
				};
				if(channelexists){
					if(Stack.isHyperstack){
						if(List.get("zprojectionmethod")=="Use only one plane"&&slices>1){
							if(cht==1){
								waitForUser("Please choose the Z-plane, that should be used for further analysis.");
								Stack.getPosition(channel, slice, frame);
								List.set("Zslice",slice);
							}else{
								Stack.setSlice(List.get("Zslice"));
							};
							Stack.setChannel(filenamecontains);
							wait(100);
							run("Reduce Dimensionality...", " ");
						}else{
							wait(100);
							run("Reduce Dimensionality...", " slices");
						};
						IDtheo=IDorig-1;
						if(isOpen(IDtheo)){
							selectImage(IDtheo);
						};
					};
					iID=getImageID();
					if(List.get("zprojectionmethod")!="Use only one plane"&&slices>1){
						run("Z Project...", "start=1 stop=["+slices+"] projection=["+List.get("zprojectionmethod")+"]");
						run("Rename...", "title=["+pIDorig+"]");
						if(isOpen(iID)){
							selectImage(iID);
							wait(100);
							close();	
						};
					};
					resize();				
				};
				if(!channelexists)exit(""+channelname+" does not exist.");			
			};
			if(frames>1){
				if(channels<filenamecontains)exit(""+channelname+" does not exist in the Hyperstack");
				if(channels>=filenamecontains){
					Stack.setChannel(filenamecontains);
					channelexists=true;
				};
				if(channelexists){
					if(Stack.isHyperstack){
						if(List.get("zprojectionmethod")=="Use only one plane"&&slices>1){
							if(cht==1){
								waitForUser("Please choose the Z-plane, that should be used for further analysis.");
								Stack.getPosition(channel, slice, frame);
								List.set("Zslice",slice);
							}else{
								Stack.setSlice(List.get("Zslice"));
							};
							Stack.setChannel(filenamecontains);
							wait(100);
							run("Reduce Dimensionality...", "frames");
						}else{
							wait(100);
							run("Reduce Dimensionality...", "slices frames");
						};
						IDtheo=IDorig-1;
						if(isOpen(IDtheo)){
							selectImage(IDtheo);
							wait(100);
						};
					};
					iID=getImageID();
					if(List.get("zprojectionmethod")!="Use only one plane"&&slices>1){
						run("Z Project...", "start=1 stop=["+slices+"] projection=["+List.get("zprojectionmethod")+"] all");
						run("Rename...", "title=["+pIDorig+"]");
						if(isOpen(iID)){
							selectImage(iID);
							wait(100);
							close();	
						};
					};
					resize();				
				};
				if(!channelexists)exit(""+channelname+" does not exist.");
			};
		};
	//For different channels but only 1 slice and no z-stack
		if(channels>=parseFloat(List.get("chnumber"))&&frames==1&&slices==1){
			if(channels<filenamecontains)exit(""+channelname+" does not exist in the Hyperstack");
			if(channels>=filenamecontains){
				deleteallslicesexcept2(filenamecontains);
				channelexists=true;
			};
			if(!channelexists)exit(""+channelname+" does not exist.");		
		};
		if(!Stack.isHyperstack&&parseFloat(List.get("chnumber"))<2)check2=true;
	//For different channels with many frames but no z-stack
		if(channels>=parseFloat(List.get("chnumber"))&&frames>1&&slices==1){
			if(channels<filenamecontains)exit(""+channelname+" does not exist in the Hyperstack");
			if(channels>=filenamecontains){
				Stack.setChannel(filenamecontains);
				if(Stack.isHyperstack)run("Reduce Dimensionality...", "  frames");
				if(channels==parseFloat(List.get("chnumber"))){
					for(i=0;i<frames;i++){
						setSlice(i+1);		
					};
					setSlice(1);
				};
				channelexists=true;
			};
			if(!channelexists)exit(""+channelname+" does not exist.");
		};
		check=false;
		if(check2)check=true;
		IDtheo=IDorig-1;
		if(isOpen(IDtheo)){
			selectImage(IDtheo);
			wait(100);
			check=true;	
		};
		if(isOpen(pIDorig)){
			selectWindow(pIDorig);
			wait(100);
			check=true;	
		};
		if(!check){
			IDreal=getImageID();
			exit("A problem occured opening the "+channelname+" - Check your imported data if they are a Hyperstack.");	
		};
	};
	if(import==3){
		showStatus("Analysis of "+origtitle+"- experiment "+loop+"/"+maxseriesnumber);
		showProgress(loop/maxseriesnumber);
		waitForUser(macroinfo,"Please open "+channelname+" after pressing OK.");
		importpath=File.openDialog("Please open "+channelname+" after pressing OK.");
		open(importpath);
		Stack.getDimensions(width, height, channels, slices, frames);
	};
	run("Rename...", "title=["+channelname+"]");
	wait(100);
	check_memory();
	resize();
};
function guessexperimentname(channel){
	selectWindow(channel);
	wait(100);
	windowstitle=getTitle();
	indexpoint=lastIndexOf(filename, ".");
	filetype=substring(filename, indexpoint);
	filetype=toLowerCase(filetype);
	filetype="[.]"+filetype;
	nameoffile=getInfo("image.filename");
	if(List.get("multiseries")&&List.get("import")==2){
		windowstitle = replace(windowstitle, nameoffile, "");
	};
	if(List.get("import")==2){
		doescontainpoint=indexOf(nameoffile, ".");	
		if(doescontainpoint>=0){
			indexpoint=lastIndexOf(nameoffile, ".");
			filetype=substring(nameoffile, indexpoint);
			filetype="[.]"+filetype;
			windowstitle = replace(windowstitle, filetype, "");
		};
	};
	windowstitle = replace(windowstitle, filenamecontains, "");
	windowstitle = replace(windowstitle, filetype, "");
	windowstitle = checkforcertainchar(windowstitle);
	if(indexOf(windowstitle, "_Image")>0){
		windowstitle=substring(windowstitle, 0, indexOf(windowstitle, "_Image"));
	};
	if(indexOf(windowstitle, "unprocessed")>0){
		windowstitle=substring(windowstitle, 0, indexOf(windowstitle, "unprocessed"));
	};
	if(List.get("seriesgrouping")){
		windowstitle=expfilename;	
	};
	windowstitle = checkforcertainchar(windowstitle);
	return windowstitle;	
};
function checkforcertainchar(string){
	string = replace(string, "\t", "_");
	string = replace(string, "\\;", "_");
	string = replace(string, "/", "_");
	string = replace(string, "\\/", "_");
	string = replace(string, "\\:", "div");
	string = replace(string, "\\*", "mult");
	string = replace(string, "\\?", "");
	string = replace(string, "-", "_");
	string = replace(string, ".", "_");
	string = replace(string, " ", "");
	return string;
};
function process_pictures_transmission(windowstitle,thresholding,mradius,minvalue_i,background_i,channelcolor,Asmothenings){
	selectWindow(windowstitle);
	wait(100);
	run(channelcolor);
	getLocationAndSize(x, y, width, height);
	if(processcounter==0){
		xpos=0;
		ypos=0;
	};
	if(processcounter==1){
		xpos=width;
		ypos=0;
	};
	if(processcounter==2){
		xpos=0;
		ypos=height;
	};
	if(processcounter==3){
		xpos=width;
		ypos=height;
	};
	if(processcounter<=3){
		if(xpos<scwidth&&ypos<scheight)setLocation(xpos,ypos);
	};
	Smaxvalue=bitDepth();
	maxvalue=pow(2, Smaxvalue)-parseFloat(List.get("noNaNs")); //calculates the maximum pixel value possible for 8-16-32 bit pictures
	wait(100);
	smooth_image(windowstitle,Asmothenings,mradius);
	wait(100);
	if(List.get("NaN_transmission")){
		set_background_nan(windowstitle,thresholding,loop,List.get("processguieachloop"),List.get("thresholdmethod"),minvalue_i,maxvalue);
	}else{
		selectWindow(windowstitle);
	        wait(100);
	        test=getTitle();
	        while(test!=windowstitle){
	        	selectWindow(windowstitle);
	        	wait(100);
	        	test=getTitle();
	        };
	        ID=getImageID();
	        run("Brightness/Contrast...");
		setMinAndMax(0, maxvalue);
		run("32-bit");
		wait(100);
	};
	resetMinAndMax();
	processcounter++;
};
function process_pictures(windowstitle,channelname,BM,thresholding,mradius,minvalue_i,background_i,channelcolor,Asmothenings){
	selectWindow(windowstitle);
	wait(100);
	run(channelcolor);
	getLocationAndSize(x, y, width, height);
	if(processcounter==0){
		xpos=0;
		ypos=0;
	};
	if(processcounter==1){
		xpos=width;
		ypos=0;
	};
	if(processcounter==2){
		xpos=0;
		ypos=height;
	};
	if(processcounter==3){
		xpos=width;
		ypos=height;
	};
	if(processcounter<=3){
		if(xpos<scwidth&&ypos<scheight)setLocation(xpos,ypos);//,screenWidth/2,screenHeight/2
	};
	Smaxvalue=bitDepth();
	maxvalue=pow(2, Smaxvalue)-parseFloat(List.get("noNaNs")); //calculates the maximum pixel value possible for 8-16-32 bit pictures
	if(List.get("noNaNss")){
		remove_saturated_pixels(windowstitle);	
	};
	if(!List.get("noNaNss")){	
		for(rp=1;rp<=noofratioch;rp++){
			if(windowstitle==List.get("acceptorchannel"+rp)||windowstitle==List.get("donorchannel"+rp)){
				remove_saturated_pixels(windowstitle);
			};
		};
	};
	wait(100);
	remove_background(windowstitle,BM,background_i,List.get("processguieachloop"));
	wait(100);
	smooth_image(windowstitle,Asmothenings,mradius);
	wait(100);
	set_background_nan(windowstitle,thresholding,loop,List.get("processguieachloop"),List.get("thresholdmethod"),minvalue_i,maxvalue);
	resetMinAndMax();
	processcounter++;
};
function set_background_nan(channelname,thresholding,loop,processguieachloop,thresholdmethod,minvalue_i,maxvalue){
        selectWindow(channelname);
        wait(100);
        test=getTitle();
        while(test!=channelname){
        	selectWindow(channelname);
        	wait(100);
        	test=getTitle();
        };
        ID=getImageID();
        run("Brightness/Contrast...");
	setMinAndMax(0, maxvalue);
	run("32-bit");
	wait(100);
	Atlim=threshold_channel(channelname,thresholding,thresholdmethod,loop,processguieachloop,minvalue_i);
	wait(100);
	minvalue_i=Atlim[0];
	maxvalue_i=Atlim[1];
	minvalue_=minvalue_i;
	maxvalue_=maxvalue_i;
	selectWindow(channelname);
	wait(100);
	selectImage(ID);
	wait(100);
	if(isActive(ID)){
		if(bitDepth()==32){
			setThreshold(minvalue_i, maxvalue_i);
		};
		if(bitDepth()!=32){
			run("32-bit");
			setThreshold(minvalue_i, maxvalue_i);
		};
	};
	if(!isActive(ID)){
		wait(100);
		selectImage(ID);
		wait(100);
		if(bitDepth()==32){
			setThreshold(minvalue_i, maxvalue_i);
		};
		if(bitDepth()!=32){
			run("32-bit");
			setThreshold(minvalue_i, maxvalue_i);
		};
	};
	getThreshold(lower, upper);
	selectWindow(channelname);
	wait(100);
	if(lower>=0&&upper>0&&bitDepth()==32){
		if(isActive(ID)){
			run("NaN Background", "stack");
		};
		if(!isActive(ID)){
			wait(100);
			selectImage(ID);
			wait(100);
			setThreshold(minvalue_i, maxvalue_i);
			wait(100);
			run("NaN Background", "stack");
		};
	};
	resetThreshold();
};
function smooth_image(channel,Asmothenings,RBradius){
	selectWindow(channel);
	wait(100);
	Smoothening=""+Asmothenings+"...";
        if(Asmothenings!="None")run(Smoothening, "radius=["+RBradius+"] stack"); 	
};
function remove_background(channel,BM,background_i,processguieachloop){
	selectWindow(channel);
	wait(100);
	//if(BM==4&&processguieachloop)BM=3;
	if(BM==1){run("Subtract...", "stack value=["+background_i+"]");};
	if(BM==2){run("Subtract Background...", "rolling=["+List.get("RBradius")+"] stack");};
	if(BM==3&&(loop==1||!processguieachloop)){
		run("Clear Results");
		run("Set Measurements...", "  mean redirect=None decimal=3");
		getLocationAndSize(x, y, width, height);
		setLocation(0,0);
		run("Select None");
		while(selectionType==-1){
			wait(10);
			showProgress(loop/maxseriesnumber);
			arrange_and_wait(0,channel,"None","Background subtraction in "+channelname+"!\nPlease create a ROI that covers only background to identify the background value!\nThen press OK.",0,"oval");
		};
		selectWindow(channel);
		wait(100);
		setLocation(x,y);
		getStatistics(area, mean);
		run("Select None");	
		background_i=mean;
		run("Subtract...", "stack value=["+background_i+"]");
	};
	if(BM==3&&loop!=1&&processguieachloop)run("Subtract...", "stack value=["+background_i+"]");
	if(BM==4){
		run("Clear Results");
		roiManager("reset");
		run("Set Measurements...", "  mean redirect=None decimal=3");
		getLocationAndSize(x, y, width, height);
		selectWindow(channel);
		wait(100);
		setLocation(0,0);
		run("Select None");
		if(processcounter==0){
			while(selectionType==-1){
				wait(100);
				showProgress(loop/maxseriesnumber);
				arrange_and_wait(0,channel,"None","Background subtraction in "+channelname+"!\nPlease create a ROI that covers only background to identify the background value!\nThen press OK.",0,"oval");
			};
			roiManager("Add");
			selectWindow(channel);
			wait(100);
			run("Select None");
			roiManager("Select", 0);
		};
		background_all=0;
		for(l=0;l<nSlices;l++){
			currentslice=l+1;
			setSlice(currentslice);
			run("Restore Selection");
			getStatistics(area, mean);
			run("Select None");
			background_i=mean;
			background_all=background_all+background_i;
			run("Subtract...", " value=["+background_i+"] slice");
		};
		setSlice(1);
		background_i=background_all/nSlices;
		if(processcounter==0){
			selectWindow(channel);
			wait(100);
			setLocation(x,y);
			run("Select None");	
			fullpath=dir_save+"Background ROI of "+List.get("origtitle")+".zip";
			roiManager("Save", fullpath);
		};
		roiManager("reset");
	};
	if(BM==5){
		run("Clear Results");
		roiManager("reset");
		run("Set Measurements...", "  mean limit redirect=["+channel+"] decimal=3");
		getLocationAndSize(x, y, width, height);
		selectWindow(channel);
		wait(100);
		setLocation(0,0);
		run("Select None");
		run("Select All");
		run("Add to Manager");
		setAutoThreshold(List.get("thresholdmethod_background")+" stack");
		run("Threshold...");	
		roiManager("Associate", "false");
		roiManager("Multi Measure");
		columname="Mean1";
		selectWindow(channel);
		for(i=0;i<nSlices;i++){
			mean=getResult("Mean1", i);
			setSlice(i+1);
			run("Select None");
			run("Subtract...", " value=["+mean+"] slice");
		};
		run("Clear Results");
		roiManager("reset");
		run("Set Measurements...", "  mean redirect=None decimal=3");
	};
	background_=background_i;	
};
function remove_saturated_pixels(channel){
	selectWindow(channel);
	wait(100);
	test=getTitle();
        while(test!=channel){
        	selectWindow(channel);
        	wait(100);
        	test=getTitle();
        };
	ID=getImageID();
	Smaxvalue=bitDepth();
	maxvalue=pow(2, Smaxvalue)-1;
	run("32-bit");
	if(Smaxvalue==16){
		maxvalue=getmaximumpixel(channel)-1;
		if(maxvalue>255&&maxvalue<4096)maxvalue=pow(2, 12)-1;
		if(maxvalue>4095&&maxvalue<32768)maxvalue=pow(2, 15)-1;
		if(maxvalue>32768&&maxvalue<65536)maxvalue=pow(2, 16)-1;
	};
	maxvalue_i=maxvalue;
	maxvalue=maxvalue-1;
	selectWindow(channel);
	wait(100);
	if(isActive(ID)){
		run("Threshold...");
	};
	if(!isActive(ID)){
		selectImage(ID);
		run("Threshold...");
	};
	setThreshold(0, maxvalue);
	getThreshold(lower, upper);
	if(lower>=0&&upper>0&&bitDepth()==32){
		if(isActive(ID)){
			run("NaN Background", "stack");
		};
		if(!isActive(ID)){
			selectImage(ID);
			run("NaN Background", "stack");
		};
	};
	resetThreshold();
	run(""+Smaxvalue+"-bit");	
};
function checkROIsforNaN_channel(channel,dir_save){
	if(isOpen(channel)){	
		run("Clear Results");
		if(isOpen(channel)){	
			selectWindow(channel);
			wait(100);
			frames=nSlices;
			run("Set Measurements...", "mean stack redirect=["+channel+"] decimal=3");
			roiManager("Deselect");
			roiManager("Show All");
			roiManager("Measure");
			amountrois=roiManager("count");
			dc=0;
			for(c = 1; c <= nResults; c++){
				r=c-1;
				checkNaN=getResult("Mean", r);
				frame=getResult("Slice", r);
				NaNcheck=isNaN(checkNaN);
				if(NaNcheck){
					delroi=c-dc-1;
					roiManager("Select",delroi);
					roiManager("Delete");
					dc=dc+1;
					print("ROI "+c+" was deleted from "+channel+" in slice "+frame+".");
				};
			};
		};
		roiManager("Deselect");
	};
	amountrois=roiManager("count");
	return amountrois;
};
function checkROIsforNaN(channel,dir_save){
	if(isOpen(channel)){
		run("Clear Results");
		selectWindow(channel);
		wait(100);
		frames=nSlices-1;
		run("Set Measurements...", "mean redirect=["+channel+"] decimal=3");
		roiManager("Show All");
		roiManager("Multi Measure");
		roiManager("Deselect");
		amountrois=roiManager("count");
		dc=0;
		for(c = 1; c <= amountrois; c++){
			column="Mean"+c;
			for(r=0;r<frames;r++){
				checkNaN=getResult(column, r);
				NaNcheck=isNaN(checkNaN);
				if(NaNcheck){
					r=frames;
					delroi=c-dc-1;
					roiManager("Select",delroi);
					roiManager("Delete");
					dc=dc+1;
					print("ROI "+c+" was deleted from "+channel+".");
				};
			};
		};
		left=amountrois-dc;
		if(dc>1){
			print(dc+" ROIs of Pictures in folder "+dir_save+" were deleted. NaN was found as a mean gray value of "+dc+" ROIs in "+channel+" in one or more slides."); 
			fullpath=dir_save+"Attention - ROIs deleted in "+List.get("origtitle")+".txt";
			selectWindow("Log");
			wait(100);
			saveAs("Text", fullpath);
		};
		run("Clear Results");
	};
	amountrois=roiManager("count");
	return amountrois;
};
function closeimages(){
	if(isOpen("Log")){
		print("\\Clear");
	};
	if(isOpen("ROI Manager")){
		amountrois=roiManager("count");
		while(amountrois>0){
			roiManager("Delete");
			amountrois=roiManager("count");
		};
	};
	if(isOpen("Results")){
		run("Clear Results");	
	};
	run("Close All");
};
function CalAmplitudeChange(xValues,yValues,Stimulusafterframe,FRETcalcchoice,Equilibrationtime,stopafterframe){
	frames=xValues.length;
	Stimulusafterframe2=Stimulusafterframe+Equilibrationtime;//frames-Stimulusafterframe-Equilibrationtime
	BeforeSx=newArray(Stimulusafterframe);
	BeforeSy=newArray(Stimulusafterframe);
	AfterSx=newArray(Stimulusafterframe2);
	AfterSy=newArray(Stimulusafterframe2);
	BeforeSx=Array.slice(xValues,0,Stimulusafterframe);
	BeforeSy=Array.slice(yValues,0,Stimulusafterframe);
	AfterSx=Array.slice(xValues,Stimulusafterframe2,stopafterframe);
	AfterSy=Array.slice(yValues,Stimulusafterframe2,stopafterframe);
	AfterSy=smooth_array(AfterSy,1);
	if(FRETcalcchoice==2){
		frames=xValues.length;
		xvalue=Stimulusafterframe+Equilibrationtime/2;
		Fit.doFit("Straight Line", BeforeSx, BeforeSy);
		a=Fit.p(0);//d2s(Fit.p(0),7)
		b=Fit.p(1);//
		Before=b*xvalue+a;
		Fit.doFit("Straight Line", AfterSx, AfterSy);
 		a=Fit.p(0);
		b=Fit.p(1);
		After=b*xvalue+a;
	};
	if(FRETcalcchoice==1){
		Before=calMean(BeforeSy);
		After=calMean(AfterSy);
	};
	if(FRETcalcchoice==3){
		Before=calMean(BeforeSy);
		BeforeSD=calSD(BeforeSy);
		After=calMean(AfterSy);
		if(After<=(Before-2*BeforeSD))After=calMin(AfterSy);	
		if(After>=(Before+2*BeforeSD))After=calMax(AfterSy);
		if(After>(Before-2*BeforeSD)&&After<(Before+2*BeforeSD))After=calMean(AfterSy);
	};
	if(FRETcalcchoice==4){
		Before=calMean(BeforeSy);
		After=calMin(AfterSy);	
	};
	if(FRETcalcchoice==5){
		Before=calMean(BeforeSy);
		After=calMax(AfterSy);
	};
	FRETchange=(After-Before)*100/abs(Before);
  	return FRETchange;
};
function calMin(array){
	array=removeNaN(array);
	Array.getStatistics(array,min,max,mean,stdDev);
	return min;
};
function calMax(array){
	array=removeNaN(array);
	Array.getStatistics(array,min,max,mean,stdDev);
	return max;	
};
function removeNaN(aA){
	c=0;
	while(c<aA.length){
		if(isNaN(aA[c])){
			bA=Array.slice(aA,0,c);
			cA=Array.slice(aA,c+1,aA.length);
			aA=Array.concat(bA,cA);			
		}else c++;
	};
	return aA;
};
function FRETpiccalc(dir_save,title,channel,Stimulusafterframe,Equilibrationtime,FRETcalcchoice,meanchange,stopafterframe){
	selectImage(channel);
	frames=nSlices;
	Afterframe=Stimulusafterframe+Equilibrationtime;
	FRETimage=title;
	run("Z Project...", "start=1 stop=["+Stimulusafterframe+"] projection=Median");
	Before="Baseline";
	run("Rename...", "title=["+Before+"]");
	resize();
	BeforeID=getImageID();
	selectImage(channel);
	if(FRETcalcchoice==2||FRETcalcchoice==3){
		if(meanchange<-10){
			//run("Z Project...", "start=["+Afterframe+"] stop=["+stopafterframe+"] projection=[Min Intensity]");//Min Intensity Average Intensity
			zprojmethod="[Min Intensity]";
		}
		else if(meanchange>10){
			//run("Z Project...", "start=["+Afterframe+"] stop=["+stopafterframe+"] projection=[Max Intensity]");//Max Intensity
			zprojmethod="[Max Intensity]";
		}
		else {
			//run("Z Project...", "start=["+Afterframe+"] stop=["+stopafterframe+"] projection=Median");	
			zprojmethod="Median";
		};
	} else if(FRETcalcchoice==1){
		zprojmethod="Median"; //run("Z Project...", "start=["+Afterframe+"] stop=["+stopafterframe+"] projection=Median");	
	};
	run("Z Project...", "start=["+Afterframe+"] stop=["+stopafterframe+"] projection="+zprojmethod);
	AfterID=getImageID();
	After="Baseline after Stimulus";
	if(AfterID==channel){
		print(" ");
		print("Error - "+title+"- image could not be calculated.");	
		if(Afterframe>frames)print("Stimulus-time plus Reequilibration is bigger than your number of slices");
		print(" ");
	};
	if(AfterID!=channel){
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		run("Threshold...");
		setThreshold(0,max-1);
		getThreshold(lower, upper);
		if(lower>=0&&upper>0&&bitDepth()==32)run("NaN Background", "stack");
		resetThreshold();
		run("Rename...", "title=["+After+"]");
		resize();
		imageCalculator("Difference create 32-bit", Before,After);
		Difference="Difference-Before-After";
		run("Rename...", "title=["+Difference+"]");
		resize();
		DifferenceID=getImageID();
		imageCalculator("Divide create 32-bit", Difference,Before);
		run("Rename...", "title=["+FRETimage+"]");
		resize();
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		maxnew=max-std;
		totalmax=max;
		while(totalmax>1E10){
			maxnew=max-std;
			if(totalmax>1E10){
				setThreshold(0,maxnew);
				getThreshold(lower, upper);
				if(lower>=0&&upper>0&&bitDepth()==32)run("NaN Background", "stack");
			};
			resetThreshold();
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			totalmax=max;
		};
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		maxnew=max;
		//setMinAndMax(0,maxnew);
		run("Fire");
		run("Enhance Contrast", "saturated=0.35");
		roiManager("Show All with labels");
		run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=2 font=12 zoom=1");
		getPixelSize(unit, pixelWidth, pixelHeight);
		scalewidth=round(pixelWidth*getWidth()*0.2);
		if(List.get("import")==2)run("Scale Bar...", "width=["+scalewidth+"] height=4 font=12 color=White background=Black location=[Lower Right] bold label");
		fullpath=dir_save+FRETimage+".tif";
		if(List.get("saveFRETratio"))saveAs("Tiff", fullpath);
		if(isOpen(DifferenceID)){
			selectImage(DifferenceID);
			close();
		};
		if(isOpen(BeforeID)){
			selectImage(BeforeID);
			close();
		};
		if(isOpen(AfterID)){
			selectImage(AfterID);
			close();
		};
	};
};
function calMedian(array){ //Calculates the Median of Amedianrun
	counter=0;
	for(i=0;i<array.length;i++){
		if(!isNaN(array[i]))counter++;
	};
	if(counter>3){
		medianrun=newArray(counter);
		counter=0;
		for(i=0;i<array.length;i++){
			if(!isNaN(array[i])){
				medianrun[counter]=array[i];
				counter++;	
			};
		};
		Array.sort(medianrun);
		l=lengthOf(medianrun)+1;
		Median=l/2;
		Medianf=floor(Median);
		Mediand=Median-Medianf;
		if(Mediand!=0){
			median=(medianrun[Medianf-1]+medianrun[Medianf])/2; 
			};
		if(Mediand==0){
			median=medianrun[Medianf-1];
		};
		return median;
	};
	if(counter<=3){
		median=0;
		return median;	
	};
};
function calQuartilsdiff(array){ //Calculates the difference between the first and third Quartile
	counter=0;
	for(i=0;i<array.length;i++){
		if(!isNaN(array[i]))counter++;
	};
	if(counter>3){
		Amedianrun=newArray(counter);
		counter=0;
		for(i=0;i<array.length;i++){
			if(!isNaN(array[i])){
				Amedianrun[counter]=array[i];
				counter++;	
			};
		};
		Array.sort(Amedianrun);
		l=lengthOf(Amedianrun)+1;
		Q1=l/4;
		Q1f=floor(Q1);
		Q1d=Q1-Q1f;
		Q3=l*3/4;
		Q3f=floor(Q3);
		Q3d=Q3-Q3f;
		if(Q1d==0){
			qdiff=abs((Amedianrun[Q1f-1]-Amedianrun[Q3f-1])/2);	
		};
		if(Q1d!=0){
			Q1v=abs(Amedianrun[Q1f-1]+((Amedianrun[Q1f]-Amedianrun[Q1f-1])*Q1d));			
			Q3v=abs(Amedianrun[Q3f-1]+((Amedianrun[Q3f]-Amedianrun[Q3f-1])*Q3d));	
			qdiff=abs((Q3v-Q1v)/2);
		};
		return qdiff;
	};
	if(counter<=3){
		qdiff=0;
		return qdiff;	
	};
};
function calMean(arrayf){ //Caclulates the Mean value of arrayf
	arrayf=removeNaN(arrayf);
	Array.getStatistics(arrayf,min,max,mean,stdDev);
	return mean;
};
function calSD(arrayf){ //Calculates the Standard Deviation of arrayf
	arrayf=removeNaN(arrayf);
	Array.getStatistics(arrayf,min,max,mean,stdDev);
	if(arrayf.length<=2)stdDev=0;
	return stdDev;
};
function calSDE(array){ //Calculates the Standard Deviation of arrayf
	arrayf=removeNaN(array);
	Array.getStatistics(arrayf,min,max,mean,stdDev);
	if(arrayf.length<=2)return 0;
	sderr=stdDev/sqrt(arrayf.length);
	return sderr;
};
function PlotArray(xValues,yValues,ASD,plottitle,xaxis,yaxis,origtitles,dir_save){
	if(calMean(yValues)!=0){
		Alimits=removeNaN(xValues);
		Array.getStatistics(Alimits, xMin, xMax, mean, stdDev);
		Alimits=removeNaN(yValues);
		Array.getStatistics(Alimits, yMin, yMax, mean, stdDev);
		Alimits=removeNaN(ASD);
		Array.getStatistics(Alimits, min, Errorbars, mean, stdDev);
		xspace=abs(xMin-xMax)*0.05;
		Bars=Errorbars>0;
		if(Bars)yspace=abs(Errorbars*1.05);
		if(!Bars)yspace=abs(yMin-yMax)*0.05;
		xMin = xMin-xspace;xMax=xMax+xspace;yMin=yMin-yspace;yMax=yMax+yspace;
		plotname=plottitle;
		Plot.create(plotname, xaxis, yaxis);
		Plot.setFrameSize(plotwidth, plotheight);
		Plot.setLineWidth(3);
		Plot.setLimits(xMin, xMax, yMin, yMax);
		Plot.setColor("cyan");
		if(stimulustoplots==true){
			for(i=0;i<1000;i++){
				add=(parseFloat(List.get("Equilibrationtime"))*parseFloat(List.get("spf"))/1000)*i;
				Plot.drawLine((parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMin, (parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMax);	
			};
		};
		add_errorbars(xValues,yValues,ASD);
		Plot.setColor("black");
		Plot.setLineWidth(2);
		Plot.add("line",xValues,yValues); 
		Plot.setColor("black");
		setJustification("center");
		Plot.addText(plottitle, 0.5, -0.01);
		Plot.setColor("black");
		Plot.setLineWidth(1);
		setJustification("right");
		heightofchar=14/plotheight;
		Plot.addText(origtitles, 1, 1+2.5*heightofchar);
		setJustification("left");
		Plot.addText(shortnotice, 0, 0);
		if(maxseriesnumber>1){
			setJustification("left");
			Plot.addText(origtitle2, 0, 1+2.5*heightofchar);			
		};
		Plot.setColor("lightGray");
		Plot.show();
		fullpath=dir_save+plotname+".tif";
		if(List.get("saveanalysis"))saveAs("Tiff", fullpath);
	};
};
function PlotMArray(xValues,yValues,ASD,MaxValues,MinValues,plottitle,xaxis,yaxis,origtitles,dir_save){
	if(calMean(yValues)!=0){
		Alimits=removeNaN(xValues);
		Array.getStatistics(Alimits, xMin, xMax, mean, stdDev);
		Alimits=Array.concat(yValues,MaxValues,MinValues);
		Alimits=removeNaN(Alimits);
		Array.getStatistics(Alimits, yMin, yMax, mean, stdDev);
		Alimits=removeNaN(ASD);
		Array.getStatistics(Alimits, min, Errorbars, mean, stdDev);
		xspace=abs(xMin-xMax)*0.05;
		Bars=Errorbars>0;
		if(Bars)yspace=abs(Errorbars*1.05);
		if(!Bars)yspace=abs(yMin-yMax)*0.05;
		xMin = xMin-xspace;xMax=xMax+xspace;yMin=yMin-yspace;yMax=yMax+yspace;
		plotname=plottitle;
		Plot.create(plotname, xaxis, yaxis);
		Plot.setFrameSize(plotwidth, plotheight);
		Plot.setLineWidth(1);
		Plot.setLimits(xMin, xMax, yMin, yMax);
		Plot.setColor("cyan");
		if(stimulustoplots==true){
			for(i=0;i<1000;i++){
				add=(parseFloat(List.get("Equilibrationtime"))*parseFloat(List.get("spf"))/1000)*i;
				Plot.drawLine((parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMin, (parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMax);	
			};
		};
		add_errorbars(xValues,yValues,ASD);
		Plot.setColor("black");
		Plot.setLineWidth(2);
		Plot.add("line",xValues,yValues);
		Plot.add("dots",xValues,yValues);
		Plot.setLineWidth(1);
		Plot.add("crosses", xValues,MaxValues);
		Plot.add("crosses", xValues,MinValues);
		setJustification("center");
		Plot.addText(plottitle, 0.5, -0.01);
		setJustification("right");
		heightofchar=14/plotheight;
		Plot.addText(origtitles, 1, 1+2.5*heightofchar);
		setJustification("left");
		Plot.addText(shortnotice, 0, 0);
		if(maxseriesnumber>1){
			setJustification("left");
			Plot.addText(origtitle2, 0, 1+2.5*heightofchar);			
		};
		Plot.setColor("lightGray");
		Plot.setLineWidth(0.25);
		Plot.show();
		fullpath=dir_save+plotname+".tif";
		if(List.get("saveanalysis"))saveAs("Tiff", fullpath);
	};
};
function normalization(windowname,normalize){	//windows: which window will be normalized, normfactor: Highest number in a set of different experiments to compare them ; scale: put min and max value to 0 and maximum possible value?
	selectWindow(windowname);
	wait(100);
	Bitd=bitDepth();
	maxvalue=pow(2, Bitd)-parseFloat(List.get("noNaNs"));
	if(normalize){
		run("Divide...", "value=["+maxvalue+"] stack");
		run("Multiply...", "value=1 stack");
		run("Enhance Contrast", "saturated=0.35");
	};
	
};   
function save_parameter(){
	print("Macro-Version: "+version);
	print("Date and time the analysis startet: "+timestamp2);
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	month=month+1;
	if(month<10)smonth="0"+month;
	if(month>=10)smonth=month;
	if(dayOfMonth<10)sdayOfMonth="0"+dayOfMonth;
	if(dayOfMonth>=10)sdayOfMonth=dayOfMonth;
	timestamp3=""+year+"-"+smonth+"-"+sdayOfMonth+" - "+hour+"h "+minute+"min";
	print("Date and time of the analysis: "+timestamp3);
	print("Memory usage: "+IJ.freeMemory());
	print("Experiment name: "+origtitle2);
	print("Working folder: "+dir);
	print("Results were saved in: "+dir_saveorig);
	print("Type of experiement: "+List.get("AExptypes"));
	print("Import method: "+List.get("imports"));
	if(List.get("import")==2){
		print("Imagefile: "+List.get("importpath"));
		print("Title of sub-experiment: "+List.get("origtitle"));
	};
	if(List.get("maxseriesnumbers")){
		print("Your experiment contains "+maxseriesnumber+" different series.");
		print("This is series "+loop);
		print("Results for this subexperiment were saved in: "+dir_save);
	};
	print("Details for processing your imaging channels.");
	for(ch=0;ch<parseFloat(List.get("chnumber"));ch++){
		cht=ch+1;
		if(List.get("chtype"+cht)!=Achanneltype[6]){
			chno=ch+1;
			print("Details for channel "+chno);
			print("Type of channel: "+List.get("chtype"+chno));
			print("Name of channel: "+List.get("chname"+chno));
			if(List.get("import")==1)print("Filename contained following string: "+List.get("chabbrev"+chno));
			print("Color of channel: "+List.get("chcolor"+chno));
			if(List.get("checkROIsforNaNs"))print("Automatically detected ROIs that showed NaN as mean values somewhere in the ratio channel were excluded from the analysis.");
			if(List.get("chtype"+ch)!=Achanneltype[5]){
				Aminvalue[ch]=List.get("minvalue_"+chno);
				Abackground[ch]=List.get("background_"+chno);
				print("Processing details:");
				print("Background subtraction method: "+List.get("BMs"));	
				if(List.get("BM")==2){print("Rolling ball radius:"+List.get("RBradius"));};
				if(List.get("BM")!=2&&List.get("BM")!=5){
					print("Subtracted background value: "+List.get("background_"+chno));			
				};
				if(List.get("BM")==5){
					print("No background was subtracted from the images.");	
				};
				print("Image smoothing method: "+List.get("Asmothenings"));
				if(List.get("Asmothenings")!="None")print("Radius size of "+List.get("Asmothenings")+" filter: "+List.get("mradius"));
				print("Thresholding limits::");
				print("Cell thresholding method: "+List.get("thresholdings"));
				if(List.get("thresholding")==3){
					print("Thresholding algorithm used: "+List.get("thresholdmethod"));
				};
				print("Minimum thresholding limit: "+List.get("minvalue_"+chno));
					print("Maximum thresholding limit: "+List.get("maxvalue_"+chno));	
				print(" ");
			};	
		};
	};
	print("Minimum thresholding limit for cell thresholding: "+List.get("minvalue"));
	print(" ");
	if(List.get("noNaNss"))print("Saturated pixels were excluded from the analysis.");
	print("Bit-depth of your pictures: "+Bitdorig);
	print("Your experiment contains "+frames+" slides in a stack.");
	print(" ");
	print(" ");
	if(List.get("containzstack")){
		if(List.get("checkzstack"))print("Your data set contained a Z-Stack. To process your images, a Z-Projection was performed with the following method: "+List.get("zprojectionmethod"));
	};
	print(" ");
	print("Details for the Particle Analyzer:");
	print("Minimum size for Particle Analyzer: "+List.get("particlesize"));
	print("Maximum size for Particle Analyzer: "+List.get("maxparticlesize"));
	print("Minimum circularity for Particle Analyzer: "+List.get("mincircularity"));
	print("Maximum circularity for Particle Analyzer: "+List.get("maxcircularity"));
	print(" ");
	if(List.get("createROIsman"))print("All ROIs were created manually.");
	if(Exptype==1){
		print(" ");
		print("Details for time-series experiment.");
		print("Time per frame: "+List.get("spf")+" seconds.");
		time=parseFloat(List.get("spf"))*frames;
		min=floor(time/60);
		sec=time-60*min;
		sec=round(sec);
		times=" "+min+" min"+" "+sec+" sec";
		print("Total time of experiment: "+times);	
		if(stimulation)Stimulustime=round(parseFloat(List.get("Stimulusafterframe"))*parseFloat(List.get("spf")));
		if(stimulation)Equilibrationtime2=round((parseFloat(List.get("Stimulusafterframe"))+parseFloat(List.get("Equilibrationtime")))*parseFloat(List.get("spf")));
		if(stimulation)print("Stimulus was added after "+List.get("Stimulusafterframe")+" frames / after "+Stimulustime+" seconds");
		if(stimulation)print("Cells stopped to respond after "+List.get("Equilibrationtime")+" frames Stimulation / in total after "+Equilibrationtime2+" seconds");
		if(List.get("Fitequations"))print("Cell respond decay was fitted with "+List.get("AFitequations"));
		if(stimulation)print("Amplitude changes were calculated: "+List.get("FRETcalcchoices"));
		if(List.get("onecellexp"))print("Your experiment contains only one cell per image.");
	};
	fullpath=dir_save+"Processing parameter and results.txt";
	selectWindow("Log");
	saveAs("Text", fullpath);
};
function subfolderarray(dir,chabbrev,chnumber){//partly adapted from http://rsb.info.nih.gov/ij/macros/ListFilesRecursively.txt
	count = 0;
	count2=listFilessub(dir,chabbrev,chnumber); 
	Dirarray=newArray(count2);
	Dirarrayfilename=newArray(count2);
 	count=0;
 	listFiles2sub(dir,chabbrev,chnumber);
 	return Dirarray;
 	function listFilessub(direct,chabbrev,chnumber) {
 		  	Acheck=newArray(chnumber);
 		  	list = getFileList(direct);
 		  	for (i=0; i<list.length; i++) {
  		    		if (endsWith(list[i], "/"))
  		      			listFilessub(""+direct+list[i],chabbrev,chnumber);
  		     		else{
  		     			for(c=0;c<chnumber;c++){
  		     				//doescontainstring=indexOf(list[i],""+chabbrev+c);
  		     				ch=c+1;
  		     				doescontainstring=indexOf(list[i],List.get("chabbrev"+ch));
  		     				if(doescontainstring>=0){
  		     					Acheck[c]=1;			
  		     				};
  		     			};
  		     			if(calMean(Acheck)==1){
   		    				count++;
   		    				i=list.length;
       					};
       				
      		 		};
 			};
     			return count;
  	};
  	function listFiles2sub(direct,chabbrev,chnumber) {
    		 Acheck=newArray(chnumber);
    		 list = getFileList(direct);
   		  for (i=0; i<list.length; i++) {
    		    if (endsWith(list[i], "/"))
     		      listFiles2sub(""+direct+list[i],chabbrev,chnumber);
        		else
        		{
        			for(c=0;c<chnumber;c++){
  		     			//doescontainstring=indexOf(list[i],""+chabbrev+c);
  		     			ch=c+1;
  		     			doescontainstring=indexOf(list[i],List.get("chabbrev"+ch));
  		     			if(doescontainstring>=0){
  		     				Acheck[c]=1;			
  		     			};
  		     		};
       				if(calMean(Acheck)==1){
       					counter=count;
        				Dirarrayfilename[counter]=direct+list[i];
        				Dirarray[counter]=direct;
        				count++;i=list.length;		
       				};
        		};
     		};
 	};
};
function nameofsubfolder(subfolder){
	subfoldername=newArray(subfolder.length);
 	for(i=0;i<subfolder.length;i++){
		showProgress(i/subfolder.length);
		subfoldername[i]=File.getName(subfolder[i]);
	};
	subfoldername_rd=removeDuplicates(subfoldername);
	if(subfoldername_rd.length!=subfoldername.length){
		for(i=0;i<subfolder.length;i++){
			showProgress(i/subfolder.length);
			subfoldername[i]=""+File.getName(File.getParent(subfolder[i]))+"_"+File.getName(subfolder[i]);
		};
	};
 	return subfoldername;
};
function nameofparentfolder(filefullpath){
	parentfolder=newArray(filefullpath.length);
 	for(i=0;i<filefullpath.length;i++){
		foldername=File.getParent(filefullpath[i]);
		indexslash=lastIndexOf(foldername, "/");
		if(indexslash<0)indexslash=lastIndexOf(foldername, "\\");
		if(indexslash<0)indexslash=lastIndexOf(foldername, File.separator);
		foldername=substring(foldername,indexslash+1);
		parentfolder[i]=foldername;
	};
 	return parentfolder;
};
function extendnamewithfoldername(Aparentfolder,Aseriesname){
	if(Aparentfolder.length!=Aseriesname.length){
		return Aseriesname;
	};
	if(Aparentfolder.length==Aseriesname.length){
		counter=0;
		for(i=1;i<Aseriesname.length;i++){
			if(Aparentfolder[i]!=Aparentfolder[i-1])counter++;				
		};
		if(counter!=0){
			for(i=0;i<Aseriesname.length;i++){
				seriesname=Aseriesname[i];
				namecontainfolder=indexOf(seriesname, Aparentfolder[i]);
				if(Aparentfolder[i]!=Aseriesname[i]&&namecontainfolder<0)seriesname=Aparentfolder[i]+"_"+Aseriesname[i];
				Aseriesname[i]=seriesname;
			};
		};
		return Aseriesname;
	};
};
function listarray(name, a) {
      print(name);
      print("Länge von "+name+": "+a.length);
      for (i=0; i<a.length; i++){
      	print(a[i]);
      };
      print(" ");
};
function decay(xValues,yValues,Stimulus,Equilibration,Fitequation,plot,dir_save,plotname){
	startframe=Stimulus+Equilibration;
	xValuesnew=Array.slice(xValues,startframe,parseFloat(List.get("stopafterframe")));
	yValuesnew=Array.slice(yValues,startframe,parseFloat(List.get("stopafterframe")));
	Fit.doFit(Fitequation, xValuesnew, yValuesnew);
	if(plot){
		Fit.plot();
		plotid = getImageID;
		selectImage(plotid);
		fullpath=dir_save+plotname+".tif";
		saveAs("Tiff", fullpath);
	};
	Parameter=newArray(Fit.nParams+1);
	for (j=0; j<=Fit.nParams; j++){
		if(j<Fit.nParams)Parameter[j]=Fit.p(j);
		if(j==Fit.nParams)Parameter[j]=Fit.rSquared;
	};
	return Parameter;         
};
function decaysc(xValues,yValues,Stimulus,Equilibration,Fitequation,plot,dir_save,plotname,moment,end,stopafterframe){
	startframe=Stimulus+Equilibration;
	xValuesnew=Array.slice(xValues,startframe,stopafterframe);
	yValuesnew=Array.slice(yValues,startframe,stopafterframe);
	Fit.doFit(Fitequation, xValuesnew, yValuesnew);
	if(plot){
		Fit.plot();
		if(moment==1){
			plotidsc = getImageID;
		};
		if(moment>1&&moment<=end){
			run("Copy");
        		close();
			selectImage(plotidsc);
			run("Add Slice");
			run("Paste");				
		};
		if(moment==end){
			selectImage(plotidsc);
			fullpath=dir_save+plotname+".tif";
			saveAs("Tiff", fullpath);
		};
	};
	Parameter=newArray(Fit.nParams+1);
	for (j=0; j<=Fit.nParams; j++){
		if(j<Fit.nParams)Parameter[j]=Fit.p(j);
		if(j==Fit.nParams)Parameter[j]=Fit.rSquared;
	};
	return Parameter;         
};
function Setbaselinetoone(channel,Stimulusafterframe,Equilibrationtime){
	selectWindow(channel);
	wait(100);
	run("Z Project...", "start=1 stop=["+Stimulusafterframe+"] projection=Median");
	Before="Baseline";
	run("Rename...", "title=["+Before+"]");
	resize();
	imageCalculator("Divide 32-bit stack", channel,Before);
	if(isOpen(Before)){
		selectImage(Before);
		close();
	};
};
function importpatharray(dir,extension,experimentcontainstring){
	count = 1;
	count2=listFiles(dir,extension,experimentcontainstring); 
	Dirarray=newArray(count2);
	Dirarrayfilename=newArray(count2);
 	count=1;
 	listFiles2(dir,extension,experimentcontainstring);
 	count3=0;
 	for(i=0;i<Dirarrayfilename.length;i++){
 		if(i>0){
 			if(Dirarray[i]!=Dirarray[i-1])	count3++;
 		};
 	};
 	if(count3>0){
 		subfolder=newArray(count3);
 		count4=0;
 		for(i=0;i<Dirarrayfilename.length;i++){
 			if(i==0){
 				subfolder[count4]=Dirarray[i];
 				//subfolder[count4] = replace(subfolder[count4], "/", "\\");
 				count4++;
 			};
 			if(i>0){
 				if(Dirarray[i]!=Dirarray[i-1]&&Dirarray[i]!=0){
					subfolder[count4]=Dirarray[i];
					//subfolder[count4] = replace(subfolder[count4], "/", "\\");
 					count4++;
 				};
 			};
 		};
 		filenumber=0;
 		for(i=0;i<subfolder.length;i++){
			showProgress(i/subfolder.length);
			Asubfolderfiles=getFileList(subfolder[i]);
				for(h=0;h<Asubfolderfiles.length;h++){
					doescontainextension=endsWith(Asubfolderfiles[h], extension);
					if(experimentcontainstring!="0")doescontainstring=indexOf(Asubfolderfiles[h], experimentcontainstring);
  		     			if(experimentcontainstring=="0")doescontainstring=1;
  		     			if(doescontainextension&&doescontainstring>=0){
  		     				filenumber++;
  		     			};
				};
		};
		Aimportpathes=newArray(filenumber);
		filenumber=0;
		for(i=0;i<subfolder.length;i++){
			showProgress(i/subfolder.length);
			Asubfolderfiles=getFileList(subfolder[i]);
				for(h=0;h<Asubfolderfiles.length;h++){
					doescontainextension=endsWith(Asubfolderfiles[h], extension);
					if(experimentcontainstring!="0")doescontainstring=indexOf(Asubfolderfiles[h], experimentcontainstring);
  		     			if(experimentcontainstring=="0")doescontainstring=1;
  		     			if(doescontainextension&&doescontainstring>=0){
						Aimportpathes[filenumber]=subfolder[i]+Asubfolderfiles[h];
						filenumber++;	
					};
				};
		};
	};
 	if(count3==0){
 		Aimportpathes=newArray(1);
 		Aimportpathes[0]="No file was found";
 	};

 	return Aimportpathes;
 
	function listFiles(dir,extension,experimentcontainstring) {
 		  	list = getFileList(dir);
		   	for (i=0; i<list.length; i++) {
  		    		if (endsWith(list[i], "/"))
  		      		listFiles(""+dir+list[i],extension,experimentcontainstring);
  		     		else{
  		     			doescontainextension=endsWith(list[i], extension);
  		     			if(experimentcontainstring!="0")doescontainstring=indexOf(list[i], experimentcontainstring);
  		     			if(experimentcontainstring=="0")doescontainstring=1;
  		     			if(doescontainextension&&doescontainstring>=0){
   		    				count++; 
       					};
       				};
 			};
     			return count;
  	};
  	function listFiles2(dir,extension,experimentcontainstring) {
    		 list = getFileList(dir);
   		  for (i=0; i<list.length; i++) {
    		    if (endsWith(list[i], "/"))
     		      listFiles2(""+dir+list[i],extension,experimentcontainstring);
        		else
        		{
        			doescontainextension=endsWith(list[i], extension);
        			if(experimentcontainstring!="0")doescontainstring=indexOf(list[i], experimentcontainstring);
  		     		if(experimentcontainstring=="0")doescontainstring=1;
  		     		if(doescontainextension&&doescontainstring>=0){
       					counter=count-1;
       					Dirarrayfilename[counter]=""+dir+list[i];
        				Dirarray[counter]=dir;
        				count++;
        			};
        		};
     		};
 	};
};
function filenamearray(Aimportpathes,extension){
	Aexpnames=newArray(Aimportpathes.length);
	for(i=0;i<Aimportpathes.length;i++){
		name=File.getName(Aimportpathes[i]);
		name=replace(name, extension, "");
		name = replace(name, "/", "");
		name = replace(name, "\\/", "");
		name = replace(name, "\\:", "");
		name = replace(name, "\\*", "");
		name = replace(name, "\\?", "");
		Aexpnames[i]=name;	
	};
	return Aexpnames;
};
function plotresults(loadingpath,Xcolumname,Acolumnname,msAorigtitle,Arowlength,origtitle,plottitle,xaxis,yaxis,dir_saveorig){
	if(loadingpath!=0){
		run("Clear Results");
		open(loadingpath);
	};
	plottitle="Plot -"+plottitle;
	//extract_array2(Amean,channelno,frames) channelno=Columnname	
	yValues=newArray(calMax(Arowlength)*Acolumnname.length);
	yValues2=newArray(0);
	for(col=0;col<Acolumnname.length;col++){
		trace=getfromResults(Acolumnname[col],Arowlength[col]);
		for(row=0;row<Arowlength[col];row++){
			yValues[row+col*calMax(Arowlength)]=trace[row];
			//getResult(Acolumnname[col],row);
		};
		yValues2=Array.concat(yValues2,trace);
	};
	xValues=getfromResults(Xcolumname,calMax(Arowlength));
	Alimits=removeNaN(yValues2);
	Array.getStatistics(xValues, xMin, xMax, mean, stdDev);
	Array.getStatistics(Alimits, yMin, yMax, mean, stdDev);
	xMaxorig=xMax;
	xMinorig=xMin;
	xspace=abs(xMin-xMax)*0.05;
	yspace=abs(yMin-yMax)*0.05;
	xMin = xMin-xspace;xMax=xMax+xspace;yMin=yMin-yspace;yMax=yMax+yspace;
	if(plotheight/msAorigtitle.length<14){
		plotheight=msAorigtitle.length*14.2;
	};
	stringlengthes=newArray(msAorigtitle.length);
	for(l=0;l<2;l++){	
		heightofchar=14/plotheight;//*********************************
		widthofchar=7/plotwidth;//*********************************
		begincharheight=1.2*heightofchar;//*********************************
		for(i=0;i<msAorigtitle.length;i++){
			stringlengthes[i]=lengthOf(msAorigtitle[i])*widthofchar;		
		};
		stringlength=calMax(stringlengthes);
		textlength=stringlength+4*widthofchar;
		textwidth=1-textlength;//*********************************
		timeswider=textlength+1+widthofchar;//*********************************
		if(l==0)xMax=xMax*timeswider;//*********************************
		linewidth=0.05*xMaxorig;//*********************************
		if(l==0){
			plotwidthnew=timeswider*plotwidth;
			plotwidth=plotwidthnew;
			
		};
	};
	Plot.create(plottitle, xaxis, yaxis);
	Plot.setFrameSize(plotwidth, plotheight);
	Plot.setLineWidth(1);
	Plot.setLimits(xMin, xMax, yMin, yMax);
	if(stimulustoplots){
		Plot.setColor("cyan");
		for(i=0;i<1000;i++){
			add=(parseFloat(List.get("Equilibrationtime"))*parseFloat(List.get("spf"))/1000)*i;
			Plot.drawLine((parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMin, (parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMax);	
		};
	};
	col=0;
	for(channelno=0;channelno<Acolumnname.length;channelno++){
		Aline=extract_array3(yValues,channelno,Arowlength[channelno],calMax(Arowlength));
		add_line(xValues,Aline,Acolor[col],msAorigtitle[channelno],channelno);
		col++;
		if(col==Acolor.length)col=0;
	};
	//Captions
	setJustification("center");
	Plot.addText(plottitle, 0.5, 0);
	setJustification("left");
	Plot.addText(shortnotice, 0, 0);
	if(maxseriesnumber>1){
		setJustification("left");
		Plot.addText(origtitle2, 0, 1+2.5*heightofchar);			
	};
	Plot.setLineWidth(1);
	Plot.show();
	fullpath=dir_saveorig+plottitle+".tif";
	if(List.get("saveanalysis"))saveAs("Tiff", fullpath);
};
function PlotRArray(Atitle,xValues,yValues,ASD,plottitle,xaxis,yaxis,origtitles,dir_save){
	if(xValues.length>1&&xValues.length<200){	
		Alimits=removeNaN(xValues);
		Array.getStatistics(Alimits, xMin, xMax, mean, stdDev);
		Alimits=Array.concat(yValues,ASD);
		Alimits=removeNaN(Alimits);
		Alimits=Array.concat(Alimits,0);
		Array.getStatistics(Alimits, yMin, yMax, mean, stdDev);
		Alimits=removeNaN(ASD);
		Array.getStatistics(Alimits, min, Errorbars, mean, stdDev);
		xMaxorig=xMax;
		xMinorig=xMin;
		xspace=abs(xMin-xMax)*0.05;
		if(Errorbars>0)yspace=abs(Errorbars*1.05);
		if(Errorbars==0)yspace=abs(yMin-yMax)*0.05;
		xMin = xMin-xspace-0.4;xMax=xMax+xspace+0.4;yMin=yMin-yspace;yMax=yMax+yspace;
		plotname=plottitle;
		if(plotheight/Atitle.length<14){
			plotheight=Atitle.length*14.2;
		};
		stringlength1=0;
		for(f=0;f<Atitle.length;f++){
			if(lengthOf(Atitle[f])>stringlength1)stringlength1=lengthOf(Atitle[f]);		
		};
		for(l=0;l<2;l++){	
			heightofchar=14/plotheight;
			widthofchar=7/plotwidth;
			begincharheight=1.2*heightofchar;
			stringlength=stringlength1*widthofchar;
			textlength=stringlength+10*widthofchar;
			textwidth=1-textlength;
			timeswider=textlength+1+widthofchar;
			if(l==0)xMax=xMax*timeswider;
			linewidth=0.05*xMaxorig;
			if(l==0){
				plotwidthnew=timeswider*plotwidth;
				plotwidth=plotwidthnew;
			};
		};
		Plot.create(plotname, xaxis, yaxis);
		Plot.setFrameSize(plotwidth, plotheight);
		Plot.setLimits(xMin, xMax, yMin, yMax);
		Plot.setColor("black");
		Plot.drawLine(xMinorig-0.45, 0, xMaxorig+0.45, 0);
		for(i=0;i<xValues.length;i++){
			if(i==0)barwidth=abs((xValues[i+1]-xValues[i]))*0.75;
			if(i>0&&i<xValues.length-2){
				barwidth1=abs(xValues[i+1]-xValues[i]);
				barwidth2=abs(xValues[i]-xValues[i-1]);
				if(barwidth1>=barwidth2)barwidth=barwidth2*0.75;
				if(barwidth2>barwidth1)barwidth=barwidth1*0.75;	
			};
			if(i==xValues.length-1)barwidth=abs((xValues[i]-xValues[i-1]))*0.75;
			drawbar(xValues[i],yValues[i],ASD[i],barwidth);	
		};
		Plot.setColor("black");
		setJustification("right");
		for(i=1;i<=Atitle.length;i++){
			ii=i-1;
			Plot.addText("No: "+i+" - "+Atitle[ii], 1-0.5*widthofchar, begincharheight+(ii*heightofchar));
		};
		setJustification("center");
		Plot.addText(plotname, 0.5, 0);
		Plot.setColor("black");
		Plot.setLineWidth(1);
		setJustification("right");
		Plot.addText(origtitles, 1, 1+2.5*heightofchar);
		setJustification("left");
		Plot.addText(shortnotice, 0, 0);
		if(maxseriesnumber>1){
			setJustification("left");
			Plot.addText(origtitle2, 0, 1+2.5*heightofchar);			
		};
		Plot.setColor("gray");
		Plot.show();
		fullpath=dir_save+plotname+".tif";
		if(List.get("saveanalysis"))saveAs("Tiff", fullpath);
		//run("Profile Plot Options...", "width="+plotwidth+" height="+plotheight+" minimum=0 maximum=0 interpolate draw");
		function drawbar(x,y,yerr,barwidth){
			Plot.setColor("lightgray");
			Plot.setLineWidth(1);
			//barwidth=0.75;
			rep=500;
			for(i=0;i<rep;i++){
				add=(barwidth/rep)*i;
				Plot.drawLine(x-barwidth/2+add, 0, x-barwidth/2+add, y);	
			};
			Plot.setColor("darkgray");
			Plot.drawLine(x-barwidth/2, 0, x-barwidth/2, y);
			Plot.drawLine(x+barwidth/2, 0, x+barwidth/2, y);
			Plot.drawLine(x-barwidth/2, 0, x+barwidth/2, 0);
			Plot.drawLine(x-barwidth/2, y, x+barwidth/2, y);
			Plot.setColor("black");
			Plot.setLineWidth(1);
			Plot.drawLine(x, y-yerr/2, x, y+yerr/2);
			Plot.drawLine(x-barwidth/3, y-yerr/2, x+barwidth/3, y-yerr/2);
			Plot.drawLine(x-barwidth/3, y+yerr/2, x+barwidth/3, y+yerr/2);
		};
	};
};
function Plot2RArray(Atitle,xValues,yValues1,ASD1,stringy1,yValues2,ASD2,stringy2,plottitle,xaxis,yaxis,origtitles,dir_saveorig){
	if(xValues.length>1&&xValues.length<200){
		Alimits=removeNaN(xValues);
		Array.getStatistics(Alimits, xMin, xMax, mean, stdDev);
		nullarray=newArray(0,0);
		Alimits=Array.concat(yValues1,yValues2,ASD1,ASD2,nullarray);
		Alimits=removeNaN(Alimits);
		Array.getStatistics(Alimits, yMin, yMax, mean, stdDev);
		Alimits=Array.concat(ASD1,ASD2);
		Alimits=removeNaN(Alimits);
		Array.getStatistics(Alimits, min, Errorbars, mean, stdDev);
		xMaxorig=xMax;
		xMinorig=xMin;
		xspace=abs(xMin-xMax)*0.05;
		Bars=Errorbars>0;
		if(Bars)yspace=abs(Errorbars*1.05);
		if(!Bars)yspace=abs(yMin-yMax)*0.05;
		xMin = xMin-xspace-0.4;xMax=xMax+xspace+0.4;yMin=yMin-yspace;yMax=yMax+yspace;
		plotname=plottitle;
		if(plotheight/Atitle.length<14){
			plotheight=(Atitle.length+2)*14.2;
		};
		stringlength1=0;
		for(f=0;f<Atitle.length;f++){
			if(lengthOf(Atitle[f])>stringlength1)stringlength1=lengthOf(Atitle[f]);		
		};
		if(lengthOf(stringy1)>stringlength1)stringlength1=lengthOf(stringy1);
		if(lengthOf(stringy2)>stringlength1)stringlength1=lengthOf(stringy2);	
		for(l=0;l<2;l++){	
			heightofchar=14/plotheight;
			widthofchar=7/plotwidth;
			begincharheight=1.2*heightofchar;
			stringlength=stringlength1*widthofchar;
			textlength=stringlength+10*widthofchar;
			textwidth=1-textlength;
			timeswider=textlength+1+widthofchar;
			if(l==0)xMax=xMax*timeswider;
			linewidth=0.05*xMaxorig;
			if(l==0){
				plotwidthnew=timeswider*plotwidth;
				plotwidth=plotwidthnew;
			};
		};
		Plot.create(plotname, xaxis, yaxis);
		Plot.setFrameSize(plotwidth, plotheight);
		Plot.setLimits(xMin, xMax, yMin, yMax);
		Plot.setColor("black");
		Plot.drawLine(xMinorig-0.45, 0, xMaxorig+0.45, 0);
		widthfraction=0.8;
		for(i=0;i<xValues.length;i++){
			if(i==0)barwidth=abs((xValues[i+1]-xValues[i]))*widthfraction;
			if(i>0&&i<xValues.length-2){
				barwidth1=abs(xValues[i+1]-xValues[i]);
				barwidth2=abs(xValues[i]-xValues[i-1]);
				if(barwidth1>=barwidth2)barwidth=barwidth2*widthfraction;
				if(barwidth2>barwidth1)barwidth=barwidth1*widthfraction;	
			};
			if(i==xValues.length-1)barwidth=abs((xValues[i]-xValues[i-1]))*widthfraction;
			draw2bars(xValues[i],yValues1[i],ASD1[i],yValues2[i],ASD2[i],barwidth);	
		};
	//plot stringy1
		Plot.setColor("darkgray");
		setJustification("right");
		Plot.addText(""+fromCharCode(9472,9472),1-stringlength-widthofchar,begincharheight+((1-1)*heightofchar));
		Plot.setColor("black");
		Plot.addText(stringy1, 1-0.5*widthofchar, begincharheight+((1-1)*heightofchar));
	//plot stringy2
		Plot.setColor("red");
		setJustification("right");
		Plot.addText(""+fromCharCode(9472,9472),1-stringlength-widthofchar,begincharheight+((2-1)*heightofchar));
		Plot.setColor("black");
		Plot.addText(stringy2, 1-0.5*widthofchar, begincharheight+((2-1)*heightofchar));
		for(i=1;i<=Atitle.length;i++){
			ii=i-1;
			iii=i+2-1;
			Plot.addText("Exp No: "+i+" - "+Atitle[ii], 1-0.5*widthofchar, begincharheight+(iii*heightofchar));
		};
		setJustification("center");
		Plot.addText(plotname, 0.5, 0);
		Plot.setColor("black");
		Plot.setLineWidth(1);
		setJustification("right");
		Plot.addText(origtitles, 1, 1+2.5*heightofchar);
		setJustification("left");
		Plot.addText(shortnotice, 0, 0);
		if(maxseriesnumber>1){
			setJustification("left");
			Plot.addText(origtitle2, 0, 1+2.5*heightofchar);			
		};
		Plot.setColor("gray");
		Plot.show();
		fullpath=dir_saveorig+plotname+".tif";
		if(List.get("saveanalysis"))saveAs("Tiff", fullpath);
		//run("Profile Plot Options...", "width="+plotwidth+" height="+plotheight+" minimum=0 maximum=0 interpolate draw");
		function draw2bars(x,y1,yerr1,y2,yerr2,barwidth){
			Plot.setLineWidth(1);
			rep=500; 
			x1=x-barwidth/4;
			x2=x+barwidth/4;
			barwidthorig=barwidth;
			barwidth=barwidth/2.5;
			
			Plot.setColor("lightgray");
		//Bar 1
			Plot.setColor("lightgray");
			for(i=0;i<rep;i++){
				add=(barwidth/rep)*i;
				Plot.drawLine(x1-barwidth/2+add, 0, x1-barwidth/2+add, y1);	
			};
			Plot.setColor("darkgray");
			Plot.drawLine(x1-barwidth/2, 0, x1-barwidth/2, y1);
			Plot.drawLine(x1+barwidth/2, 0, x1+barwidth/2, y1);
			Plot.drawLine(x1-barwidth/2, 0, x1+barwidth/2, 0);
			Plot.drawLine(x1-barwidth/2, y1, x1+barwidth/2, y1);
			Plot.setColor("black");
			Plot.setLineWidth(1);
			Plot.drawLine(x1, y1-yerr1/2, x1, y1+yerr1/2);
			Plot.drawLine(x1-barwidth/3, y1-yerr1/2, x1+barwidth/3, y1-yerr1/2);
			Plot.drawLine(x1-barwidth/3, y1+yerr1/2, x1+barwidth/3, y1+yerr1/2);
		//Bar 2
			Plot.setColor("pink");
			for(i=0;i<rep;i++){
				add=(barwidth/rep)*i;
				Plot.drawLine(x2-barwidth/2+add, 0, x2-barwidth/2+add, y2);	
			};
			Plot.setColor("red");
			Plot.drawLine(x2-barwidth/2, 0, x2-barwidth/2, y2);
			Plot.drawLine(x2+barwidth/2, 0, x2+barwidth/2, y2);
			Plot.drawLine(x2-barwidth/2, 0, x2+barwidth/2, 0);
			Plot.drawLine(x2-barwidth/2, y2, x2+barwidth/2, y2);
			Plot.setColor("black");
			Plot.setLineWidth(1);
			Plot.drawLine(x2, y2-yerr2/2, x2, y2+yerr2/2);
			Plot.drawLine(x2-barwidth/3, y2-yerr2/2, x2+barwidth/3, y2-yerr2/2);
			Plot.drawLine(x2-barwidth/3, y2+yerr2/2, x2+barwidth/3, y2+yerr2/2);
		};
	};
};
function print_in_results(columnname,array){
	if(calMean(array)!=0){
		rows=array.length;
		for(i=0;i<rows;i++){
			setResult (columnname,i,array[i]);
		};
		updateResults();
	};		
};
function print_in_results_nocheck(columnname,array){
	rows=array.length;
	for(i=0;i<rows;i++){
		setResult (columnname,i,array[i]);
	};
	updateResults();	
};
function saveresults(name,dir_save){
	selectWindow("Results");
	fullpath=dir_save+name+".xls";	
	saveAs("Results", fullpath);
};
function getfromResults(columname,rows){
	Avalues=newArray(rows);
	Array.fill(Avalues,NaN);
	if(rows<=nResults){
		for (y =0; y < rows; y++){
			Avalues[y] = getResult(columname, y);
		};
	};
	return Avalues;
};
function multimeasureresultsplot(channel,plotname,yaxis,dir_save,Atime,channelno){//AallROIs
	if(isOpen(channel)){
		run("Clear Results");
		selectWindow(channel);
		wait(100);
		frames=nSlices;
		setmeasure="mean";
		for(i=0;i<Ameasure.length;i++){
			if(List.get("Measure")==Ameasure[i])setmeasure=Asetmeasure[i];
		};
		setmeasureString=get_SetMeasurementString();
		run("Set Measurements...", ""+setmeasureString+" standard stack redirect=["+channel+"] decimal=3");
		//run("Set Measurements...", "area "+setmeasure+" standard redirect=["+channel+"] decimal=3");
		roiManager("Deselect");
		roiManager("Multi Measure");
		amountrois=roiManager("count");
		ROItraces=newArray(frames*amountrois); 
		for(c = 1; c <= amountrois; c++){
			ROIno=c-1;
			value=""+List.get("Measure")+c;
			SD="StdDev"+c;
			AROI=getfromResults(value,frames);
			AROISD=getfromResults(SD,frames);
			AnormROI=normalizebaseline(AROI,getmeantonormalize(AROI,List.get("Stimulusafterframe")));
			AnormROISD=normalizebaseline(AROISD,getmeantonormalize(AROI,List.get("Stimulusafterframe")));
			if(List.get("saveRfile"))write_in_resultstring(channel,AROI,c,AnormROI,frames);
			if(channelno<=Atoanal.length){
				for(slice=0;slice<frames;slice++){
					AallROIs[slice+ROIno*frames+channelno*amountrois*frames]=AROI[slice];	
					AnormallROIs[slice+ROIno*frames+channelno*amountrois*frames]=AnormROI[slice];	
					AallROIsSD[slice+ROIno*frames+channelno*amountrois*frames]=AROISD[slice];
					AnormallROIsSD[slice+ROIno*frames+channelno*amountrois*frames]=AnormROISD[slice];
				};	
			};
			for(slice=0;slice<frames;slice++){
				ROItraces[slice+ROIno*frames]=AROI[slice];	
			};
		};
		ROInames=newArray(amountrois);
		AanalROIs=newArray(amountrois);
		for(i=0;i<amountrois;i++){
			ROI=i+1;
			ROInames[i]="ROI "+ROI;	
			AanalROIs[i]=i;
		};
		if(List.get("pMM")&&List.get("saveanalysis")){
			do_norm=false;
			ROItracesSD=newArray(ROItraces.length);
			PlotmultipleArrays(Atime,ROItraces,ROItracesSD,ROInames,AanalROIs,plotname,"Time [s]",yaxis,List.get("origtitle"),dir_save,do_norm);				
		};
		selectWindow("Results");
		fullpath=dir_save+"Table-"+plotname+".xls";
		if(List.get("saveanalysis"))saveAs("Results", fullpath);
		run("Clear Results");
		if(List.get("CellClassification")&&List.get("saveanalysis")){//asdf
			Aclasses2=Array.concat("not classified",Aclasses);
			Aanalclasses=newArray(Aclasses2.length);
			AmeanclassROI=newArray(frames*Aclasses2.length);
			ASDEclassROI=newArray(frames*Aclasses2.length);
			ASDclassROI=newArray(frames*Aclasses2.length);
			print_in_results("Slice",ASlice);
			print_in_results("Time [s]",Atime);
			for(class=0;class<Aclasses2.length;class++){
				Aanalclasses[class]=class;
				classNo=0;
				for(slice=0;slice<frames;slice++){
					Aclassvalues=newArray();
					for(ROIno=0;ROIno<amountrois;ROIno++){
						if(AclassROIs[ROIno]==Aclasses2[class]){
							Aclassvalues=Array.concat(Aclassvalues,ROItraces[slice+ROIno*frames]);
							if(slice==0)classNo++;
						};
					};
					AmeanclassROI[slice+class*frames]=calMean(Aclassvalues);
					ASDEclassROI[slice+class*frames]=calSDE(Aclassvalues);
					ASDclassROI[slice+class*frames]=calSD(Aclassvalues);
				};
				Aclasses2[class]=""+Aclasses2[class]+" - "+classNo+" ROIs";
				print_in_results("Mean "+Aclasses2[class],extract_array2(AmeanclassROI,class,frames));
				print_in_results("SD "+Aclasses2[class],extract_array2(ASDclassROI,class,frames));
				print_in_results("SDE "+Aclasses2[class],extract_array2(ASDEclassROI,class,frames));
			};
			PlotmultipleArrays(Atime,AmeanclassROI,ASDEclassROI,Aclasses2,Aanalclasses,"Plot - Mean of classified "+yaxis+" "+fromCharCode(177)+" SDE","Time [s]",yaxis,List.get("origtitle"),dir_save,false);		
			selectWindow("Results");
			fullpath=dir_save+"Table - classified "+yaxis+".xls";
			if(List.get("saveanalysis"))saveAs("Results", fullpath);
			run("Clear Results");
		};
	};
};
function maxseriesnamereturn(importpath,chnumber){
	run("Bio-Formats Macro Extensions");
	Ext.setId(importpath);
	Ext.getSeriesCount(seriesCount);
	Ext.getCurrentFile(filename);
	indexpoint=lastIndexOf(filename, ".");
	filetype=substring(filename, indexpoint);
	filetype=toLowerCase(filetype);
	indexpoint=lastIndexOf(filename, File.separator);
	filename=substring(filename,indexpoint+1);
	filetype=replace(filetype, "[.]", "");
	filetype="[.]"+filetype;
	openimages=newArray(seriesCount);
	Aseriesnamearray=newArray(seriesCount);
	if(List.get("seriesgrouping")){
		Awindowstitlearray=newArray(seriesCount);
	};
	for(i=0;i<seriesCount;i++){
		Ext.setSeries(i);
		Ext.getSeriesName(seriesName);
		Ext.getSizeT(frames);
		Ext.getSizeZ(slices);
		Ext.getSizeC(channels);
		if(List.get("import")==2){
			if(List.get("Swapdimensions")){
				intermediate=frames;
				frames=slices;
				slices=intermediate;
			};
		};
		if(Exptype==1){
        		if(channels==chnumber&&frames>1){
        			windowstitle=seriesName;
        			if(List.get("seriesgrouping")){
        				windowstitleorig=windowstitle;
        			};
        			if(lengthOf(filename)<lengthOf(windowstitle)){
        				windowstitle = replace_string(windowstitle, filename, "");
        			};
        			if(lengthOf(filename)>lengthOf(windowstitle)){
        				windowstitle = replace_string(windowstitle, filetype, "");
        			};
        			windowstitle = replace(windowstitle, filetype, "");
				windowstitle = checkforcertainchar(windowstitle);
				/*if(lengthOf(replace(windowstitle, "Series "+(i+1), ""))<=3){
					if(openi>1){
						if(indexOf("Series "+(i+1),replace(getTitle(), filetype, ""))<0)windowstitle=""+replace(replace(getTitle(), filetype, ""), "Series "+(i+1), "")+" Series "+(i+1);
						if(indexOf("Series "+(i+1),replace(getTitle(), filetype, ""))>=0)windowstitle=""+replace(getTitle(), filetype, "");
					};
					if(openi==1){
						windowstitle = replace(getTitle(), filetype, "");		
					};
				};*/
				Aseriesnamearray[i]=windowstitle;
				if(List.get("seriesgrouping")){
					Awindowstitlearray[i]=windowstitleorig;
				};
			};
        	};
        	if(Exptype==0){
        		if(channels==chnumber){
        			windowstitle=seriesName;
        			windowstitleorig=windowstitle;
        			if(lengthOf(filename)<lengthOf(windowstitle)){
        				windowstitle = replace_string(windowstitle, filename, "");
        			};
        			if(lengthOf(filename)>lengthOf(windowstitle)){
        				windowstitle = replace_string(windowstitle, filetype, "");
        			};
        			windowstitle = replace(windowstitle, filetype, "");
        			windowstitle = checkforcertainchar(windowstitle);
        			/*if(lengthOf(replace(windowstitle, "Series "+(i+1), ""))<=3){
						if(openi>1){
							if(indexOf("Series "+(i+1),replace(getTitle(), filetype, ""))<0)windowstitle=""+replace(replace(getTitle(), filetype, ""), "Series "+(i+1), "")+" Series "+(i+1);
							if(indexOf("Series "+(i+1),replace(getTitle(), filetype, ""))>=0)windowstitle=""+replace(getTitle(), filetype, "");
						};
						if(openi==1){
							windowstitle = replace(getTitle(), filetype, "");		
						};
					};*/
				Aseriesnamearray[i]=windowstitle;
				if(List.get("seriesgrouping")){
					Awindowstitlearray[i]=windowstitleorig;
				};
			};
		};
	};
	Ext.close();
        return Aseriesnamearray;
};
function maxseriesnoreturn(Aseriesname){
	counter=0;
	for(i=0;i<Aseriesname.length;i++){
		if(Aseriesname[i]!=0)counter++;
	};
	Aseriesno=newArray(counter);
	counter=0;
	for(i=0;i<Aseriesname.length;i++){
		if(Aseriesname[i]!=0){
			Aseriesno[counter]=i+1;
			counter++;
		};
	};
	return Aseriesno;
};
function removeNaN(aA){
	c=0;
	aA=Array.concat(aA);
	while(c<aA.length){
		if(isNaN(aA[c])){
			bA=Array.slice(aA,0,c);
			cA=Array.slice(aA,c+1,aA.length);
			aA=Array.concat(bA,cA);			
		}else c++;
	};
	return aA;
};
function delzerofromarray(array){
	counter=0;
	array=Array.concat(array);
	while(counter<array.length){
		if(array[counter]==0){
			aarray=Array.slice(array,0,counter);
			barray=Array.slice(array,counter+1,array.length);
			array=Array.concat(aarray,barray);	
		}else counter++;
	};
	return array;
};
function signalreachplot(channel,signal,plotname,spf,Stimulusafterframe,Equilibrationtime,stopafterframe,ROIsfullpath){
	selectWindow(channel);
	wait(100);
	run("Clear Results");
	IDorig=getImageID();
	signalreachchannel="Development of "+signal+"-signal channel";
	run("Select None");
	run("Duplicate...", "title=["+signalreachchannel+"] duplicate range=1-["+stopafterframe+"]");
	run("32-bit");
	roiManager("Select", 0);
	run("Clear Outside", "stack");	
	resize();
	check=false;
	IDtheo=IDorig-1;
	if(isOpen(IDtheo)){
		selectImage(IDtheo);
		check=true;	
	};
	if(isOpen(signalreachchannel)){
		selectWindow(signalreachchannel);
		wait(100);
		check=true;	
	};
	if(nSlices<Stimulusafterframe)check=false;
	if(check){
		run("Mean...", "radius=1 stack");
		run("Set Measurements...", "area mean standard min redirect=["+signalreachchannel+"] decimal=3");
		roiManager("Select", 0);
		run("Measure");
		totalarea=getResult("Area", 0);	
		roiManager("Deselect");
		run("Z Project...", "start=1 stop=["+Stimulusafterframe+"] projection=Median");
		Before="Baseline";
		run("Rename...", "title=["+Before+"]");
		resize();
		selectWindow(signalreachchannel);
		wait(100);
		imageCalculator("Divide stack", signalreachchannel,Before);
		if(isOpen(Before)){
			selectImage(Before);
			close();
		};
		run("Z Project...", "start=1 stop=["+Stimulusafterframe+"] projection=Median");
		Before="Baseline";
		run("Rename...", "title=["+Before+"]");
		imageCalculator("Subtract stack", signalreachchannel,Before);
		if(isOpen(Before)){
			selectImage(Before);
			close();
		};
		selectWindow(signalreachchannel);
		wait(100);
		frames=nSlices;
		fASlice=newArray(frames);
		fAtime=newArray(frames);
		fAarea=newArray(frames);
		fAnarea=newArray(frames);
		fAmean=newArray(frames);
		fAmeanSD=newArray(frames);
		fASD=newArray(frames);
		maxvalue=get_theor_maxvalue();
		meanv=0;
		maxv=0;
		stdv=0;
		run("Clear Results");
		run("Set Measurements...", "area mean standard min slice redirect=None decimal=3");
		roiManager("Select", 0);
		for(i=0;i<Stimulusafterframe;i++){
			currentslice=i+1;
			setSlice(currentslice);
			roiManager("Measure");
			meanv=getResult("Mean", i)+meanv;
			maxv=getResult("Max",i)+maxv;	
			stdv=getResult("StdDev",i)+stdv;
		};
		setSlice(1);
		meanv=meanv/Stimulusafterframe;
		maxv=maxv/Stimulusafterframe;
		stdv=stdv/Stimulusafterframe;
		minvalue_signalreach=abs(meanv+3*stdv);
		minvalue_signalreach=abs((meanv+0.5*maxv)/2);wait(500);
	//particlesizefinder
		roiManager("reset");
		run("Set Measurements...", "area mean standard min slice redirect=["+signalreachchannel+"] decimal=3");
		getPixelSize(unit, pixelWidth, pixelHeight);
		if(List.get("import")==2)particlesizemin=10;//round(totalarea/pixelWidth*0.05);
		if(List.get("import")!=2)round(totalarea/pixelWidth*0.05);
		minparticlesize_signalreach=particlesizemin;
		run("Clear Results");
		for(i=0; i<frames; i++) {
			currentslice=i+1;
			setSlice(currentslice);
			fASlice[i]=currentslice;
			fAtime[i]=round(fASlice[i]*spf);
			run("Threshold...");
			setThreshold(minvalue_signalreach,maxvalue);	
			run("Analyze Particles...", "size="+particlesizemin+"-Infinity pixel circularity=0.00-1.00 show=Nothing display add clear slice");
			resetThreshold();
			roino=nResults;
			mean=0;
			area=0;
			SD=0;
			for(f=0;f<roino;f++){
				if(roino>0){
					area=getResult("Area", f)+area;	
					mean=(getResult("Mean",f)*getResult("Area", f))+mean;
					SD=getResult("StdDev",f)+SD;
				};
				mean=mean/area;
				narea=area/totalarea;
				SD=SD/roino;
				fAarea[i]=area;
				fAnarea[i]=narea*100;
				fAmean[i]=mean;
				fAmeanSD[i]=SD;
			};
			run("Clear Results");
		};
		setSlice(1);
		run("Clear Results");
		print_in_results("Slice",fASlice);
		print_in_results("Time [s]",fAtime);
		print_in_results("Mean of Signalarea",fAmean);
		print_in_results("Standard deviation",fAmeanSD);
		print_in_results("Area",fAarea);
		print_in_results("Area / cellarea [%]",fAnarea);
		roiManager("reset");
		open(ROIsfullpath);
		amountrois=roiManager("count");
		selectWindow("Results");
		if(List.get("saveanalysis"))saveresults("Table of "+plotname,dir_save);
		PlotArray(fAtime,fAmean,fAmeanSD,"Plot - intensity of relative signal coverage from "+List.get("intensiometric")+"-signal","Time [s]","Relative intensity of "+List.get("intensiometric")+"-signal",plotname,dir_save);
		PlotArray(fAtime,fAnarea,fASD,"Plot - relative signal coverage of "+List.get("intensiometric")+"-signal","Time [s]","Area of "+List.get("intensiometric")+"-signal / cellarea [%]",plotname,dir_save);
		if(isOpen(signalreachchannel)){
			selectWindow(signalreachchannel);
			wait(100);
			timeandscaleadder(signalreachchannel,spf);
			fullpath=dir_save+signalreachchannel+".tif";
			if(List.get("saveanalysis"))saveAs("Tiff", fullpath);
			close();
			
		};
	};
};
function timeandscaleadder(channel,spf){
	selectWindow(channel);
	wait(100);
	getPixelSize(unit, pixelWidth, pixelHeight);
	scalewidth=round(pixelWidth*getWidth()*0.2);
	if(List.get("import")==2)run("Scale Bar...", "width=["+scalewidth+"] height=4 font=12 color=White background=Black location=[Lower Right] bold label");
	for(i=0;i<nSlices;i++){
		currentslice=i+1;
		setSlice(currentslice);
		time=round(i*spf);
		min=floor(time/60);
		sec=time-60*min;
		sec=round(sec);
		times=" "+min+" min"+" "+sec+" sec";
		setColor("white");
		setJustification("left");
		drawString(times, 10, 20,"black");
	};
	setSlice(1);	
};
function correctarray(array,defaults){
	count=0;
	for(i=0;i<array.length;i++){
		if(defaults[i])count++;		
	};
	corrarray=newArray(count);
	count=0;
	for(i=0;i<array.length;i++){
		if(defaults[i]){
			corrarray[count]=array[i];
			count++;		
		};
	};
	return corrarray;
};
function getmaximumpixel(channel){
	selectWindow(channel);
	wait(100);
	if(nSlices==1)getStatistics(area, mean, min, max, std, histogram);
	if(nSlices>1)Stack.getStatistics(voxelCount, mean, min, max, stdDev);
	return max;
};
function deleteallslicesexcept(slice){
	Stack.getDimensions(width, height, channels, slices, frames);	
	x=slice+1;
	for(i=1;i<slice;i++){
		run("Delete Slice", "delete=channel");	
	};
	for(i=x;i<=channels;i++){
		setSlice(2);
		run("Delete Slice", "delete=channel");
	};
};
function deleteallslicesexcept2(slice){
	Stack.getDimensions(width, height, channels, slices, frames);	
	stackID=getImageID();
	setSlice(slice);
	title=getTitle();
	run("Select None");
	run("Duplicate...", "title=["+title+"] channels=1-"+channels+"");
	resize();
	if(isOpen(stackID)){
		selectImage(stackID);	
		close();
		selectWindow(title);
		wait(100);
	};
};
function normalizebaseline(array,mean){
	if(calMean(array)==0||!stimulation)return array;
	if(calMean(array)!=0){
		array2=newArray(array.length);
		for(i=0;i<array.length;i++){
			array2[i]=array[i]/mean;	
		};
		return array2;
	};
};
function getmeantonormalize(array,Stimulusafterframe){
	array=Array.concat(array);
	if(calMean(array)==0||!stimulation||array.length<=Stimulusafterframe){
		return 1;
	};
	if(calMean(array)!=0){
		mean=0;
		for(i=0;i<Stimulusafterframe;i++){
			mean=mean+array[i];		
		};
		mean=abs(mean/Stimulusafterframe);
		return mean;
	};
};
function print_in_results_norm(columnname,array,mean){
	if(calMean(array)!=0){
		for(i=0;i<array.length;i++){
			array[i]=array[i]/mean;	
		};
		rows=array.length;
		for(i=0;i<rows;i++){
			setResult (columnname,i,array[i]);
		};
		updateResults();
	};		
};
function add_errorbars(xValues,yValues,STDev){
	Plot.setColor("darkgray");
	Plot.setLineWidth(1);
	for(i=0;i<xValues.length;i++){
		Plot.drawLine(xValues[i], yValues[i]-(STDev[i]), xValues[i], yValues[i]+(STDev[i]));	
	};
};
function setFIJIsettings(){
	//size of all plots
//Fiji options to make everything equal and avoid mistakes
	run("Set Measurements...", "  mean standard redirect=None decimal=3");
	setOption("BlackBackground", true);
	run("Line Width...", "line=1");
	run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column copy_row save_column save_row");
	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=0 interpolate draw");
	run("Appearance...", "  antialiased menu=14");
	run("Colors...", "foreground=black background=black selection=white");
	run("Conversions...", " ");//run("Conversions...", "scale");
	run("DICOM...", " ");
	run("Misc...", "divide=Infinity run");
	run("Options...", "iterations=1 black count=1");
	setFont("SansSerif", 18, "plain antialiased");
	setForegroundColor(0,0,0);
	showProgress(0);
	showStatus(macroname);
	scwidth=screenWidth;
	scheight=screenHeight;
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	month=month+1;
	if(month<10)smonth="0"+month;
	if(month>=10)smonth=month;
	if(dayOfMonth<10)sdayOfMonth="0"+dayOfMonth;
	if(dayOfMonth>=10)sdayOfMonth=dayOfMonth;
	timestamp=""+year+""+smonth+""+sdayOfMonth+"_"+hour+"h"+minute+"min";
	timestamp2=""+year+"-"+smonth+"-"+sdayOfMonth+" - "+hour+"h "+minute+"min";
	date=""+year+""+smonth+""+sdayOfMonth;
};
function loadparameter(){
	if(!File.exists(tmp_file)&&!File.exists(tmp_file_dir)){
		tmp_check=false;
	};
	if(File.exists(tmp_file)||File.exists(tmp_file_dir)){
		if(File.exists(tmp_file_dir)){
			macroparameter=File.openAsString(tmp_file_dir);
			forbidden=indexOf(macroparameter, "\\");
			while(indexOf(macroparameter, "\\")>=0){
				forbidden=indexOf(macroparameter, "\\");
				macroparameter_start=substring(macroparameter,0,forbidden);
				macroparameter_end=substring(macroparameter,forbidden+1,lengthOf(macroparameter));
				macroparameter=macroparameter_start+"/"+macroparameter_end;
			};
			List.setList(macroparameter);
		};
		if(File.exists(tmp_file)&&!File.exists(tmp_file_dir)){
			macroparameter=File.openAsString(tmp_file);
			List.setList(macroparameter);
		};
		tmp_check=true;
	};
	if(!tmp_check){
		//From Dialog I
		List.set("AExptypes",AExptype[1]); //0 
		List.set("imports",Aimport[1]); //1
		List.set("maxseriesnumbers",false); //2
		List.set("origtitle",timestamp); //3
		List.set("BMs",ABM[1]); //4
		List.set("mradius",1);//5
		List.set("mradius_transmission",3);
		List.set("Asmothenings_transmission","Variance");
		List.set("thresholdings",Athresholding[0]);//6
		List.set("OpenRois",0);
		List.set("AROIcontrols",AROIcontrol[1]);//7
		List.set("particledetails",true); //8
		List.set("noNaNss",false); //9
		List.set("normalize",false); //10
		//Dialog II
		List.set("processguieachloop",true); //11
		List.set("chnumber",2);
		List.set("filename",Afilelist[0]); //12
		List.set("LOCIimports",ALOCIimport[0]); //13
		List.set("seriesgrouping",false); //15
		List.set("multiseries",true); //16
		List.set("Stimulusafterframe",10); //17
		List.set("Equilibrationtime",0); //18
		List.set("stopafterframe",0); //19
		List.set("FRETcalcchoices",AFRETcalcchoices[2]); // //20
		List.set("Asmothenings",Asmothening[2]); //21
		List.set("chcolor1","Cyan");
		List.set("chtype1",Achanneltype[0]);
		List.set("chtype2",Achanneltype[1]);
		List.set("chtype3",Achanneltype[2]);
		List.set("chtype4",Achanneltype[2]);
		List.set("chtype5",Achanneltype[2]);
		List.set("chcolor2","Yellow");
		List.set("chcolor3","Red");
		List.set("onecellexp",false); //22
		List.set("Fitequations",false); //23
		List.set("containzstack",false); //27
		List.set("RBradius",300); //29
		List.set("particlesize","300"); //30
		List.set("maxparticlesize","100000"); //31
		List.set("mincircularity","0.0"); //32
		List.set("maxcircularity","1.0"); //33
		List.set("excludeoneedges",false); //34
		//From Dialog III
		List.set("filetype",".XXX"); //35
		List.set("donor","CFP"); //36
		List.set("background_1",0); //37
		List.set("background_2",0); //38
		List.set("background_3",0); //39
		List.set("background_4",0); //40
		List.set("background_5",0); //40
		List.set("minvalue",1); //41
		List.set("minvalue_1",10); //42
		List.set("minvalue_2",10); //43
		List.set("minvalue_3",10); //44
		List.set("minvalue_4",10); //45
		List.set("minvalue_5",10); //45
		List.set("acceptor","YFP"); //46
		List.set("checkROIsforNaNs",false); //47
		List.set("thresholdmethod",Athresholdmethods[15]); //52 
		List.set("thresholdmethod_background",Athresholdmethods[8]); //52 
		List.set("series",1); //53
		List.set("AFitequations",AFitequation[11]); //54
		List.set("editnames",true); //55
		List.set("zprojectionmethod",Azprojection[0]); //56
		List.set("segmentationprojection",Aprojection[0]); //56
		List.set("chname1","CFP");
		List.set("chname2","YFP");
		List.set("chname3","R-GECO");
		List.set("chname4","DAPI");
		List.set("save8",true); //59
		List.set("save32",true); //60
		List.set("savemask",true); //64
		List.set("saveFRETratio",true); //65
		List.set("saveanalysis",true); //66
		List.set("savetmp",true); //67
		List.set("ROIstoremember",3); //68
		List.set("pmean",true); //71
		List.set("pmedian",true); //72
		List.set("pocaR",true); //73
		List.set("saveRfile",true); //75
		List.set("pmccor",true); //77
		List.set("spf",1); //81
		List.set("advancedoptions",false);//82
		List.set("cls",true); //83
		List.set("chabbrev","ch0"); //84
		List.set("pMM",true); //89
		List.set("watershed",true);
		List.set("Fill-holes",true);
		List.set("minvalue-voronoi",1);
		List.set("segchno",0);
		List.set("Measure","Mean");
		List.set("radius_trch",5);
		List.set("method_trch","tophat filter");
		List.set("choose_default",true);
		List.set("cadvancedoptions","Show advanced options.");
		List.set("NaN_translocation",0);
		List.set("MeasureTranslocation",0);
		List.set("ComputeSE",0);
		List.set("Parameter_bin","1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0");
	};
};
function saveparameter(){
	if(List.get("savetmp")){
		macroparameter = List.getList();
		forbidden=indexOf(macroparameter, "\\");
		while(indexOf(macroparameter, "\\")>=0){
			forbidden=indexOf(macroparameter, "\\");
			macroparameter_start=substring(macroparameter,0,forbidden);
			macroparameter_end=substring(macroparameter,forbidden+1,lengthOf(macroparameter));
			macroparameter=macroparameter_start+"/"+macroparameter_end;
		};
		File.saveString(macroparameter,tmp_file);
		File.saveString(macroparameter,tmp_file_dir);
	};
};
function getdateoffile(importpath){
	Adate=split(File.dateLastModified(importpath));
	Amonth=newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	Amonthno=newArray("01","02","03","04","05","06","07","08","09","10","11","12");
	for(i=0;i<Amonth.length;i++){
		if(Amonth[i]==Adate[1])month=Amonthno[i];
	};
	date=""+Adate[Adate.length-1]+month+Adate[2];	
	return date;	
};
function main_Dialog(){
	Afilelist = getFileList(dir);
	Aimport=newArray("Import an image sequence.","Use the LOCI Bio-Formats Importer plug-in.","Open manually with File->Open... ");
	ABM=newArray("Subtract a predefined value from each image.","Use built-in 'Subtract background'.","Subtract the mean of an interactively selected ROI.","Subtract the mean of thresholded background.","Do not remove background.");
	Athresholding=newArray("Interactively with ImageJ's built-in threshold window.","Automatically using fixed values.","Automatically using a predefined threshold algorithm (e.g. Otsu).");
	AFRETcalcchoices=newArray("Using difference of mean values.","Using linear fit (to compensate e.g. for bleaching).","Using maximum observed amplitude change (good for transient changes).");
	AExptype=newArray("Single time point.","Time series with stimulation.","Time series without stimulation.");
	ALOCIimport=newArray("File format not listed, type in file extension manually","Leica LCS LEI - *.lei","Nikon NIS-Elements ND2 - *.nd2","Zeiss LSM (Laser Scanning Microscope) 510 - *.lsm","Leica LAS AF LIF (Leica Image File Format) - *.lif","Olympus FluoView FV1000 - *.oib","Olympus FluoView FV1000 - *.oif","Zeiss AxioVision ZVI (Zeiss Vision Image) - *.zvi","Bitplane Imaris - *.ims","Lambert Instruments FLIM - *.fli","TIFF - *.tif","TIFF - *.tiff","AVI - *.avi","Windows Bitmap - *.bmp","Graphics Interchange Format - *.gif","JPEG - *.jpg","Portable Network Graphics - *.png");
	ALOCIfileext=newArray("???",".lei",".nd2",".lsm",".lif",".oib",".oif",".zvi",".ims",".fli",".tif",".tiff",".avi",".bmp",".gif",".jpg",".png");
	Athresholdmethods = getList("threshold.methods");
	Achannelcolor=newArray("Grays","Red","Green","Blue","Cyan","Magenta","Yellow","Fire");
	AFitequation=newArray(Fit.nEquations);
	for (i=0; i<Fit.nEquations; i++) {
		Fit.getEquation(i, name, formula);
		AFitequation[i]=name+" ["+formula+"]";	
	};
	Azprojection=newArray("Use only one plane","Average Intensity","Max Intensity","Min Intensity","Standard Deviation","Median","Sum Slices");
	Aprojection=newArray("Average Intensity","Max Intensity","Min Intensity","Standard Deviation","Median","Sum Slices");
	if(lengthOf(List.get("segmentationprojection"))==0){
		List.set("segmentationprojection","Average Intensity");
	};
	AROIcontrol=newArray("Manually with selection tool.","Semi-automatically with binary mask modification (pencil tool).","Semi-automatically with binary mask modification (voronoi).","Automatically without user interaction.");
	Asmothening=newArray("None","Gaussian Blur","Median","Mean","Minimum","Maximum","Variance");
	Aadvancedoptions=newArray("Modify advanced options.","Show advanced options.","Hide advanced options.");
	loadparameter();//Load all variables that have been used in the last session or set initial parameter
	//1st Dialog
	List.set("origtitle",timestamp);
	dialogdone=false;
	checkD1=true;
	checkD2=false;
	checkD3=false;
	checkD3b=false;
	checkD4=false;
	checkD5=false;
	checkD6=false;
	if(List.get("runbatchmode")=="")List.set("runbatchmode",0);
	while(!dialogdone){
		if(checkD1){
			Dialog.create("Dialog I - "+macroinfo);//help=help+"<tr> <td></td> <td></td> <td></td></tr>";
				help="<html><h2>Help for Dialog I</h2><table border='1'><font size='1'>";
				help=help+"<tr> <th>Menu point</th> <th>Possible options</th> <th>Description</th> </tr>";
			Dialog.addMessage("Define experimental details.");
			Dialog.addChoice("Type of experiment:",AExptype, List.get("AExptypes"));//AExptypes 0
				help=help+"<tr><td rowspan='3'>Type of experiment:</td> <td> Single time point. </td> <td> Explanation </td></tr>";
				help=help+"<tr> <td> Time series with stimulation. </td> <td>To be chosen if image data set contains multiple time points including stimulation after certain number of frames <br>(e.g. addition of compound). FluoQ will calculate the response to the stimulus (specified in Dialog II). </td></tr>";
				help=help+"<tr> <td> Time series without stimulation. </td> <td> To be chosen if image data set contains multiple time points. No response (amplitude changes) will be calculated. </td></tr>";
			Dialog.addChoice("Data import procedure:", Aimport, List.get("imports")); //imports 1
				help=help+"<tr><td rowspan='3'>Data import procedure:</td> <td> Import an image sequence. </td> <td> FluoQ makes use of ImagesJ’s File -> Import -> Import Image Sequence… menu <br> in order to load imaging data during the workflow.  </td></tr>";
				help=help+"<tr> <td> Use the LOCI Bio-Formats Impporter plug-in. </td> <td> FluoQ makes use of the LOCI Bio-Formats Importer plug-in to load image data. <br>Therefore, the plug-in needs to be installed. </td></tr>";
				help=help+"<tr> <td> Open manually with File->Open.... </td> <td> FluoQ asks the user to manually choose the files in the course of the analysis. (No batchmode possible.) </td></tr>";
			Dialog.addCheckbox("Analyze multiple files (including subfolders).",List.get("maxseriesnumbers"));//11 maxseriesnumbers
				help=help+"<tr> <td> Analyze multiple files (including subfolders). </td> <td> Tick box </td> <td> This tick box decides, whether FluoQ enters batch-mode. In batch-mode, <br>the macro looks in any subfolder of the working directory for experiments that can be loaded and analyzed in a row. <br>If not ticked, user will be asked to choose a file from the working directory (Dialog II). </td> </tr>";
			Dialog.addString("Name of experiment (no special characters):", List.get("origtitle")); //2 origtitle
				help=help+"<tr> <td>Name of experiment <br>(no special characters):</td> <td>Enter experiment name</td> <td>The experiment name will appear on every plot and determines the result folder name. <br>The name should not contain any special characters to avoid mistakes during file savings.</td></tr>";
			Dialog.addMessage("Details for image processing. (Quantification is based on processed images.)");
			Dialog.addChoice("Background subtraction method:",ABM,List.get("BMs")); //7 Background subtraction method BMs
				help=help+"<tr><td rowspan='5'>Background subtraction method:</td> <td> Subtract a fixed value. </td> <td> A predefined value will be subtracted from each image. <br>A separate value for each channel has to be chosen in Dialog IV. </td></tr>";
				help=help+"<tr> <td>Use built-in ‘Subtract background’.</td> <td>ImageJ’s Process->Subtract Background… menu is used to subtract the background of each image. <br>The radius size, that is necessary for this plug-in, can be entered in Dialog IV.</td></tr>";
				help=help+"<tr> <td>Subtract the mean of an interactively selected ROI.</td> <td>The mean intensity of a user selected ROI is used to subtract the specific background of every image in a stack. <br>This option is very suitable if the background changes upon addition of a solution.</td></tr>";
				help=help+"<tr> <td>Subtract the mean of thresholded background.</td> <td>For each image, the background is estimated by a defined thresholding method. <br>The mean of this background is then subtracted from each image. <br>The thresholding method can be defined in Dialog IV.</td></tr>";
				help=help+"<tr> <td>Do not remove background.</td> <td>No background will be subtracted.</td></tr>";
			Dialog.addChoice("Noise reduction/smoothing method:",Asmothening,List.get("Asmothenings"));
				help=help+"<tr> <td rowspan='7'>Noise reduction/smoothing method:</td> <td>None</td> <td>Images won't be smoothed.</td></tr>";
				help=help+"<tr> <td>Gaussian Blur</td> <td rowspan='6'>FluoQ makes use of smoothing filters of ImagesJ’s Process->Filter->… to reduce noise or to smooth images.</td> </tr>";
				help=help+"<tr> <td>Median</td> </tr>";
				help=help+"<tr> <td>Mean</td> </tr>";
				help=help+"<tr> <td>Minimum</td> </tr>";
				help=help+"<tr> <td>Maximum</td> </tr>";
				help=help+"<tr> <td>Variance</td> </tr>";
			Dialog.addChoice("Threshold method (to exclude low value pixels):",Athresholding,List.get("thresholdings"));//10 thresholdings
				help=help+"<tr> <td rowspan='3'>Threshold method (to exclude low value pixels):</td> <td>Interactively with ImageJ’s <br>builtin threshold window.</td> <td rowspan='3'>FluoQ applies a threshold to all pixel values <br>to remove low value pixels and set them ‘NaN’ (Not a number) – from ImageJ’s Process->Math->NaN Background menu. <br>This removes them from the analysis. Finding the lower threshold can be done with three options. Either  <br>(i) interactively during the analysis while thresholding the images manually,  <br>(ii) automatically with fixed values(values can be given in Dialog IV) or <br>(iii) with a threshold algorithm (from Image->Adjust- >Threshold… menu)</td></tr>";
				help=help+"<tr> <td>Automatically using fixed values.</td> </tr>";
				help=help+"<tr> <td>Automatically using a predefined threshold algorithm (e.g. Otsu).</td> </tr>";
			Dialog.addChoice("ROI segmentation procedure (Regions of interest):",AROIcontrol,List.get("AROIcontrols"));
				help=help+"<tr> <td rowspan='3'>ROI segmentation procedure (Regions of interest):</td> <td>Manually with selection tool.</td> <td>Cells/ROIs have to be selected manually during the analysis <br>with the help of the many selection tools from ImageJ. <br>Selected ROIs have to be added to the ROI manager (shortcut ‘t’).</td></tr>";
				help=help+"<tr> <td>Semi-automatically with binary mask modification (pencil tool).</td> <td>FluoQ generates a binary mask (black and white image) by thresholding the timeprojection <br>(see Supplementary Figure 1) of a preselected imaging channel (Dialog IV). This binary mask can be <br>manipulated by the user during the analysis (e.g. by separating cells manually with the ‘Pencil Tool’). <br>The resulting binary mask is used to identify ROIs with the particle analyzer plug-in from ImageJ’s <br>Analyze->Analyze Particles… menu. Details for the particle analyzer can be adjusted in Dialog IV if <br>‘Define specific details for Cell Segmentation’ was selected in Dialog II.</td></tr>";
				help=help+"<tr> <td>Automatically without user interaction.</td> <td>FluoQ generates the binary mask as described under ‘Semi-automatically’, but the user has no option to manipulate it.</td></tr>";
			Dialog.addCheckbox("Show advanced options (If not ticked, recommended or presaved settings will be chosen).",List.get("advancedoptions"));//advancedoptions
				help=help+"<tr> <td>Show advanced options (If not ticked, recommended or presaved settings will be chosen).</td> <td>Tick box</td> <td>If not ticked, FluoQ will only show limited number of options in the following dialogs and the advanced options <br>are loaded from the last use.</td></tr>";
			Dialog.addCheckbox("Run FluoQ in BatchMode.",List.get("runbatchmode"));//advancedoptions
				help=help+"<tr> <td>Run FluoQ in BatchMode.</td> <td>Tick box</td> <td>If ticked, FluoQ won't display images on the screen (only if necessary) in order to work faster.</td></tr>";
			//Dialog.addCheckbox("Normalize your images? Pixels get values between 0 and 1 (e.g. to compare 8-bit with 16-bit images).",normalize); //13 normalize
		/////////////// 
				help=help+"</font></table>";
			Dialog.addHelp(help);
			Dialog.show();
			List.set("AExptypes",Dialog.getChoice());
			List.set("imports",Dialog.getChoice()); //1
			List.set("maxseriesnumbers",Dialog.getCheckbox());
			List.set("origtitle",Dialog.getString()); //2 origtitle
			List.set("BMs",Dialog.getChoice()); //7
			List.set("Asmothenings",Dialog.getChoice());
			List.set("thresholdings",Dialog.getChoice()); //10
			List.set("AROIcontrols",Dialog.getChoice());
			List.set("advancedoptions",Dialog.getCheckbox());
			List.set("runbatchmode",Dialog.getCheckbox());
			checkD1=false;
			checkD2=true;
		};	
			if(List.get("noNaNss"))List.set("noNaNs",2);
			if(!List.get("noNaNss"))List.set("noNaNs",1);
			origtitle2=List.get("origtitle");
			dirorig=dir;
			//----------------------------------------------------
		//ROI selection
			if(List.get("AROIcontrols")==AROIcontrol[0]){
				List.set("createROIsman",true);	
				List.set("checkROIs_bin",false);
				List.set("checkROIs",true);
				List.set("checkROIs_mark",false);		
			};
			if(List.get("AROIcontrols")==AROIcontrol[1]){
				List.set("createROIsman",false);	
				List.set("checkROIs",true);
				List.set("checkROIs_bin",true);
				List.set("checkROIs_mark",false);		
			};
			if(List.get("AROIcontrols")==AROIcontrol[2]){
				List.set("createROIsman",false);
				List.set("checkROIs_bin",false);	
				List.set("checkROIs",true);
				List.set("checkROIs_mark",true);		
			};
			if(List.get("AROIcontrols")==AROIcontrol[3]){
				List.set("createROIsman",false);	
				List.set("checkROIs",false);
				List.set("checkROIs_bin",false);
				List.set("checkROIs_mark",false);				
			};
		//import
			if(List.get("AExptypes")==AExptype[0]){
				Exptype=0;//Fixed cells
				stimulation=false;
			};
			if(List.get("AExptypes")==AExptype[1]){//Time experiment with stimulation
				Exptype=1;
				stimulation=true;
			};
			if(List.get("AExptypes")==AExptype[2]){//Time experiment without stimulation 
				Exptype=1;
				stimulation=false;		
			};
			if(!stimulation)norm="";
			if(stimulation)norm="Norm.";
			if(List.get("imports")==Aimport[0]){List.set("import",1);}; //Images exist in subfolder
			if(List.get("imports")==Aimport[1]){List.set("import",2);}; //LOCI Bioformat importer - all pictures in subfolder
			if(List.get("imports")==Aimport[2]){List.set("import",3);}; //Open pictures or stack with command open();
			if(List.get("import")==3)List.set("maxseriesnumbers",false);
		//BM Background subtraction method
			if(List.get("BMs")==ABM[0]){List.set("BM",1);}; //Fixed value
			if(List.get("BMs")==ABM[1]){List.set("BM",2);}; //Rolling ball
			if(List.get("BMs")==ABM[2]){List.set("BM",3);}; //Manually selected background ROI
			if(List.get("BMs")==ABM[3]){List.set("BM",5);}; //Measure tresholded background pixel
			if(List.get("BMs")==ABM[4]){List.set("BM",6);}; //No background subtraction
			if(List.get("BM")==3){
				if(Exptype==1)List.set("BM",4);	//Subtract mean of a ROI in each frame
			};
			//thresholding
			if(List.get("thresholdings")==Athresholding[0]){List.set("thresholding",1);};
			if(List.get("thresholdings")==Athresholding[1]){List.set("thresholding",2);};
			if(List.get("thresholdings")==Athresholding[2]){List.set("thresholding",3);};
			if(List.get("import")==2)List.set("multiseries",true);//&&Exptype==1
			//if(List.get("seriesgrouping"))List.set("multiseries",false);
		//------------------------------------------------
	//2nd Dialog
		//------------------------------------------------
		if(checkD2){
			Dialog.create("Dialog II - "+macroinfo);
				help="<html><h2>Help for Dialog I</h2><table border='1'><font size='1'>";
				help=help+"<tr> <th>Menu point</th> <th>Possible options</th> <th>Description</th> </tr>";
			if(List.get("import")==2){
				Dialog.addMessage("Details for Bio-Formats importer plug-in.");
			};
			if(List.get("import")==2&&!List.get("maxseriesnumbers")){
				Dialog.addChoice("Choose file to analyze.",Afilelist,List.get("filename"));//filename 0		
			};
			if(List.get("import")==2&&List.get("maxseriesnumbers")){
				Dialog.addChoice("Choose file extension.",ALOCIimport,List.get("LOCIimports"));//LOCIimports 
			};
			if(List.get("import")==2){
				Dialog.addCheckbox("Extract ROIs from image files.",parseFloat(List.get("OpenRois")));
			};
			if(List.get("import")==2&&List.get("advancedoptions")){
				Dialog.addCheckbox("Swap slice and frame dimensions. Only use if dimensions are switched in the experiment.",parseFloat(List.get("Swapdimensions")));
			};
			if(List.get("import")==2&&Exptype==0){
				Dialog.addCheckbox("File contains more than one series with the same experimental conditions. Group all into one stack.",List.get("seriesgrouping"));//seriesgrouping
			};
			if(Exptype==1){//Details for timelapse experiments
				Dialog.addMessage("Details for time series analysis.");
				Dialog.addNumber("Time per frame? [s]",List.get("spf"));//6c spf
				if(stimulation){
					Dialog.addNumber("After how many frames did you stimulate your cells? (How many frames belong to baseline?)",parseFloat(List.get("Stimulusafterframe")));//6b Stimulusafterframe
				};
				if(stimulation&&List.get("advancedoptions")){
					Dialog.addNumber("Analysis should begin how many frames after the start of your stimulation?",List.get("Equilibrationtime")); //6b2 Equilibrationtime
				};
				if(stimulation&&List.get("advancedoptions")){
					Dialog.addNumber("Stop analysis after frame (type zero if analysis should not stop before the last frame):",parseFloat(List.get("stopafterframe"))); //stopafterframe
				};
				if(stimulation&&List.get("advancedoptions")){
					Dialog.addChoice("How do you want to calculate your amplitude changes?",AFRETcalcchoices,List.get("FRETcalcchoices")); // FRETcalcchoices
				};
				Dialog.addCheckbox("Only one cell in an image. (Allows individual analysis of independent ROIs - good for bleaching or uncaging experiments).",List.get("onecellexp"));//onecellexp
				if(stimulation&&List.get("advancedoptions")){
					Dialog.addCheckbox("Do curve fitting for your stimulus response. Choose the fitting method in the next step.",List.get("Fitequations")); //Fitequations
				};
			};
			Dialog.addMessage("Details for your data set:")
			Dialog.addNumber("Data set contains the following number of imaging channels:",parseFloat(List.get("chnumber")));
			if(List.get("advancedoptions")){
				Dialog.addCheckbox("Data set can contain a Z-stack. Choose the Z-projection method in the next step.",List.get("containzstack"));
			};
			if((List.get("AROIcontrols")==AROIcontrol[1]||List.get("AROIcontrols")==AROIcontrol[2]||List.get("AROIcontrols")==AROIcontrol[3])&&List.get("advancedoptions")){
				Dialog.addCheckbox("Define specific details for cell segmentation (using the Particle Analyzer).",List.get("particledetails")); //particledetails 
			};
			if(List.get("advancedoptions")){
				Dialog.addCheckbox("Add manual cell classification step after cell segmentation.",parseFloat(List.get("CellClassification")));
			};
			Dialog.addMessage(" ");
			Dialog.addCheckbox("Go to the previous dialog.",false);
			//-----------------------------------------
			Dialog.addHelp(help);
			Dialog.show();
			if(List.get("import")!=2){List.set("seriesgrouping",false);List.set("multiseries",false);};
			if(List.get("import")==2&&!List.get("maxseriesnumbers")){
				List.set("filename",Dialog.getChoice());	
			};
			if(List.get("import")==2&&List.get("maxseriesnumbers")){
				List.set("LOCIimports",Dialog.getChoice());
			};
			if(List.get("import")==2){
				List.set("OpenRois",Dialog.getCheckbox());
			};
			if(List.get("import")==2&&List.get("advancedoptions"))List.set("Swapdimensions",Dialog.getCheckbox());
			if(List.get("import")==2&&Exptype==0){
				List.set("seriesgrouping",Dialog.getCheckbox());
			}; //true = 2 false = 1
			if(Exptype==1){//Details for timelapse experiments
				List.set("spf",Dialog.getNumber());//6c	
				if(stimulation)List.set("Stimulusafterframe",Dialog.getNumber());//6b
				if(stimulation&&List.get("advancedoptions"))List.set("Equilibrationtime",Dialog.getNumber());//6b2
				if(stimulation&&List.get("advancedoptions"))List.set("stopafterframe",Dialog.getNumber());
				if(stimulation&&List.get("advancedoptions"))List.set("FRETcalcchoices",Dialog.getChoice()); //10a
				List.set("onecellexp",Dialog.getCheckbox());
				if(stimulation&&List.get("advancedoptions"))List.set("Fitequations",Dialog.getCheckbox()); //6b3
			};
			spforig=parseFloat(List.get("spf"));
			List.set("chnumber",Dialog.getNumber());
			if(List.get("advancedoptions"))List.set("containzstack",Dialog.getCheckbox());
			if((List.get("AROIcontrols")==AROIcontrol[1]||List.get("AROIcontrols")==AROIcontrol[2]||List.get("AROIcontrols")==AROIcontrol[3])&&List.get("advancedoptions"))List.set("particledetails",Dialog.getCheckbox());
			if(List.get("AROIcontrols")==AROIcontrol[0])List.set("particledetails",false);
			if(List.get("advancedoptions"))List.set("CellClassification",Dialog.getCheckbox());
			checkD=Dialog.getCheckbox();
			if(checkD)checkD1=true;
			checkD2=false;
			if(!checkD)checkD3=true;
			if(List.get("import")==2&&List.get("maxseriesnumbers")){
				for(i=0;i<ALOCIimport.length;i++){
					if(List.get("LOCIimports")==ALOCIimport[i])List.set("filetype",ALOCIfileext[i]);		
				};
			};
			if(List.get("import")==2&&!checkD){
				if(!List.get("maxseriesnumbers")){
					List.set("importpath",dir+List.get("filename"));
					doescontainpoint=indexOf(List.get("filename"), ".");
					if(doescontainpoint>=0){
						indexpoint=lastIndexOf(List.get("filename"), ".");
						List.set("filetype",toLowerCase(substring(List.get("filename"), indexpoint)));
					};
					if(doescontainpoint<0){
						showMessage(List.get("filename")+" is not a valid file for the LOCI Bio-Formats Importer.");
						if(!checkD){
							checkD3=false;
							checkD2=true;
						};
					};
				};
			};
			manual_filetype_input=false;
			if(List.get("filetype")==ALOCIfileext[0])manual_filetype_input=true;
			//if(List.get("seriesgrouping"))List.set("multiseries",false);
		};
		//if(List.get("import")==2&&Exptype==0)List.set("multiseries",false);
		if(List.get("import")==2&&Exptype==1)List.set("seriesgrouping",false);
		//if(!List.get("maxseriesnumbers"))List.set("processguieachloop",true);
		//if(List.get("maxseriesnumbers")&&List.get("thresholding")==3)List.set("processguieachloop",false);
		if(Exptype==1&&stimulation){
			if(List.get("FRETcalcchoices")==AFRETcalcchoices[0])FRETcalcchoice=1;
			if(List.get("FRETcalcchoices")==AFRETcalcchoices[1])FRETcalcchoice=2;
			if(List.get("FRETcalcchoices")==AFRETcalcchoices[2])FRETcalcchoice=3;	
		};
		stimulustoplots=false;
		if(Exptype==1&&stimulation)stimulustoplots=true;
		if(stimulation)List.set("Decaystart",parseFloat(List.get("Stimulusafterframe"))+parseFloat(List.get("Equilibrationtime")));
		
		//------------------------------------------------
	//Import channel dialog
		//------------------------------------------------
		if(checkD3){
			Dialog.create("Dialog III - "+macroinfo);
			Dialog.addMessage("Details to import your imaging channels.");
			if(List.get("import")==2&&List.get("maxseriesnumbers")){
				if(manual_filetype_input){//List.get("filetype")==ALOCIfileext[0]
					Dialog.addString("File extension of your image file(s) (e.g. '.tif').",List.get("filetype"));		
				};
			};
			for(ch=1;ch<=parseFloat(List.get("chnumber"));ch++){
				Dialog.addMessage("Details for channel "+ch);	
				Dialog.addChoice("Type of channel:",Achanneltype, List.get("chtype"+ch));
				Dialog.addString("Name of channel:", List.get("chname"+ch));
				if(List.get("import")==1){
					Dialog.addString("File-names contain:",List.get("chabbrev"+ch)); //5 String 1 donorname List.get("chabbrev")+ch-1);
				};
				if(List.get("import")==2){
					List.set("chabbrev"+ch,ch);
				};
				if(List.get("advancedoptions"))Dialog.addChoice("Display in color:",Achannelcolor, List.get("chcolor"+ch));
			};
			Dialog.addCheckbox("Correct transfer channel for bleed-through and cross-excitation (sensitized emission). (Acceptor channel and correction factors needed.)",parseFloat(List.get("ComputeSE")));
			Dialog.addCheckbox("Quantify translocation events.",parseFloat(List.get("MeasureTranslocation")));
			Dialog.addCheckbox("Quantify colocalization.",parseFloat(List.get("MeasureColocalization")));
			if(Exptype==0){
				List.set("Fitequations",false);
			};
			if(List.get("onecellexp")&&List.get("advancedoptions")&&List.get("maxseriesnumbers")&&Exptype==1){
				Dialog.addNumber("How many ROIs should be kept in the memory for individual analysis?",parseFloat(List.get("ROIstoremember")));
			};
			if((Exptype==1||Exptype==0)&&List.get("advancedoptions")){
				if(List.get("Fitequations")||(List.get("import")==2&&!List.get("multiseries"))){
					if(List.get("Fitequations")&&stimulation){
						if(List.get("Fitequations")){
							Dialog.addMessage("Details for fitting. Fitting the response starts from frame "+List.get("Decaystart"));	
							Dialog.addChoice("Which equation do you want to use to fit your response?", AFitequation, List.get("AFitequations")); //	
						};
					};
				};
			};
			Dialog.addMessage(" ");
			Dialog.addCheckbox("Go to the previous dialog.",false);
			Dialog.show();
			if(List.get("import")==3){
				List.set("donorname",0);
				List.set("acceptorname",0);
				List.set("intensityname",0);
				List.set("nucleusname",0);	
			};
			if(List.get("import")==2&&List.get("maxseriesnumbers")){
				if(manual_filetype_input){//List.get("filetype")==ALOCIfileext[0]
					List.set("filetype",toLowerCase(Dialog.getString()));
				};
			};
			for(ch=1;ch<=parseFloat(List.get("chnumber"));ch++){
				List.set("chtype"+ch,Dialog.getChoice());
				List.set("chname"+ch,Dialog.getString());
				if(List.get("import")==1){
					List.set("chabbrev"+ch,Dialog.getString());
				};
				if(List.get("advancedoptions"))List.set("chcolor"+ch,Dialog.getChoice());
			};
			List.set("ComputeSE",Dialog.getCheckbox());
			List.set("MeasureTranslocation",Dialog.getCheckbox());
			List.set("MeasureColocalization",Dialog.getCheckbox());
			if(List.get("onecellexp")&&List.get("advancedoptions")&&List.get("maxseriesnumbers")&&Exptype==1){
				List.set("ROIstoremember",Dialog.getNumber());
			};
			if((Exptype==1||Exptype==0)&&List.get("advancedoptions")){
				if(List.get("Fitequations")||(List.get("import")==2&&!List.get("multiseries"))){
					if(List.get("Fitequations")&&stimulation){
						if(List.get("Fitequations")){
							List.set("AFitequations",Dialog.getChoice());
							for(z=0;z<AFitequation.length;z++){
								if(AFitequation[z]==List.get("AFitequations")){
									List.set("Fitequation",z);	
								};
							};	
						};
					};
					
				};
			};
			checkD=Dialog.getCheckbox();
			checkD3=false;
			if(!checkD){
				if(List.get("ComputeSE")||List.get("MeasureTranslocation")||List.get("MeasureColocalization")){
					checkD3b=true;
				}else{
					checkD4=true;
				};
			};
			if(checkD){
				checkD2=true;
			};
			if(List.get("import")==2&&!checkD){
				if(!List.get("maxseriesnumbers")){
					List.set("importpath",dir+List.get("filename"));
					doescontainpoint=indexOf(List.get("filename"), ".");
					if(doescontainpoint>=0){
						indexpoint=lastIndexOf(List.get("filename"), ".");
						List.set("filetype",toLowerCase(substring(List.get("filename"), indexpoint)));
					};
					if(doescontainpoint<0){
						showMessage(List.get("filename")+" is not a valid file for the LOCI Bio-Formats Importer.");
						if(!checkD){
							checkD4=false;
							checkD3=true;
						};
					};
				};
				if(substring(List.get("filetype"), 0, 1)!="."){
					showMessage(List.get("filetype")+" is not a valid filename extension for the LOCI Bio-Formats Importer.");	
					if(!checkD){
						checkD4=false;
						checkD3=true;
					};
				};
			};
			if(List.get("import")==1){
				if(lengthOf(List.get("chabbrev1"))>1)List.set("chabbrev",substring(List.get("chabbrev1"), 0, lengthOf(List.get("chabbrev1"))-1));	
			};
			define_channels_to_analyze();
		};
		if(checkD3b){
			define_channels_to_analyze();
			Dialog.create("Dialog IIIb - "+macroinfo);
			if(List.get("ComputeSE")){
				Dialog.addMessage("Details to calculate sensitized emission channel (SE): \n  SE  = (S-"+fromCharCode(946,183)+"D-("+fromCharCode(947)+"-"+fromCharCode(945,946)+")"+fromCharCode(183)+"A)/(1-"+fromCharCode(946,948)+")\nD = donor excitation, donor emission channel\nS = donor excitation, acceptor emission channel\nA = acceptor excitation, acceptor detection channel\nCorrection factors from donor only images: \n  "+fromCharCode(946)+" = S/D\nCorrection factors from acceptor only images: \n  "+fromCharCode(945)+" = D/A; "+fromCharCode(947)+" = S/A; "+fromCharCode(948)+" D/S\n(setting "+fromCharCode(945)+" and "+fromCharCode(948)+" to 0 results in the simpler SE calculation with bleed-through and cross-excitation correction only)\n("+fromCharCode(945)+" and "+fromCharCode(948)+" coefficients correct for acceptor signal that may be detectable in the donor channel)");
				Dialog.addMessage("Details for "+List.get("acceptorchannel")+" (S)");
				Dialog.addNumber(""+fromCharCode(945)+":",parseFloat(List.get("SEalpha")));
				Dialog.addNumber(""+fromCharCode(946)+" (bleed-through coefficient):",parseFloat(List.get("SEbeta")));
				Dialog.addNumber(""+fromCharCode(947)+" (cross-excitation coefficient):",parseFloat(List.get("SEgamma")));
				Dialog.addNumber(""+fromCharCode(948)+":",parseFloat(List.get("SEdelta")));
				Dialog.addChoice("Donor channel (D)",Atoanalch,List.get("SEdonor"));
				Dialog.addChoice("Acceptor channel (A)",Atoanalch,List.get("SEacceptor"));
				Dialog.addChoice("Transfer/FRET channel (S)",Atoanalch,List.get("SEtransfer"));
			};
			if(List.get("MeasureColocalization")){
				Dialog.addMessage("Details to quantify colocalization: \nChoose channel pairs for quantification. See details at 'http://www.svi.nl/ColocalizationTheory'.");
				//Dialog.addHelp("http://www.svi.nl/ColocalizationTheory");
				for(i=0;i<Atoanalch.length;i++){
					ATransChoice=Array.concat("Don't quantify colocalization",Atoanalch);// Asegch
					Dialog.addChoice(Atoanalch[i],ATransChoice,List.get("ColocChoice"+i));//
				};
				Dialog.addCheckbox("Calculate object Pearson's colocalization coefficient.",parseFloat(List.get("Coloc_Pearson")));
				Dialog.addCheckbox("Calculate slope correlation coefficient.",parseFloat(List.get("Coloc_Slope")));
				Dialog.addCheckbox("Calculate Overlap coefficient.",parseFloat(List.get("Coloc_Overlap")));
				Dialog.addCheckbox("Calculate Manders' k1 and k2 coefficients.",parseFloat(List.get("Coloc_Manders_k")));
				Dialog.addCheckbox("Calculate Manders' M1 and M2 coefficients.",parseFloat(List.get("Coloc_Manders_M")));
				Dialog.addCheckbox("Calculate intersection coefficients i1 and i2.",parseFloat(List.get("Coloc_Intersection")));
			};
			if(List.get("MeasureTranslocation")){
				Dialog.addMessage("Details to quantify translocation:\nChoose names of two pixel classes (regions of the cell) for which the ratio will be calculated.");
				Dialog.addString("Marker name (e.g. PM):",List.get("Marker_name"));
				Dialog.addString("Background name (e.g. cytosol):",List.get("Background_name"));
				Dialog.addMessage("Choose the 'marker' channel to classify signal into 'marker' and 'background' for the corresponding channels.");
				for(i=0;i<Atoanalch.length;i++){
					ATransChoice=Array.concat("Don't quantify translocation","No marker channel. Quantify only local events",Atoanalch);// Asegch
					Dialog.addChoice(Atoanalch[i],ATransChoice,List.get("TransChoice"+i));//
				};
				Dialog.addChoice("How to process 'Marker' channel?",Atrch_method,List.get("method_trch"));
				Dialog.addChoice("Marker-backround ratio should be calculated from which statistical summary?",Ameasure,List.get("Ratio_Measure"));//
				Dialog.addNumber("Average compartment width [pixel] where translocation events happen:", parseFloat(List.get("radius_trch")));
				Dialog.addCheckbox("Exclude background pixels in translocation channel.",parseFloat(List.get("NaN_translocation")));
			};
			Dialog.addMessage(" ");
			Dialog.addCheckbox("Go to the previous dialog.",false);
			Dialog.show();
			if(List.get("ComputeSE")){
				List.set("SEalpha",Dialog.getNumber());
				List.set("SEbeta",Dialog.getNumber());
				List.set("SEgamma",Dialog.getNumber());
				List.set("SEdelta",Dialog.getNumber());
				List.set("SEdonor",Dialog.getChoice());
				List.set("SEacceptor",Dialog.getChoice());
				List.set("SEtransfer",Dialog.getChoice());
				diff=abs(parseFloat(List.get("SEdelta"))-(parseFloat(List.get("SEalpha")))/(parseFloat(List.get("SEgamma"))));
				if(!isNaN(diff)){
					if(parseFloat(List.get("SEdelta"))>=(parseFloat(List.get("SEalpha")))/(parseFloat(List.get("SEgamma")))){
						diff_p=diff/parseFloat(List.get("SEdelta"))*100;
					}else{
						diff_p=diff/(parseFloat(List.get("SEalpha")))/(parseFloat(List.get("SEgamma")))*100;
					};
					if(diff_p>1)waitForUser("Warning: equation "+fromCharCode(948)+"="+fromCharCode(945)+"/"+fromCharCode(947)+" is not true! Difference is "+diff_p+"%. Please check your coefficients again.");
				};
				for(i=0;i<Atoanalch.length;i++){
					if(Atoanalch[i]==List.get("SEdonor")){
						SEdonor=Achnames[i];
					};
					if(Atoanalch[i]==List.get("SEtransfer")){
						SEtransfer=Achnames[i];
					};
				};
				//rationame=""+List.get("SEdonor")+"-"+List.get("SEtransfer")+"-FRET";
				rationame="SE corrected "+SEtransfer+"-"+SEdonor+"-ratio";
				//SEtransfer="SE corrected "+List.get("SEtransfer");
				SEtransfer="SE corrected "+SEtransfer;
				Achnames=Array.concat(Achnames,rationame);	
				Awindownames=Array.concat(Awindownames,""+rationame);
				List.set("SEratiochannel",""+rationame);
				no=Awindownames.length-1;
				Atoanal=Array.concat(Atoanal,no);	
				List.set("SEtransfer_corr",SEtransfer);
				Achnames=Array.concat(Achnames,SEtransfer);
				Awindownames=Array.concat(Awindownames,""+SEtransfer);
				no=Awindownames.length-1;
				Atoanal=Array.concat(Atoanal,no);
			};
			if(List.get("MeasureColocalization")){
				noofcolocch=0;
				for(i=0;i<Atoanalch.length;i++){
					ColocChoice=Dialog.getChoice();
					List.set("ColocChoice"+i,ColocChoice);
					
				};
				List.set("Coloc_Pearson",Dialog.getCheckbox());
				List.set("Coloc_Slope",Dialog.getCheckbox());
				List.set("Coloc_Overlap",Dialog.getCheckbox());
				List.set("Coloc_Manders_k",Dialog.getCheckbox());
				List.set("Coloc_Manders_M",Dialog.getCheckbox());
				List.set("Coloc_Intersection",Dialog.getCheckbox());
				for(i=0;i<Atoanalch.length;i++){
					ColocChoice=List.get("ColocChoice"+i);
					for(j=0;j<Awindownames.length;j++){
						if(Awindownames[j]==ColocChoice){
							ColocChoicename=Achnames[j];//Hier kam ein Fehler
							j=Awindownames.length;
						};
					};
					if(ColocChoice!="Don't quantify colocalization"&&(List.get("Coloc_Pearson")||List.get("Coloc_Slope")||List.get("Coloc_Overlap")||List.get("Coloc_Manders_k")||List.get("Coloc_Manders_M"))){
						noofcolocch++;
						POIname=Achnames[Atoanalchno[i]];
						POIwindow=Awindownames[Atoanalchno[i]];
						List.set("ColocName_POI"+noofcolocch,POIwindow);
						List.set("ColocName_Marker"+noofcolocch,ColocChoice);
						if(List.get("Coloc_Pearson")){
							List.set("ColocName_Pearson"+noofcolocch,"Pearson "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Pearson"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Pearson"+noofcolocch));
						};
						if(List.get("Coloc_Slope")){
							List.set("ColocName_Slope"+noofcolocch,"Slope "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Slope"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Slope"+noofcolocch));
						};
						if(List.get("Coloc_Overlap")){
							List.set("ColocName_Overlap"+noofcolocch,"Overlap "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Overlap"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Overlap"+noofcolocch));
						};	
						if(List.get("Coloc_Manders_k")){
							List.set("ColocName_Manders_k1"+noofcolocch,"Manders k1 "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Manders_k1"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Manders_k1"+noofcolocch));
							List.set("ColocName_Manders_k2"+noofcolocch,"Manders k2 "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Manders_k2"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Manders_k2"+noofcolocch));
						};
						if(List.get("Coloc_Manders_M")){
							List.set("ColocName_Manders_M1"+noofcolocch,"Manders M1 "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Manders_M1"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Manders_M1"+noofcolocch));
							List.set("ColocName_Manders_M2"+noofcolocch,"Manders M2 "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Manders_M2"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Manders_M2"+noofcolocch));
						};
						if(List.get("Coloc_Intersection")){
							List.set("ColocName_Intersection_i1"+noofcolocch,"Intersection i1 "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Intersection_i1"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Intersection_i1"+noofcolocch));
							List.set("ColocName_Intersection_i2"+noofcolocch,"Intersection i2 "+POIname+"-"+ColocChoicename);
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("ColocName_Intersection_i2"+noofcolocch));
							Achnames=Array.concat(Achnames,List.get("ColocName_Intersection_i2"+noofcolocch));
						};
					};
				};
			};
			if(List.get("MeasureTranslocation")){
				List.set("Marker_name",Dialog.getString());
				List.set("Background_name",Dialog.getString());
				nooftrch=0;
				for(i=0;i<Atoanalch.length;i++){
					TransChoice=Dialog.getChoice();
					List.set("TransChoice"+i,TransChoice);
					
				};
				List.set("method_trch",Dialog.getChoice());
				List.set("Ratio_Measure",Dialog.getChoice());
				List.set("radius_trch",Dialog.getNumber());
				List.set("NaN_translocation",Dialog.getCheckbox());
				for(i=0;i<Atoanalch.length;i++){
					TransChoice=List.get("TransChoice"+i);
					if(TransChoice!="Don't quantify translocation"){//asdfasdf
						nooftrch++;
						no=Awindownames.length-1;
						POIname=Achnames[Atoanalchno[i]];
						List.set("POIchannel"+nooftrch,Atoanalch[i]);
						List.set("POIname"+nooftrch,POIname);
						List.set("Markerchannel"+nooftrch,TransChoice);	
						if(TransChoice!="No marker channel. Quantify only local events"){//
							List.set("POI_marker"+nooftrch,""+POIname+" "+List.get("Marker_name")+"-region");
							List.set("POI_background"+nooftrch,""+POIname+" "+List.get("Background_name")+"-region");
							List.set("POI_ratio"+nooftrch,""+POIname+" "+List.get("Marker_name")+"-"+List.get("Background_name")+"-ratio");
							//Marker region
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("POI_marker"+nooftrch));
							Achnames=Array.concat(Achnames,""+POIname+" "+List.get("Marker_name")+"-region");
							//Background region
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("POI_background"+nooftrch));
							Achnames=Array.concat(Achnames,""+POIname+" "+List.get("Background_name")+"-region");
							//Marker region-Background-ratio by Sabine Reither Frank accepted (under pressure) hard pressure
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,List.get("POI_ratio"+nooftrch));
							Achnames=Array.concat(Achnames,""+POIname+" "+List.get("Marker_name")+"-"+List.get("Background_name")+"-ratio");
						};
						if(TransChoice=="No marker channel. Quantify only local events"){
							List.set("Markerchannel"+nooftrch,"None");
							List.set("Localchannel"+nooftrch,"Local "+Atoanalch[i]);	
							no=Awindownames.length;
							Atoanal=Array.concat(Atoanal,no);
							Awindownames=Array.concat(Awindownames,"Local "+Atoanalch[i]);
							Achnames=Array.concat(Achnames,"Local "+POIname);
						};
					};
				};
				
			};
			checkD=Dialog.getCheckbox();
			checkD3b=false;
			if(!checkD){
				checkD4=true;
			};
			if(checkD){
				checkD3=true;
			};
		};
		if(checkD4){
			if(List.get("advancedoptions")||(List.get("BM")==1||List.get("thresholding")==2)){
				for(f=0;f<Ameasuretit.length;f++){
					if(Ameasure[f]==List.get("Measure"))Ameasureinit=Ameasuretit[f];	
				};
				Dialog.create("Dialog IV - "+macroinfo);
				Dialog.addChoice("Which measurement parameter should be used to the produce summary statistics?",Ameasuretit,Ameasureinit);
				if(List.get("advancedoptions")){
					if(noofratioch==0)Dialog.addCheckbox("Exclude saturated pixels from intensiometric channels.",List.get("noNaNss"));//noNaNss
					if(noofratioch>0)Dialog.addCheckbox("Exclude saturated pixels from intensiometric channels. (Saturated pixels from ratiometric channels are always excluded.)",List.get("noNaNss"));//noNaNss
				};
				if((List.get("maxseriesnumbers")||List.get("multiseries"))&&List.get("thresholding")!=3&&List.get("advancedoptions"))Dialog.addCheckbox("Acquire threshold values only in the first experiment and apply them for the following.",List.get("processguieachloop"));
				if(List.get("advancedoptions"))Dialog.addCheckbox("Exclude ROIs whose mean value falls below the threshold level in any channel.",parseFloat(List.get("checkROIsforNaNs")));//checkROIsforNaNs
				for(ch=1;ch<=parseFloat(List.get("chnumber"));ch++){
					if(List.get("chtype"+ch)!=Achanneltype[6]){
						if(List.get("chtype"+ch)!=Achanneltype[5]){
							if(List.get("BM")==1||List.get("thresholding")==2)Dialog.addMessage("Details for image processing for "+List.get("chname"+ch)+"-channel.");
							if(List.get("BM")==1)Dialog.addNumber("Background value to subtract:",parseFloat(List.get("background_"+ch)));
							if(List.get("thresholding")==2){
								Dialog.addNumber("Set minimum thresholding level:",parseFloat(List.get("minvalue_"+ch)));//6b minvalue_ic	
							};
						};
					};	
				};
				if(List.get("thresholding")==3&&List.get("advancedoptions")){
					//Dialog.addMessage("Choose the thresholding method to distinguish cells from background.");
					Dialog.addChoice("Threshold algorithm to exclude low value pixels:", Athresholdmethods, List.get("thresholdmethod"));	
				};
				if(List.get("BM")==5&&List.get("advancedoptions"))Dialog.addChoice("Threshold algorithm to define background pixels:",Athresholdmethods,List.get("thresholdmethod_background"));
				if(List.get("thresholding")==2){
					Dialog.addMessage(" ");
					Dialog.addNumber("Set minimum threshold limit for cell segmentation.",List.get("minvalue"));  
				};
				//if(BM==2&&List.get("advancedoptions"))Dialog.addMessage("Details for background subtraction:\nYou have chosen: "+BMs);
				if(List.get("BM")==2&&List.get("advancedoptions")){Dialog.addNumber("Rolling ball radius for built-in 'Subtract background':", List.get("RBradius"));}; //4c RBradius 
				if(List.get("Asmothenings")!="None"&&List.get("advancedoptions"))Dialog.addNumber("Radius size for "+List.get("Asmothenings")+" filter:", parseFloat(List.get("mradius"))); //8 mradius 
				if(List.get("containzstack")&&List.get("advancedoptions"))Dialog.addChoice("How to handle a Z-stack? Use which Z-Projection method.",Azprojection,List.get("zprojectionmethod"));//zprojectionmethod=Azprojection[0];
				Dialog.addChoice("Choose channel for cell segmentation.", Asegch, List.get("segmentationchannel"));
				Dialog.addChoice("Choose Z-projection method for cell segmentation channel.",Aprojection,List.get("segmentationprojection"));
				if(List.get("particledetails")){
					Dialog.addMessage("Details for cell segmentation using the Particle Analyzer.");
					Dialog.addString("Minimum size of your objects/cells (micron^2):", List.get("particlesize")); //9 particlesize 
					Dialog.addString("Maximum size of your objects/cells (micron^2):",List.get("maxparticlesize"));// maxparticlesize
					Dialog.addString("Minimum circularity of your objects/cells:",List.get("mincircularity")); //mincircularity
					Dialog.addString("Maximum circularity of your objects/cells:",List.get("maxcircularity"));//9- maxcircularity	
					Dialog.addCheckbox("Exclude on edges.",List.get("excludeoneedges")); //excludeoneedges
					Dialog.addCheckbox("Use Watershed algorithm to divide attaching cells automatically.",List.get("watershed"));
					Dialog.addCheckbox("Include holes in your segmentation.",List.get("Fill-holes"));
				};
				if(List.get("CellClassification")){
					Dialog.addMessage("Details for manual cell classification.");
					Dialog.addNumber("How many different classes should be used.",parseFloat(List.get("ClassNumber")));
					Dialog.addChoice("Choose channel to classify cells.", Atoanalch, List.get("classificationchannel"));
				};
				if(transmissiono>0){
					Dialog.addMessage("Details to process transmission channels.");
					Dialog.addChoice("Noise reduction/smoothing method for transmission channel:",Asmothening,List.get("Asmothenings_transmission"));
					Dialog.addNumber("Radius size for transmission smoothening method:", parseFloat(List.get("mradius_transmission")));
					Dialog.addCheckbox("Threshold transmission channels.",parseFloat(List.get("NaN_transmission")));
				};
				Dialog.addMessage(" ");
				Dialog.addCheckbox("Go to the previous dialog.",false);
				Dialog.show();
				Ameasureinit=Dialog.getChoice();
				if(List.get("advancedoptions"))List.set("noNaNss",Dialog.getCheckbox());
				if((List.get("maxseriesnumbers")||List.get("multiseries"))&&List.get("thresholding")!=3&&List.get("advancedoptions"))List.set("processguieachloop",Dialog.getCheckbox());
				if(List.get("advancedoptions"))List.set("checkROIsforNaNs",Dialog.getCheckbox());
				for(ch=1;ch<=parseFloat(List.get("chnumber"));ch++){
					chno=ch-1;
					if(List.get("chtype"+ch)!=Achanneltype[6]){
						if(List.get("chtype"+ch)!=Achanneltype[5]){
							if(List.get("BM")==1)List.set("background_"+ch,Dialog.getNumber());
							if(List.get("thresholding")==2){
								List.set("minvalue_"+ch,Dialog.getNumber());
								Aminvalue[chno]=List.get("minvalue_"+ch);
							};
						};
					};
				};
				if(List.get("thresholding")==3&&List.get("advancedoptions"))List.set("thresholdmethod",Dialog.getChoice());
				if(List.get("BM")==5&&List.get("advancedoptions"))List.set("thresholdmethod_background",Dialog.getChoice());
				if(List.get("thresholding")==2)List.set("minvalue",Dialog.getNumber());
				if(List.get("BM")==2&&List.get("advancedoptions")){List.set("RBradius",Dialog.getNumber());background=0;}; //RBradius Rolling ball radius
				if(List.get("Asmothenings")!="None"&&List.get("advancedoptions"))List.set("mradius",Dialog.getNumber()); //8 mradius
				if(List.get("containzstack")&&List.get("advancedoptions"))List.set("zprojectionmethod",Dialog.getChoice());
				List.set("segmentationchannel",Dialog.getChoice());
				List.set("segmentationprojection",Dialog.getChoice());
				if(List.get("particledetails")){
					List.set("particlesize",Dialog.getString());//9 particlesize 
					List.set("maxparticlesize",Dialog.getString());
					List.set("mincircularity",Dialog.getString());
					List.set("maxcircularity",Dialog.getString());//9-	
					List.set("excludeoneedges",Dialog.getCheckbox());
					List.set("watershed",Dialog.getCheckbox());
					List.set("Fill-holes",Dialog.getCheckbox());
				};
				if(List.get("CellClassification")){
					List.set("ClassNumber",Dialog.getNumber());
					List.set("classificationchannel",Dialog.getChoice());
				};
				if(transmissiono>0){
					List.set("Asmothenings_transmission",Dialog.getChoice());
					List.set("mradius_transmission",Dialog.getNumber());
					List.set("NaN_transmission",Dialog.getCheckbox());
				};	
				checkD=Dialog.getCheckbox();
				for(f=0;f<Atoanal.length;f++){
					if(List.get("segmentationchannel")==Awindownames[Atoanal[f]])List.set("segchno",f);	
				};
				for(f=0;f<Ameasuretit.length;f++){
					if(Ameasureinit==Ameasuretit[f])List.set("Measure",Ameasure[f]);	
				};
			};
			checkD4=false;
			if(!checkD){
				checkD5=true;
			};
			if(checkD){
				if(List.get("ComputeSE")||List.get("MeasureTranslocation")||List.get("MeasureColocalization")){
					checkD3b=true;
				}else{
					checkD3=true;
				};
			};	
		};
	//5th Dialog
		if(checkD5){
			if(List.get("advancedoptions")){
				Dialog.create("Dialog V - Save options. "+macroinfo);
				Dialog.addMessage("Please choose the images you want to save.");
				if(Exptype==1){
					if(List.get("import")==2)Dialog.addCheckbox("Save processed 8-bit images (scale bar and time stamp included).",List.get("save8"));//3
					if(List.get("import")!=2)Dialog.addCheckbox("Save processed 8-bit images (time stamp included).",List.get("save8"));//3
				};
				if(Exptype==0)Dialog.addCheckbox("Save processed 8-bit images.",List.get("save8"));//3
				Dialog.addCheckbox("Save processed 32-bit images.",List.get("save32"));//4
				Dialog.addCheckbox("Save binary masks.",List.get("savemask"));//6 
				Dialog.addMessage(" ");
				Dialog.addCheckbox("Do statistical analysis and save result table(s).",List.get("saveanalysis"));//8
				Dialog.addMessage(" ");
				Dialog.addCheckbox("Save all options from the dialogs and suggest them when using the macro the next time.",List.get("savetmp"));
				Dialog.addCheckbox("Save all Results in a text file for analysis with e.g. R.",List.get("saveRfile"));
				Dialog.addCheckbox("Close all windows after the macro finished.",List.get("cls"));
				Dialog.addCheckbox("Mark all identified experiments with a check mark in the 'Experiment selection' dialog?",parseFloat(List.get("choose_default")));
				if((List.get("maxseriesnumbers")||List.get("multiseries")))Dialog.addCheckbox("Edit names of your experiments.",List.get("editnames"));
				if(List.get("CellClassification")){
					Dialog.addMessage("Please name the different classes for your cell classification.");
					classes=parseFloat(List.get("ClassNumber"));
					for(class=0;class<classes;class++){
						No=class+1;
						Dialog.addString("Class No "+No,List.get("Class_"+No));
					};
				};
				Dialog.addMessage(" ");
				Dialog.addCheckbox("Go to the previous dialog.",false);
				Dialog.show();
				List.set("save8",Dialog.getCheckbox());//3
				List.set("save32",Dialog.getCheckbox());//4
				List.set("savemask",Dialog.getCheckbox());//6
				List.set("saveanalysis",Dialog.getCheckbox());//8
				List.set("savetmp",Dialog.getCheckbox());
				List.set("saveRfile",Dialog.getCheckbox());
				List.set("cls",Dialog.getCheckbox());
				List.set("choose_default",Dialog.getCheckbox());
				if((List.get("maxseriesnumbers")||List.get("multiseries")))List.set("editnames",Dialog.getCheckbox());
				if(List.get("CellClassification")){
					for(class=0;class<classes;class++){
						No=class+1;
						List.set("Class_"+No,Dialog.getString());
					};
				};
				if(!List.get("savetmp")){
					if(File.exists(tmp_file))x=File.delete(tmp_file);
					if(File.exists(tmp_file_dir))x=File.delete(tmp_file_dir);
				};
				checkD=Dialog.getCheckbox();
			};
			checkD5=false;
			if(!checkD){
				checkD6=true;
			};
			if(checkD){
				checkD4=true;
			};	
		};
		if(List.get("CellClassification")){
			classes=parseFloat(List.get("ClassNumber"));
			Aclasses=newArray(classes);
			for(class=0;class<classes;class++){
				No=class+1;
				Aclasses[class]=List.get("Class_"+No);
			};
		};
	//Dialog VI Plot Dialog! 
		if(checkD6){
			if(List.get("advancedoptions")){
				Dialog.create("Dialog VI - Choose plots and summaries to save. "+macroinfo);
				if(Exptype==1&&List.get("saveanalysis")){
					if(stimulation){
						Dialog.addCheckbox("Compute image that shows amplitude change for each pixel.",List.get("saveFRETratio"));//7
					};
					Dialog.addMessage("Choose plots:");
					Dialog.addCheckbox("Plot "+List.get("Measure")+" intensity of all ROIs versus time.",List.get("pMM"));
					if(!List.get("onecellexp")){
						Dialog.addCheckbox("Plot "+List.get("Measure")+" intensity as mean of all ROIs versus time.",List.get("pmean"));	
						Dialog.addCheckbox("Plot "+List.get("Measure")+" intensity as median of all ROIs versus time.",List.get("pmedian"));
					};
					if(List.get("onecellexp")){
						Dialog.addCheckbox("Plot "+List.get("Measure")+" intensity of each ROI versus time in separate plot.",List.get("pocaR"));		
					};
					if(Atoanal.length>1){
						Dialog.addMessage("Plots for multi-parameter imaging.");
						if(!List.get("onecellexp")){
							Dialog.addCheckbox("Plot "+List.get("Measure")+" intensity of all channels versus time in one plot.",List.get("pmccor"));
						};
						if(List.get("onecellexp")){
							Dialog.addCheckbox("Plot "+List.get("Measure")+" intensity of all channels for each ROI versus time in one plot.",List.get("pmccor"));					
						};	
					};
				};
				Dialog.addMessage("Additional measurement parameter(s) for each ROI:");
				Adefaults=split(List.get("Parameter_bin")); 
				if(Adefaults.length<=1){
					List.set("Parameter_bin","1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0");
					Adefaults=split(List.get("Parameter_bin")); 
				};
				Dialog.addCheckboxGroup(8,4,AmeasureTitle,Adefaults);
				Dialog.addMessage(" ");
				Dialog.addCheckbox("Go to the previous dialog.",false);
				Dialog.show();
				if(Exptype==1&&List.get("saveanalysis")){
					if(stimulation){
						List.set("saveFRETratio",Dialog.getCheckbox());//7
					};
					List.set("pMM",Dialog.getCheckbox()); 
					if(!List.get("onecellexp")){
						List.set("pmean",Dialog.getCheckbox());	
						List.set("pmedian",Dialog.getCheckbox());	
					};
					if(List.get("onecellexp")){
						List.set("pocaR",Dialog.getCheckbox());	
					};
					if(Atoanal.length>1){
						if(!List.get("onecellexp")){
							List.set("pmccor",Dialog.getCheckbox());
						};
						if(List.get("onecellexp")){
							List.set("pmccor",Dialog.getCheckbox());					
						};	
					};
				};
				for(i=0;i<AmeasureTitle.length;i++){
					Adefaults[i]=Dialog.getCheckbox();	
				};
				measure_Parameter_bin=array2string(Adefaults," ");
				List.set("Parameter_bin",measure_Parameter_bin);
				checkD=Dialog.getCheckbox();
			};
			checkD6=false;
			if(!checkD){
				dialogdone=true;
			};
			if(checkD){
				checkD5=true;
			};
		};
	};
	saveparameter(); //Save all used parameter in a temp file	
};
function resize(){
	getLocationAndSize(x, y, width, height);
	wratio=height/width;
	hratio=width/height;
	wfactor=(scwidth-220)/scwidth;
	hfactor=(scheight-220)/scheight;
	wspace=screenWidth*wfactor;
	hspace=screenHeight*hfactor;
	if(parseFloat(List.get("chnumber"))>2){
		setLocation(x,y,wspace/2,hspace/2);
	};
	if(parseFloat(List.get("chnumber"))<=2){
		setLocation(x,y,wspace/2,hspace);
	};
};
function getimportparameter(){
	if(List.get("import")==1){//&&List.get("maxseriesnumbers")
		Asubfolderpath=subfolderarray(dir,List.get("chabbrev"),parseFloat(List.get("chnumber")));
		if(Asubfolderpath.length==0)exit("No file with the extensions "+List.get("chabbrev")+"0"+"-"+round(List.get("chnumber"))+" was found in any subfolder of "+dir);
       		maxseriesnumber=Asubfolderpath.length;	
       		Aseriesname=nameofsubfolder(Asubfolderpath);
       	};
	if(List.get("import")==2){
		if(List.get("maxseriesnumbers")){
			showProgress(0.1);
			showStatus("The macro looks for "+List.get("filetype")+"-files in your working folder!");
			Afilepathes=importpatharray(dir,List.get("filetype"),"0");
			if(Afilepathes[0]=="No file was found")exit("No file with  the extension "+List.get("filetype")+" was found in any subfolder of "+dir);
			showStatus("The macro extracts the file-names of all found files!");
			Aseriesname=filenamearray(Afilepathes,List.get("filetype"));
			showStatus("The macro extracts the names of the parent folder of all found files!");
			Aparentfolder=nameofparentfolder(Afilepathes);
			Aseriesname=extendnamewithfoldername(Aparentfolder,Aseriesname);
			maxseriesnumber=Aseriesname.length;
		};
		if(List.get("multiseries")&&!List.get("maxseriesnumbers")){
			Aseriesname=maxseriesnamereturn(List.get("importpath"),parseFloat(List.get("chnumber")));
			namecheck=false;
			for(i=0;i<Aseriesname.length;i++){
				if(Aseriesname[i]!=0)namecheck=true;	
			};
			if(!namecheck)exit("No series was found that matched your experimental setup!");
			Aseries=maxseriesnoreturn(Aseriesname);
			Aseriesname=delzerofromarray(Aseriesname);
			//if(Aseriesname.length==1)Aseriesname[0]=origtitle;
			maxseriesnumber=Aseriesname.length;
			if(List.get("seriesgrouping")){
				Awindowstitlearray=delzerofromarray(Awindowstitlearray);
			};
		};
		if(List.get("multiseries")&&List.get("maxseriesnumbers")){
			for(i=0;i<maxseriesnumber;i++){
				showProgress(i/maxseriesnumber);
				Asingleseriesname=maxseriesnamereturn(Afilepathes[i],parseFloat(List.get("chnumber")));
				if(List.get("seriesgrouping")){
					Awindowstitlearray=delzerofromarray(Awindowstitlearray);
				};
				Asingleseries=maxseriesnoreturn(Asingleseriesname);
				Asingleseriesname=delzerofromarray(Asingleseriesname);
				singleseriesno=Asingleseriesname.length;
				Asinglefilepathes=newArray(singleseriesno);
				for(f=0;f<singleseriesno;f++){
					Asinglefilepathes[f]=Afilepathes[i];		
				};
				for(f=0;f<singleseriesno;f++){
					if(Asingleseriesname.length>1)Asingleseriesname[f]=""+Aseriesname[i]+"_"+Asingleseriesname[f];
					if(Asingleseriesname.length==1)Asingleseriesname[f]=""+Aseriesname[i];		
				};
				if(i==0){
					iAfilepathes=Asinglefilepathes;
					iAseriesname=Asingleseriesname;
					iAseries=Asingleseries;	
					if(List.get("seriesgrouping")){
						iAwindowstitlearray=Awindowstitlearray;
					};
				};
				if(i>0){
					iAfilepathes=Array.concat(iAfilepathes,Asinglefilepathes);
					iAseriesname=Array.concat(iAseriesname,Asingleseriesname);
					iAseries=Array.concat(iAseries,Asingleseries);
					if(List.get("seriesgrouping")){
						iAwindowstitlearray=Array.concat(iAwindowstitlearray,Awindowstitlearray);
					};
				};
			};
			Afilepathes=iAfilepathes;
			Aseriesname=iAseriesname;
			Aseries=iAseries;
			if(List.get("seriesgrouping")){
				Awindowstitlearray=iAwindowstitlearray;
			};
			if(Afilepathes.length==0)exit("No file was found that matched your experimental setup.");
		};
	};
	if(List.get("import")==1||List.get("import")==2){
		if(Aseriesname.length>1){//Aseriesname!=0||
			Aseriesname=uniquify_array(Aseriesname);
		};
	};
};
function uniquify_array(array){
	narray=newArray(array.length);
	for(i=0;i<array.length;i++){
		narray[i]=array[i];
	};
	for(i=0;i<array.length-1;i++){
		counter=1;
		orig=narray[i];
		for(j=i+1;j<array.length;j++){
			if(orig==narray[j]){
				if(counter==1){
					narray[i]=""+narray[i]+"_"+counter;
					
				};
				counter=counter+1;
				narray[j]=""+narray[j]+"_"+counter;
			};
		};
	};
	return narray;
};
function experimentchoose_dialog(){
	if(List.get("maxseriesnumbers")||List.get("multiseries")){
		Dialog.create("Experiment selection. "+macroinfo);
		Dialog.addMessage("Choose the experiments to analyze.");
		drows=Aseriesname.length;
		maximumrows=round(scheight/30);
		if(Aseriesname.length>maximumrows)drows=maximumrows;
		if((Aseriesname.length%drows)==0)dcolumns=floor(Aseriesname.length/drows);
		if((Aseriesname.length%drows)!=0){
			dcolumns=floor(Aseriesname.length/drows)+1;
		};
		drows=floor(Aseriesname.length/dcolumns)+floor(Aseriesname.length%dcolumns);
		Adefaults=newArray(Aseriesname.length);
		Array.fill(Adefaults, List.get("choose_default"));	
		Dialog.addCheckboxGroup(drows,dcolumns,Aseriesname,Adefaults);
		Dialog.show();
		for(i=0;i<Aseriesname.length;i++){
			Adefaults[i]=Dialog.getCheckbox();	
		};
	};
	if(List.get("import")==1&&List.get("maxseriesnumbers")){
		Asubfolderpath=correctarray(Asubfolderpath,Adefaults);
       		maxseriesnumber=Asubfolderpath.length;	
       		Aseriesname=correctarray(Aseriesname,Adefaults);
       	};
	if(List.get("import")==2){
		if(List.get("maxseriesnumbers")&&!List.get("multiseries")){
			Afilepathes=correctarray(Afilepathes,Adefaults);
			Aseriesname=correctarray(Aseriesname,Adefaults);
			maxseriesnumber=Aseriesname.length;
		};
		if(List.get("multiseries")&&!List.get("maxseriesnumbers")){
			Aseriesname=correctarray(Aseriesname,Adefaults);
			maxseriesnumber=Aseriesname.length;
			Aseries=correctarray(Aseries,Adefaults);
		};
		if(List.get("maxseriesnumbers")&&List.get("multiseries")){
			Afilepathes=correctarray(Afilepathes,Adefaults);
			Aseriesname=correctarray(Aseriesname,Adefaults);
			Aseries=correctarray(Aseries,Adefaults);
			maxseriesnumber=Aseriesname.length;
		};
		if(List.get("seriesgrouping")){
       			Awindowstitlearray=correctarray(Awindowstitlearray,Adefaults);
       		};
	};	
};
function editnames_dialog(){
	if(List.get("maxseriesnumbers")||List.get("multiseries")){
		if(List.get("editnames")){
			if(Aseriesname.length<=20){
				Dialog.create("Edit experiment names. "+macroinfo);
				Dialog.addMessage("Please edit the names of the experiments you have chosen to analyze.");
				for(i=0;i<Aseriesname.length;i++){
					Dialog.addString(Aseriesname[i], Aseriesname[i]);
				};
				Dialog.show();
				for(i=0;i<Aseriesname.length;i++){
					Aseriesname[i]=Dialog.getString;	
				};
			};
			if(Aseriesname.length>20){
				counter=floor(Aseriesname.length/20);
				remainder=Aseriesname.length%20;
				totaldialogs=counter;
				if(remainder!=0)totaldialogs++;
				for(i=1;i<=counter;i++){
					Dialog.create("Edit experiment names. Dialog"+i+" from "+totaldialogs+" - "+macroinfo);
					Dialog.addMessage("Please edit the names of the experiments you have chosen to analyze.");
					for(r=0;r<20;r++){
						c=20*(i-1)+r;
						Dialog.addString(Aseriesname[c], Aseriesname[c]);				
					};
					Dialog.show();
					for(r=0;r<20;r++){
						c=20*(i-1)+r;
						Aseriesname[c]=Dialog.getString;				
					};
				};
				if(remainder!=0){
					Dialog.create("Edit experiment names. Dialog"+i+" from "+totaldialogs+" - "+macroinfo);
					Dialog.addMessage("Please edit the names of the experiments you have chosen to analyze.");
					for(r=0;r<remainder;r++){
						c=counter*20+r;
						Dialog.addString(Aseriesname[c], Aseriesname[c]);		
					};
					Dialog.show();
					for(r=0;r<remainder;r++){
						c=counter*20+r;
						Aseriesname[c]=Dialog.getString;		
					};
				};
			};
		};
	};
};
function setloopparameter(){
	run("Set Measurements...", "  mean standard redirect=None decimal=3");
	List.set("spf",spforig);
	loopp=loop-1;
	closeimages();
	List.set("checkzstack",false);
	if(List.get("import")==1&&List.get("maxseriesnumbers")){
		dir=Asubfolderpath[loopp];
		dir_save=dir_saveorig+Aseriesname[loopp]+" - No "+loop+File.separator;
		File.makeDirectory(dir_save);
		List.set("origtitle",Aseriesname[loopp]);	
	};
	if(List.get("import")==2){
		if(List.get("maxseriesnumbers")&&!List.get("multiseries")){
			List.set("importpath",Afilepathes[loopp]);
			dir_save=dir_saveorig+Aseriesname[loopp]+" - No "+loop+File.separator;
			File.makeDirectory(dir_save);
			List.set("origtitle",Aseriesname[loopp]);
		};
		if(List.get("multiseries")&&!List.get("maxseriesnumbers")){
			if(Aseriesname.length>1)dir_save=dir_saveorig+Aseriesname[loopp]+" - No "+loop+File.separator;
			File.makeDirectory(dir_save);
			//if(Aseriesname.length>1)origtitle="Series "+Aseriesname[loopp]+" No "+loop;
			List.set("series",Aseries[loopp]);
			List.set("origtitle",Aseriesname[loopp]);	
		};
		if(List.get("multiseries")&&List.get("maxseriesnumbers")){
			List.set("importpath",Afilepathes[loopp]);
			dir_save=dir_saveorig+Aseriesname[loopp]+" - No "+loop+File.separator;
			File.makeDirectory(dir_save);
			List.set("origtitle",Aseriesname[loopp]);//origtitle=Aseriesname[loopp]+" No "+loop;
			List.set("series",Aseries[loopp]);
		};
	};	
};
function create_thresholdchannel(channelname){
	frames=nSlices;
	selectWindow(channelname);	
	wait(100);
	getLocationAndSize(x, y, width, height);
	ithresholdpic="Mask "+channelname;
	run("Select None");
	selectWindow(channelname);
	run("Duplicate...", "title=["+ithresholdpic+"] duplicate range=1-["+frames+"]");
	resize();
	run("Conversions...", "scale");
	max=getmaximumpixel(channelname);
	selectWindow(ithresholdpic);
	setMinAndMax(0, max);
	run("8-bit");
	run("Conversions...", " ");
       	run("Median...", "radius=1 stack");
      	run("Fire");
	return ithresholdpic;		
};
function create_thresholdpic(channelname,method){
	selectWindow(channelname);	
	wait(100);
	getLocationAndSize(x, y, width, height);
	ithresholdpic="Time projection of "+channelname;
	intermediate="Intermediate picture of "+channelname;
	run("Select None");
	run("Duplicate...", "title=["+intermediate+"] duplicate range=1-["+frames+"]");
	resize();
	run("Conversions...", "scale");
	max=getmaximumpixel(channelname);
	selectWindow(intermediate);
	setMinAndMax(0, max);
	run("8-bit");
	run("Conversions...", " ");
       	run("Median...", "radius=1 stack");
      	run("Fire");
	//run("Z Project...", "start=1 stop=["+frames+"] projection=[Average Intensity]");
	if(nSlices>1){
		run("Z Project...", "start=1 stop=["+frames+"] projection=["+method+"]");
	};
	//asdf
	run("Rename...", "title=["+ithresholdpic+"]");
	resize();		
	if(isOpen(intermediate)){
		selectWindow(intermediate);
		wait(100);
		close();	
	};
	return ithresholdpic;
};
function create_thresholdpic_fromslice(channelname,currentslice){
	selectWindow(channelname);
	wait(100);
	setSlice(currentslice);	
	if(List.get("cellstainingch"))selectWindow(List.get("cellstainingchannel"));
	if(!List.get("cellstainingch"))selectWindow(channelname);
	wait(100);
	setSlice(currentslice);	
	setLocation(width,0);
	ithresholdpic="Intermediate picture for thresholding cells of slice "+currentslice;
	run("Select None");
	run("Duplicate...", "title=["+ithresholdpic+"]");
	resize();
	setLocation(width,0);
	run("Conversions...", "scale");
	max=getmaximumpixel(channelname);
	selectWindow(ithresholdpic);
	setMinAndMax(0, max);
	run("8-bit");
	run("Conversions...", " ");
       	run("Median...", "radius=1 stack");
      	run("Fire");
      	return ithresholdpic;
};
function create_ROIs(ithresholdpic,rep){
	if(!isOpen("ROI Manager")){
		run("ROI Manager...");	
		selectWindow("ROI Manager");
		setLocation(scwidth-220,0);
	};
	if(Exptype==0)roiManager("Associate", "true");
	if(Exptype==1)roiManager("Associate", "false");
	roiManager("Centered", "false");
	roiManager("UseNames", "false");
	selectWindow(ithresholdpic);
	wait(100);
	frames=nSlices;
	getLocationAndSize(x, y, width, height);
	setLocation(width,0);
	run("Synchronize Windows");
	Rois_exist=false;
	if(experiment_exists){
		fullpath=dir_save+"Modified ROIs.zip";
		Rois_exist=File.exists(fullpath);
		if(Rois_exist){
			roiManager("Open",fullpath);
			roiManager("Deselect");
			roiManager("Show All with labels");
			amountrois=roiManager("count");
			if(amountrois==0)Rois_exist=false;
		};
	};
	if(List.get("createROIsman")){
		if(isOpen("ROI Manager")){//ROI Manager=220x290
			selectWindow("ROI Manager");
			setLocation(scwidth-220,0);	
		};
		showProgress(loop/maxseriesnumber);
		arrange_and_wait(0,ithresholdpic,"None","Please select cell ROIs and add them to the ROI manager!\nClick 'Add [t]' in the window 'ROI manager' to do so.\nThen press OK.",1,"oval");
		thresholdmask=create_mask_from_ROIs(ithresholdpic);
	};
	if(!List.get("createROIsman")){
		thresholdmask=create_mask(ithresholdpic,"minvalue",rep,List.get("thresholding"),List.get("thresholdmethod"),List.get("processguieachloop"));
		if(List.get("nucleuss")){
			if(Exptype==0){
				voronoich=create_thresholdchannel(List.get("nucleuschannel"));
			};
			if(Exptype==1){
				voronoich=create_thresholdpic(List.get("nucleuschannel"),List.get("segmentationprojection"));
			};
			voronoimask=create_mask(voronoich,"minvalue-voronoi",loop,List.get("thresholding"),List.get("thresholdmethod"),List.get("processguieachloop"));
			create_voronoi(voronoimask,thresholdmask);
		};
		if(!List.get("nucleuss")&&List.get("checkROIs_mark")){
			create_manual_voronoi(ithresholdpic,thresholdmask);
		};
		if(List.get("checkROIs_bin")){
			if(isOpen("B&C")){//BC=190x340
				selectWindow("B&C");
				setLocation(scwidth-200,scheight-340);	
			};	
			if(List.get("watershed")){
				setForegroundColor(255, 255, 255);
				arrange_and_wait(0,thresholdmask,ithresholdpic,"Please check the binary mask and the result of the watershed algorithm. Reconnect cells with the Pencil Tool if necessary.\nThen press OK.",1,"Pencil Tool");	
			};
			setForegroundColor(0,0,0);
			showProgress(loop/maxseriesnumber);
			if(frames==1){
				arrange_and_wait(0,thresholdmask,ithresholdpic,"Please check the binary mask and divide cells with the Pencil Tool if necessary. \nUsage of 'Synchronize Windows' is recommended. Click on 'Synchronize All' in this window to make cell division easier.\nThen press OK.",1,"Pencil Tool");	
			};
			if(frames>1){
				arrange_and_wait(0,thresholdmask,ithresholdpic,"Please check the binary mask channel and divide cells with the Pencil Tool if necessary.\nDon't forget to go through each frame.\nUsage of 'Synchronize Windows' is recommended. Click on 'Synchronize All' in this window to make cell division easier.\nThen press OK.",1,"Pencil Tool");	
			};
		};
		selectWindow(thresholdmask);
		wait(100);
		maxvalue=getmaximumpixel(thresholdmask);
		run("Threshold...");
		setThreshold(1, maxvalue);
		if(!Rois_exist){
			if(List.get("excludeoneedges"))run("Analyze Particles...", "size="+List.get("particlesize")+"-"+List.get("maxparticlesize")+" circularity="+List.get("mincircularity")+"-"+List.get("maxcircularity")+" show=Nothing exclude add stack");
			if(!List.get("excludeoneedges"))run("Analyze Particles...", "size="+List.get("particlesize")+"-"+List.get("maxparticlesize")+" circularity="+List.get("mincircularity")+"-"+List.get("maxcircularity")+" show=Nothing add stack");
		};
		resetThreshold();
		amountrois=roiManager("count");
		if(amountrois>0){
			fullpath=dir_save+"Unchecked ROIs.zip";
			roiManager("Save", fullpath);
		};
		if(amountrois>0&&Exptype!=0){
			for(chno=0;chno<Atoanal.length;chno++){
				ch=Atoanal[chno];
				if(List.get("checkROIsforNaNs")&&ch<parseFloat(List.get("chnumber"))){
					amountroisleft=checkROIsforNaN(Awindownames[ch],dir_save);	
				};
			};
		};
		if(amountrois>0&&Exptype==0){
			for(chno=0;chno<Atoanal.length;chno++){
				ch=Atoanal[chno];
				if(List.get("checkROIsforNaNs")&&ch<parseFloat(List.get("chnumber"))){
					amountroisleft=checkROIsforNaN_channel(Awindownames[ch],dir_save);
				};
			};	
		};
		if(isOpen("Log")){
			fullpath=dir_save+"Error message - ROIs.txt";
			selectWindow("Log");
			saveAs("Text", fullpath);
		};
		if(List.get("excludeoneedges")){
			amountrois = roiManager("count");
 			for (i=amountrois-1; i>=0; i--) {
	 			roiManager("select", i);
     				getSelectionBounds(x, y, w, h);
     				if (x<=1||y<=1||x+w>=(getWidth-1)||y+h>=(getHeight-1)){
        				roiManager("delete");
     				};
  			};
		};
		roiManager("Sort");
		amountrois=roiManager("count");
		if(List.get("checkROIs")){
			if(isOpen("ROI Manager")){//ROI Manager=220x290
				selectWindow("ROI Manager");
				setLocation(scwidth-220,0);
			};
			roiManager("Deselect");
			roiManager("Show All with labels");	
			showProgress(loop/maxseriesnumber);
			resetThreshold();
			run("Synchronize Windows");
			arrange_and_wait(0,List.get("segmentationchannel"),ithresholdpic,"Check your ROIs, delete them (if necessary) or add new one's manually.\nDo all changes in the 'ROI manager' window!\nThen press OK.",1,"oval");	
			amountrois=roiManager("count");
			if(frames==1){	
				for(rm=0;rm<amountrois;rm++){
					roiManager("Select", rm);	
					roiManager("Remove Slice Info");
				};
				roiManager("Deselect");
			};
			if(isOpen("Synchronize Windows")){
				selectWindow("Synchronize Windows");
				wait(100);
				run("Close");
			};
		};
		if(!List.get("savemask")){
			if(isOpen(thresholdpic)){
				selectWindow(thresholdpic);
				close();
			};
		};
	};
	amountrois=roiManager("count");
	if(amountrois>0){
		fullpath=dir_save+"Modified ROIs.zip";
		//if(Exptype==0)fullpath=dir_save+"ROIs of Slice "+currentslice+" - "+channelname+".zip";
		if(amountrois>0){
			ROIsfullpath=fullpath;
			roiManager("Save", fullpath);
		};
		if(List.get("nucleuss")&&!List.get("createROIsman")){
			setmeasure="mean";
			for(i=0;i<Ameasure.length;i++){
				if(List.get("Measure")==Ameasure[i])setmeasure=Asetmeasure[i];
			};
			setmeasureString=get_SetMeasurementString();
			run("Set Measurements...", ""+setmeasureString+" standard stack redirect=["+List.get("nucleuschannel")+"] decimal=3");
			amountrois=roiManager("count");
			selectWindow("Nucleuschannel_mask");
			wait(100);
			maxvalue=getmaximumpixel("Nucleuschannel_mask");
			run("Threshold...");
			setThreshold(1, maxvalue);
			if(List.get("excludeoneedges"))run("Analyze Particles...", "size="+List.get("particlesize")+"-"+List.get("maxparticlesize")+" circularity="+List.get("mincircularity")+"-"+List.get("maxcircularity")+" show=Nothing exclude add stack");
			if(!List.get("excludeoneedges"))run("Analyze Particles...", "size="+List.get("particlesize")+"-"+List.get("maxparticlesize")+" circularity="+List.get("mincircularity")+"-"+List.get("maxcircularity")+" show=Nothing add stack");
			resetThreshold();
			newamountrois=roiManager("count");
			run("Clear Results");
			slicecounter=1;
			ROIskip=0;
			ROIcounter=0;
			setBatchMode("hide");
			for(oROI=0;oROI<amountrois;oROI++){
				run("Clear Results");
				roiManager("Select", oROI);
				slice_run=getSliceNumber();
				if(slice_run>slicecounter){
					slicecounter++;
					ROIskip=ROIskip+ROIcounter;
				};
				ROIcounter=0;
				for(nROI=amountrois+ROIskip;nROI<newamountrois;nROI++){
					roiManager("Select", nROI);
					slice_run2=getSliceNumber();
					if(slice_run2>slice_run){
						nROI=newamountrois;
					};
					if(slice_run==slice_run2){
						ROIcounter++;
						roiManager("Select", newArray(oROI,nROI));
						roiManager("AND");
						if(selectionType()!=-1){
							run("Measure");
							Aimean=newArray(1);
							normarray=newArray(1);
							if(nResults>0){
								Aimean[0]=getResult("Mean",0);	
								ROIname=oROI+1;
								write_in_resultstring_nucleus("Nuc "+List.get("nucleuschannel"),Aimean,ROIname,normarray,frames);
							};
							run("Clear Results");
						};
					};
				};
			};
			if(!List.get("runbatchmode"))setBatchMode("exit and display");
			roiManager("Reset");
			roiManager("Open",fullpath);
			run("Set Measurements...", "  mean standard redirect=None decimal=3");
			if(isOpen("Nucleuschannel_mask")){
				selectWindow("Nucleuschannel_mask");
				wait(100);
				close();
			};
			if(isOpen(voronoich)){
				selectWindow(voronoich);
				wait(100);
				fullpath=dir_save+voronoich+".tif";
				if(List.get("savemask")){
					showStatus("Saving... "+voronoich);
					saveAs("Tiff", fullpath);
				};
				close();	
			};
			if(isOpen(voronoimask)){
				selectWindow(voronoimask);
				wait(100);
				fullpath=dir_save+voronoimask+".tif";
				if(List.get("savemask")){
					showStatus("Saving... "+voronoimask);
					saveAs("Tiff", fullpath);
				};
				close();
			};
		};
	};
	if(Exptype!=0){
		if(amountrois<1){
			print("Pictures in folder "+dir_save+" were not processed. No ROI was found."); 
		};
		if(amountrois<3){
			if(nResults2>=1)print("Pictures in folder "+dir_save+" were not fully processed. Only mean values were recorded. Not enough ROIs to measure Median and Standard deviation."); 
			print(" ");
			fullpath=dir_save+"Error message - ROIs.txt";
			selectWindow("Log");
			wait(100);
			saveAs("Text", fullpath);
		};
	};
	if(isOpen("Synchronize Windows")){
		selectWindow("Synchronize Windows");
		wait(100);
		run("Close");
	};
};
function create_manual_voronoi(channel,modifymask){
	mask="Voronoimask of "+channel;
	selectWindow(channel);
	wait(100);
	frames=nSlices;
	run("Duplicate...", "title=["+mask+"] duplicate range=1-["+frames+"]");
	selectWindow(mask);
	run("8-bit");
	run("Fire");
	wait(100);
	run("Divide...", "value=2 stack");
	run("Subtract...", "value=1 stack");
	selectWindow(mask);
	//run("Enhance Contrast", "saturated=0.35");
	setForegroundColor(255, 255, 255);
	color=getValue("foreground.color");
	setColor(color);
	color=color-1;
	getLocationAndSize(x, y, width, height);
	setLocation(0,0);
	resize();
	setThreshold(color, 255);
	if(List.get("runbatchmode")){
		if(isOpen(mask)){
			selectWindow(mask);
			wait(100);
			setBatchMode("show");
		};
	};
	set_Tool("Pencil Tool");
	waitForUser("Please draw a point in each cell with the Pencil Tool in the "+mask+".\nThis is information is used to segment cells. A Pencil Width of 5-10 is recommended.\nThe more accurate you color each cell from the inside, the better the cell segmentation will be.\nThen press OK.");
	setLocation(x,y);
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	selectWindow(mask);
	wait(100);
	setBatchMode("hide");
	if(List.get("runbatchmode")){
		if(isOpen(channel)){
			selectWindow(channel);
			setBatchMode("hide");
		};
	};
	selectWindow(mask);
	wait(100);
	color=getValue("foreground.color");
	color=color-1;
	setThreshold(color, 255);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Voronoi", "stack");
	setThreshold(1, 255);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Invert", "stack");
	run("Divide...", "value=255 stack");
	setMinAndMax(0, 1);
	wait(100);
	imageCalculator("Multiply stack",modifymask, mask);
	if(isOpen(mask)){
		selectWindow(mask);
		wait(100);
		close();
	};
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
};
function output_multiexperimentresults(){
	run("Set Measurements...", "  mean standard redirect=None decimal=3");
	run("Clear Results");
	if(Exptype==0){
		closeimages();
		for(ex=0;ex<Atoanal.length;ex++){
			channelno=Atoanal[ex];
			channelname=Achnames[channelno];
			tablename="All ROI measurement Results";
			plottitle="All ROI "+channelname+" measurement Results";
			Acolumnname=add_strings_to_array(msAorigtitle,""," "+Awindownames[channelno]);
			plot_final_results(tablename,plottitle,"ROI number",Acolumnname,msAorigtitle,msAROI,"ROI","ROI "+channelname+" "+List.get("Measure")+" intensity");
		};
		run("Clear Results");
		print_in_results("Experiment number",msAExperimentnumber);
		print_in_results("Frames",msAframes);
		print_in_results("ROIs",msAROI);
		for(ex=0;ex<Atoanal.length;ex++){
			channelno=Atoanal[ex];
			channelname=Achnames[channelno];
			print_in_results("Mean "+channelname+" amplitude change [%]",extract_array2(msAmean,ex,maxseriesnumber));
			print_in_results("Mean StdDev "+channelname+" amplitude change [%]",extract_array2(msAmeanSD,ex,maxseriesnumber));
			print_in_results("Mean StdErr "+channelname+" amplitude change [%]",extract_array2(msAmeanSDE,ex,maxseriesnumber));
			print_in_results("Median "+channelname+" amplitude change [%]",extract_array2(msAmedian,ex,maxseriesnumber));
			print_in_results("IQR "+channelname+" amplitude change [%]",extract_array2(msAmedianSD,ex,maxseriesnumber));
		};
		if(List.get("saveanalysis"))saveresults("Experiment "+origtitle2+" overview",dir_saveorig);
		for(ex=0;ex<Atoanal.length;ex++){
			channelno=Atoanal[ex];
			channelname=Achnames[channelno];
			if(calMean(extract_array2(msAmean,ex,maxseriesnumber))!=0)PlotRArray(msAorigtitle,msAExperimentnumber,extract_array2(msAmean,ex,maxseriesnumber),extract_array2(msAmeanSDE,ex,maxseriesnumber),"Plot mean "+channelname+" of each experiment "+fromCharCode(177)+" SDE","Experiment number","Mean "+channelname+""," ",dir_saveorig);
			if(calMean(extract_array2(msAmedian,ex,maxseriesnumber))!=0)PlotRArray(msAorigtitle,msAExperimentnumber,extract_array2(msAmedian,ex,maxseriesnumber),extract_array2(msAmedianSD,ex,maxseriesnumber),"Plot median "+channelname+" of each experiment "+fromCharCode(177)+" IQR","Experiment number","Median "+channelname+""," ",dir_saveorig);
		};
		for(r=0;r<maxseriesnumber;r++){
			expno=r+1;
			print("Experiment number "+expno+": "+msAorigtitle[r]+" - results were saved in folder: "+msAsavepath[r]);
		};
		fullpath=dir_saveorig+"Experiment "+origtitle2+" No overview"+".txt";
		selectWindow("Log");
		wait(100);
		if(List.get("saveanalysis"))saveAs("Text", fullpath);
	};
	if(Exptype==1){
		closeimages();
		stimulustoplotsx=false;
		for(ex=0;ex<Atoanal.length;ex++){
			channelno=Atoanal[ex];
			channelname=Achnames[channelno];
			if(!List.get("onecellexp")){
				tablename="All mean "+Awindownames[channelno]+" "+norm+List.get("Measure")+" traces of "+origtitle2;
				Acolumnname=add_strings_to_array(msAorigtitle,""+norm+List.get("Measure"),".");
				plot_final_results(tablename,tablename,"Time [s]",Acolumnname,msAorigtitle,msAframes,"Time [s]",""+norm+List.get("Measure")+" "+channelname+" intensity");
				plottitle="All mean "+Awindownames[channelno]+" "+List.get("Measure")+" traces of "+origtitle2;
				Acolumnname=add_strings_to_array(msAorigtitle,""+List.get("Measure"),".");
				plot_final_results(tablename,plottitle,"Time [s]",Acolumnname,msAorigtitle,msAframes,"Time [s]",""+List.get("Measure")+" "+channelname+" intensity");
				tablename="All median "+Awindownames[channelno]+" "+norm+List.get("Measure")+" traces of "+origtitle2;
				Acolumnname=add_strings_to_array(msAorigtitle,""+norm+List.get("Measure"),".");
				plot_final_results(tablename,tablename,"Time [s]",Acolumnname,msAorigtitle,msAframes,"Time [s]",""+norm+List.get("Measure")+" "+channelname+" intensity");
				plottitle="All median "+Awindownames[channelno]+" "+List.get("Measure")+" traces of "+origtitle2;
				Acolumnname=add_strings_to_array(msAorigtitle,""+List.get("Measure"),".");
				plot_final_results(tablename,plottitle,"Time [s]",Acolumnname,msAorigtitle,msAframes,"Time [s]",""+List.get("Measure")+" "+channelname+" intensity");
			};
			if(List.get("onecellexp")){
				for(ROIno=0;ROIno<parseFloat(List.get("ROIstoremember"));ROIno++){
					ROI=ROIno+1;
					if(calMax(msAROI)>=ROI){
						tablename="All "+List.get("Measure")+" "+Awindownames[channelno]+" single ROI traces of "+origtitle2;
						Acolumnname=add_strings_to_array(msAorigtitle,""+norm+"ROI "+ROI+" of ",".");
						plottitle="ALL "+List.get("Measure")+" ROI "+ROI+" "+Awindownames[channelno]+" single ROI traces of "+origtitle2;
						plot_final_results(tablename,plottitle,"Time [s]",Acolumnname,msAorigtitle,msAframes,"Time [s]","ROI"+ROI+" "+List.get("Measure")+" "+channelname+" intensity");		
					};
				};
			};
		};
		if(stimulustoplots){
			stimulustoplots=false;stimulustoplotsx=true;	
		};
		run("Clear Results");
		print_in_results("Experiment number",msAExperimentnumber);
		print_in_results("Number of Slices",msAframes);
		print_in_results("Number of ROIs",msAROI);
		if(stimulation){
			for(ex=0;ex<Atoanal.length;ex++){
				channelno=Atoanal[ex];
				channelname=Achnames[channelno];
				if(!List.get("onecellexp")){
					print_in_results("Mean "+channelname+" amplitude change [%]",extract_array2(msAmeanFRETchange,ex,maxseriesnumber));
					print_in_results("Mean StdDev "+channelname+" amplitude change [%]",extract_array2(msASDmeanFRETchange,ex,maxseriesnumber));
					print_in_results("Mean StdErr "+channelname+" amplitude change [%]",extract_array2(msASDEmeanFRETchange,ex,maxseriesnumber));
					print_in_results("Median "+channelname+" amplitude change [%]",extract_array2(msAmedianFRETchange,ex,maxseriesnumber));
					print_in_results("IQR "+channelname+" amplitude change [%]",extract_array2(msASDmedianFRETchange,ex,maxseriesnumber));					
				};
				if(List.get("onecellexp")){
					for(ROIno=0;ROIno<parseFloat(List.get("ROIstoremember"));ROIno++){
						ROI=ROIno+1;
						if(calMax(msAROI)>=ROI){
							print_in_results(""+channelname+" change ROI "+ROI+" [%]",extract_array(msAROIFRETchange,ROIno,ex,parseFloat(List.get("ROIstoremember")),maxseriesnumber));			
						};
					};
				};
			};
		};
		if(List.get("saveanalysis"))saveresults("Experiment "+origtitle2+" overview",dir_saveorig);
		for(r=0;r<msAorigtitle.length;r++){
			expno=r+1;
			print("Experiment number "+expno+": "+msAorigtitle[r]+" - results were saved in folder: "+msAsavepath[r]);
		};
		fullpath=dir_saveorig+"Experiment "+origtitle2+" No overview"+".txt";
		selectWindow("Log");
		if(List.get("saveanalysis"))saveAs("Text", fullpath);
		if(stimulation){
			for(ex=0;ex<Atoanal.length;ex++){
				channelno=Atoanal[ex];
				channelname=Achnames[channelno];
				if(!List.get("onecellexp")){
					if(calMean(extract_array2(msAmeanFRETchange,ex,maxseriesnumber))!=0)PlotRArray(msAorigtitle,msAExperimentnumber,extract_array2(msAmeanFRETchange,ex,maxseriesnumber),extract_array2(msASDmeanFRETchange,ex,maxseriesnumber),"Plot Mean "+fromCharCode(177)+" SDE "+channelname+" change overview","Experiment number","Mean "+channelname+" amplitude change [%]"," ",dir_saveorig);
					if(calMean(extract_array2(msAmedianFRETchange,ex,maxseriesnumber))!=0)PlotRArray(msAorigtitle,msAExperimentnumber,extract_array2(msAmedianFRETchange,ex,maxseriesnumber),extract_array2(msASDmedianFRETchange,ex,maxseriesnumber),"Plot Median "+fromCharCode(177)+" IQR "+channelname+" change overview","Experiment number","Median "+channelname+" amplitude change [%]"," ",dir_saveorig);
					if(Atoanal.length==2&&ex==0){
						if(calMean(extract_array2(msAmeanFRETchange,0,maxseriesnumber))!=0&&calMean(extract_array2(msAmeanFRETchange,1,maxseriesnumber))!=0)Plot2RArray(msAorigtitle,msAExperimentnumber,extract_array2(msAmeanFRETchange,0,maxseriesnumber),extract_array2(msASDmeanFRETchange,0,maxseriesnumber),""+Achnames[Atoanal[0]],extract_array2(msAmeanFRETchange,1,maxseriesnumber),extract_array2(msASDmeanFRETchange,1,maxseriesnumber),""+Achnames[Atoanal[1]],"Plot "+Achnames[Atoanal[0]]+" and "+Achnames[Atoanal[1]]+"-Mean "+fromCharCode(177)+" StdErr amplitude change overview","Experiment number","Mean amplitude change [%]"," ",dir_saveorig);		
						if(calMean(extract_array2(msAmedianFRETchange,0,maxseriesnumber))!=0&&calMean(extract_array2(msAmedianFRETchange,1,maxseriesnumber))!=0)Plot2RArray(msAorigtitle,msAExperimentnumber,extract_array2(msAmedianFRETchange,0,maxseriesnumber),extract_array2(msASDmedianFRETchange,0,maxseriesnumber),""+Achnames[Atoanal[0]],extract_array2(msAmedianFRETchange,1,maxseriesnumber),extract_array2(msASDmedianFRETchange,1,maxseriesnumber),""+Achnames[Atoanal[1]],"Plot "+Achnames[Atoanal[0]]+" and "+Achnames[Atoanal[1]]+"-Median "+fromCharCode(177)+" IQR amplitude change overview","Experiment number","Median amplitude change [%]"," ",dir_saveorig);		
					};
				};
				if(List.get("onecellexp")){
					for(ROIno=0;ROIno<parseFloat(List.get("ROIstoremember"));ROIno++){
						ROI=ROIno+1;
						if(calMax(msAROI)>=ROI){
							if(calMean(extract_array(msAROIFRETchange,ROIno,ex,parseFloat(List.get("ROIstoremember")),maxseriesnumber))!=0)PlotRArray(msAorigtitle,msAExperimentnumber,extract_array(msAROIFRETchange,ROIno,ex,parseFloat(List.get("ROIstoremember")),maxseriesnumber),extract_array(msAROIFRETchangeSD,ROIno,ex,parseFloat(List.get("ROIstoremember")),maxseriesnumber),"Plot ROI "+ROI+" "+channelname+" change overview","Experiment number",""+channelname+" amplitude change [%]"," ",dir_saveorig);
						};
						if(Atoanal.length==2&&ex==0){
							if(calMean(extract_array(msAROIFRETchange,ROIno,0,parseFloat(List.get("ROIstoremember")),maxseriesnumber))!=0&&calMean(extract_array(msAROIFRETchange,ROIno,1,parseFloat(List.get("ROIstoremember")),maxseriesnumber))!=0)Plot2RArray(msAorigtitle,msAExperimentnumber,extract_array(msAROIFRETchange,ROIno,0,parseFloat(List.get("ROIstoremember")),maxseriesnumber),extract_array(msAROIFRETchangeSD,ROIno,0,parseFloat(List.get("ROIstoremember")),maxseriesnumber),""+Achnames[Atoanal[0]]+" ROI "+ROI,extract_array(msAROIFRETchange,ROIno,1,parseFloat(List.get("ROIstoremember")),maxseriesnumber),extract_array(msAROIFRETchangeSD,ROIno,1,parseFloat(List.get("ROIstoremember")),maxseriesnumber),""+Achnames[Atoanal[1]]+" ROI "+ROI,"Plot ROI "+ROI+" "+Achnames[Atoanal[0]]+" and "+Achnames[Atoanal[1]]+"-intensity change overview","Experiment number","Amplitude change [%]"," ",dir_saveorig);	
						};
					};
				};
			};
		};
		if(stimulustoplotsx)stimulustoplots=true;
	};
};
function save_windows(){
	if(isOpen(thresholdpic)){
		selectWindow(thresholdpic);
		wait(100);
		roiManager("Show All with labels");
		fullpath=dir_save+thresholdpic+".tif";
		if(List.get("savemask")){
			showStatus("Saving... "+thresholdpic);
			saveAs("Tiff", fullpath);
		};
		close();
	};
	if(isOpen(thresholdmask)){
		selectWindow(thresholdmask);
		wait(100);
		roiManager("Show All with labels");
		fullpath=dir_save+thresholdmask+".tif";
		if(List.get("savemask")){
			showStatus("Saving... "+thresholdmask);
			saveAs("Tiff", fullpath);
		};
		close();
	};
	for(chno=0;chno<Atoanal.length;chno++){
		ch=Atoanal[chno];
		if(isOpen(Awindownames[ch])){
			selectWindow(Awindownames[ch]);
			wait(100);
			roiManager("Show All with labels");
			fullpath=dir_save+Awindownames[ch]+".tif";
			if(List.get("save32")){
				showStatus("Saving... "+Awindownames[ch]);
				saveAs("Tiff", fullpath);
			};
			run("Rename...", "title=["+Awindownames[ch]+"]");
			if(List.get("save8")){
				resize();
				selectWindow(Awindownames[ch]);
				wait(100);
				channelc=Awindownames[ch]+"-scaled 8-bit";
				run("Select None");
				run("Duplicate...", "title=["+channelc+"] duplicate range=1-["+frames+"]");
				resize();
				if(isOpen(channelc)){
					run("Conversions...", "scale");
					run("8-bit");
					run("Conversions...", " ");
					run("Fire");
					if(Exptype==1)timeandscaleadder(channelc,parseFloat(List.get("spf")));
					roiManager("Show All with labels");
					fullpath=dir_save+channelc+".tif";
					if(List.get("save8")){
						showStatus("Saving... "+channelc);
						saveAs("Tiff", fullpath);
					};
					if(List.get("cls"))close();
				};
			};
			if(List.get("cls"))close();	
		};
	};
	for(ch=0;ch<Awindownames.length;ch++){
		if(isOpen(Awindownames[ch])){
			selectWindow(Awindownames[ch]);
			wait(100);
			close();
		};
	};
};
function analyze_exptype0(channelname){
	selectWindow(channelname);
	wait(100);
	resize();
	getLocationAndSize(x, y, width, height);
	setLocation(0,0);
	run("Clear Results");
	frames=nSlices;
	run("Clear Results");
	amountrois=roiManager("count");
	Aamountrois=newArray(frames);
 	icAresults=newArray(Atoanal.length*amountrois);
	icASliceinfo=newArray(amountrois);
	icAresultsno=newArray(amountrois);
	Asubtitle=newArray(amountrois);
	Aarea=newArray(amountrois);
	icASD=newArray(Atoanal.length*amountrois);
	if(amountrois>0){
		counter=0;
		for(channelno=0;channelno<Atoanal.length;channelno++){
			ex=Atoanal[channelno];	
			if(isOpen(Awindownames[ex])){
				setmeasure="mean";
				for(i=0;i<Ameasure.length;i++){
					if(List.get("Measure")==Ameasure[i])setmeasure=Asetmeasure[i];
				};
				setmeasureString=get_SetMeasurementString();
				run("Set Measurements...", ""+setmeasureString+" standard stack redirect=["+Awindownames[ex]+"] decimal=3");
				run("Select None");
				run("Clear Results");
				roiManager("Deselect");
				roiManager("Show All");
				roiManager("Measure");
				selectWindow("Results");
				if(List.get("CellClassification")){
					print_in_results("ROI Class",AclassROIs);
				};
				plotname="Single ROI results "+Awindownames[ex];
				fullpath=dir_save+"Table-"+plotname+".xls";
				if(List.get("saveanalysis"))saveAs("Results", fullpath);
				for(ROIno =0; ROIno < nResults; ROIno++){//amountrois
					icAresults[ROIno+channelno*amountrois]=getResult(List.get("Measure"), ROIno);
					icASD[ROIno+channelno*amountrois]=getResult("StdDev", ROIno);
					if(channelno==0){
						counter++;
						Aarea[ROIno+channelno*amountrois]=getResult("Area", ROIno);
						slice=getResult("Slice", ROIno)-1;
						icASliceinfo[ROIno+channelno*amountrois]=getResult("Slice", ROIno);
						Aamountrois[slice]++;
						icAresultsno[ROIno]=counter;
								
					};
				};
				if(!List.get("seriesgrouping")){
					write_in_resultstring2(date,Awindownames[ex],icAresultsno,icASliceinfo,Asubtitle,extract_array2(icAresults,channelno,amountrois));
				};
				if(List.get("seriesgrouping")){
					Asubtitle=get_subtitlearray(channelname,icASliceinfo);
					write_in_resultstring2(date,Awindownames[ex],icAresultsno,icASliceinfo,Asubtitle,extract_array2(icAresults,channelno,amountrois));
				};
			};
		};
	};
//Measure numbers and results
	run("Set Measurements...", "  mean standard redirect=None decimal=3");
	run("Clear Results");
	if(List.get("saveanalysis")){
		//count=count/Atoanal.length;
		cASliceinfo=icASliceinfo;//Array.trim(icASliceinfo, count);
		cAresultsno=icAresultsno;//Array.trim(icAresultsno, count);
		mean=newArray(Atoanal.length);
		SDmean=newArray(Atoanal.length);
		SDEmean=newArray(Atoanal.length);
		median=newArray(Atoanal.length);
		SDmedian=newArray(Atoanal.length);
		minimum=newArray(Atoanal.length);
		maximum=newArray(Atoanal.length);
		for(channelno=0;channelno<Atoanal.length;channelno++){
			ex=Atoanal[channelno];
			if(cAresultsno.length>0){
				if(List.get("saveanalysis")){
					cAresultsnoname=add_strings_to_array(cAresultsno,"ROI ","");
					PlotRArray(cAresultsnoname,cAresultsno,extract_array2(icAresults,channelno,amountrois),extract_array2(icASD,channelno,amountrois),"Barplot overview of single ROI measurements of "+Awindownames[ex]+" "+fromCharCode(177)+" SD","ROI",""+List.get("Measure"),List.get("origtitle"),dir_save);
					if(amountrois>1)PlotArray(cAresultsno,extract_array2(icAresults,channelno,amountrois),extract_array2(icASD,channelno,amountrois),"Lineplot overview of single ROI measurements of "+Awindownames[ex]+" "+fromCharCode(177)+" SD","ROI",""+List.get("Measure"),List.get("origtitle"),dir_save);
				};
				print_in_results("ROI No",cAresultsno);
				print_in_results("ROI from slice",cASliceinfo);
				if(List.get("CellClassification")){
					print_in_results("ROI Class",AclassROIs);
				};
				print_in_results("Mean of "+Awindownames[ex],extract_array2(icAresults,channelno,amountrois));
				print_in_results("StdDev of "+Awindownames[ex],extract_array2(icASD,channelno,amountrois));
			};
		};
		if(cAresultsno.length>0){
			saveresults("Table of single ROI measurements",dir_save);
		};
		print("\\Clear");
		for(channelno=0;channelno<Atoanal.length;channelno++){
			ex=Atoanal[channelno];
			if(cAresultsno.length>0){
				mean[channelno]=calMean(extract_array2(icAresults,channelno,amountrois));
				SDmean[channelno]=calSD(extract_array2(icAresults,channelno,amountrois));
				SDEmean[channelno]=calSDE(extract_array2(icAresults,channelno,amountrois));
			};
			if(cAresultsno.length>3){
				median[channelno]=calMedian(extract_array2(icAresults,channelno,amountrois));
				SDmedian[channelno]=calQuartilsdiff(extract_array2(icAresults,channelno,amountrois));
				minimum[channelno]=calMin(extract_array2(icAresults,channelno,amountrois));
				maximum[channelno]=calMax(extract_array2(icAresults,channelno,amountrois));
			};
			if(cAresultsno.length<=3){
				median[channelno]=0;SDmedian[channelno]=0;minimum[channelno]=0;maximum[channelno]=0;		
			};
			if(cAresultsno.length<1){
				mean[channelno]=0;SDmean[channelno]=0;SDEmean[channelno]=0;
				print("Pictures in folder "+dir_save+" were not fully processed. Only mean values were recorded. Not enough ROIs to measure Median and Standard deviation."); 
				print(" ");
				fullpath=dir_save+"Error message.txt";
				selectWindow("Log");
				saveAs("Text", fullpath);	
			};
			print("Results of "+Awindownames[ex]);
			print("Total mean = "+mean[channelno]+" "+fromCharCode(177)+" "+SDmean[channelno]);
			print("Total median = "+median[channelno]+" "+fromCharCode(177)+" "+SDmedian[channelno]);
			print("Total minimum = "+minimum[channelno]);
			print("Total maximum = "+maximum[channelno]);
			print("Total StdErr = "+SDEmean[channelno]);
			print(" ");
			for(z=0;z<frames;z++){
				print("Slice "+ASlice[z]+" - "+Aamountrois[z]+" ROIs");	
			};
			if(maxseriesnumber>1){
		 		if(cAresultsno.length>0){
		 			run("Clear Results");
		 			tablename="All ROI measurement Results";
		 			Path=dir_saveorig+tablename+".xls";
					if(File.exists(Path))open(Path);
		 			print_in_results_nocheck("ROI number",cAresultsno);
		 			print_in_results_nocheck(""+List.get("origtitle")+" "+Awindownames[ex],extract_array2(icAresults,channelno,amountrois));
		 			print_in_results_nocheck("StdDev-Exp"+loop+" "+Awindownames[ex],extract_array2(icASD,channelno,amountrois));
		 			if(isOpen("Results")){
		 				selectWindow("Results");
		 				saveAs("Results", Path);
		 			};
					run("Clear Results");
		 		};
	 			msAorigtitle[loopp]=List.get("origtitle");
				msAExperimentnumber[loopp]=loop;
				msAframes[loopp]=frames;
				msAsavepath[loopp]=dir_save;
				msAROI[loopp]=cAresultsno.length;
				msAmean[loopp+channelno*maxseriesnumber]=mean[channelno];
				msAmeanSD[loopp+channelno*maxseriesnumber]=SDmean[channelno];
				msAmeanSDE[loopp+channelno*maxseriesnumber]=SDEmean[channelno];
				msAmedian[loopp+channelno*maxseriesnumber]=median[channelno];
				msAmedianSD[loopp+channelno*maxseriesnumber]=SDmedian[channelno];
			};
		};
		if(cAresultsno.length>0){
			Atitle=newArray(Atoanal.length);
			xValues=newArray(Atoanal.length);
			for(channelno=0;channelno<Atoanal.length;channelno++){
				ex=Atoanal[channelno];
				chno=channelno+1;
				xValues[channelno]=chno;
				Atitle[channelno]=Awindownames[ex];
			};
			PlotRArray(Atitle,xValues,mean,SDmean,"Overview Mean of all ROIs "+fromCharCode(177)+" SD","Channel","Mean intensity",List.get("origtitle"),dir_save);
			if(cAresultsno.length>3)PlotRArray(Atitle,xValues,median,SDmedian,"Overview Median of all ROIs "+fromCharCode(177)+" IQR","Channel","Mean intensity",List.get("origtitle"),dir_save);
		};
		if(List.get("CellClassification")){
			print(" ");
			print("Results for cell classification:");
			print("############################################");
			for(channelno=0;channelno<Atoanal.length;channelno++){
				ex=Atoanal[channelno];
				print("Classification results for "+Awindownames[ex]+":");
				print("============================================");
				Aclasses2=Array.concat("not classified",Aclasses);
				Aanalclasses=newArray(Aclasses2.length);
				AmeanclassROI=newArray(Aclasses2.length);
				ASDEclassROI=newArray(Aclasses2.length);
				ASDclassROI=newArray(Aclasses2.length);
				for(class=0;class<Aclasses2.length;class++){
					Aanalclasses[class]=class+1;
					classNo=0;
					Aclassvalues=newArray();
					for(ROIno =0; ROIno < nResults; ROIno++){
						if(AclassROIs[ROIno]==Aclasses2[class]){
							Aclassvalues=Array.concat(Aclassvalues,icAresults[ROIno+channelno*amountrois]);
							classNo++;
						};
					};
					Aclasses2[class]=""+Aclasses2[class]+" - "+classNo+" ROIs";
					print("Class: "+Aclasses2[class]);
					print("____________________________________________");
					AmeanclassROI[class]=calMean(Aclassvalues);
					print("Mean: "+AmeanclassROI[class]);
					ASDclassROI[class]=calSD(Aclassvalues);
					print("SD: "+ASDclassROI[class]);
					ASDEclassROI[class]=calSDE(Aclassvalues);
					print("SDE: "+ASDEclassROI[class]);
					print(" ");
				};
				PlotRArray(Aclasses2,Aanalclasses,AmeanclassROI,ASDEclassROI,"Overview Mean of classified "+Awindownames[ex]+" ROIs "+fromCharCode(177)+" SDE","Class","Mean intensity",List.get("origtitle"),dir_save);
			};
		};
		fullpath=dir_save+List.get("origtitle")+"-ROI measurement Results.txt";
		selectWindow("Log");
		if(List.get("saveanalysis"))saveAs("Text", fullpath);
	};
};
function get_subtitlearray(channel,ASliceinfo){
	selectWindow(channel);
	wait(100);
	Asubtitlearray=newArray(ASliceinfo.length);
	ASub=newArray(nSlices);
	for(i=0;i<nSlices;i++){
		setSlice(i+1);
		subtitle=getInfo("image.subtitle");
		subtitle=checkforcertainchar(subtitle);
		ASub[i]=subtitle;
	};
	for(i=0;i<ASliceinfo.length;i++){
		j=ASliceinfo[i]-1;
		Asubtitlearray[i]=ASub[j];
	};
	return Asubtitlearray;
};
function check_spf(){
	spf_detect=Stack.getFrameInterval();
	spf=parseFloat(List.get("spf"));
	difference=abs(spf_detect-spf)/spf;
	if(difference>0.08&&spf_detect!=0){
		Dialog.create("Different frame rate detected. "+macroinfo);
		Dialog.addMessage("A different frame interval for your time stack was detected.\n(A click on 'Cancel' aborts the macro.)");
		Dialog.addMessage("You set: "+spf+" sec per frame.");
		Dialog.addMessage("Detected: "+spf_detect+" sec per frame.");
		Dialog.addNumber("New frame interval (s):", spf_detect);
		Dialog.show();
		List.set("spf",Dialog.getNumber());
	};	
};
function print_all_in_results(AallROIs,Atoanal,Awindownames,Achnames,dir_save,origtitle){
	Acells=newArray(amountrois);
	for(f=0;f<amountrois;f++){
		Acells[f]=f+1;	
	};
	run("Clear Results");
	print_in_results("Slice no",ASlice);
	print_in_results("Time [s]",Atime);
	for(ex=0;ex<Atoanal.length;ex++){
		channelno=Atoanal[ex];
		print_channel_in_results(AallROIs,Awindownames[channelno],Achnames[channelno],ex);
	};
	if(amountrois>0&&(stimulation)){
		print_in_results("Cell ROI No",Acells);
		if(List.get("CellClassification")){
			print_in_results("ROI classification",AclassROIs);
		};
		for(ex=0;ex<Atoanal.length;ex++){
			channelno=Atoanal[ex];
			if(stimulation)print_channel_in_results2(AallROIs,Awindownames[channelno],Achnames[channelno],ex);
		};
	};
	fullpath=dir_save+"Resultstable of "+origtitle+".xls";
	selectWindow("Results");
	if(List.get("saveanalysis"))saveAs("Results", fullpath);					
};
function extract_array2(array,channelno,rows){//[x+y*xmax]
	if(array.length<channelno*rows)exit("Mistake occured. Array is not long enough for multiple dimensions!");
	sarray=newArray(rows);
	for(i=0;i<rows;i++){
		sarray[i]=array[i+channelno*rows];	
	};
	return sarray;
};
function extract_array3(array,channelno,rows,maxrows){//[x+y*xmax]
	if(array.length<channelno*rows)exit("Mistake occured. Array is not long enough for multiple dimensions!");
	sarray=newArray(rows);
	for(i=0;i<rows;i++){
		sarray[i]=array[i+channelno*maxrows];	
	};
	return sarray;
};
function extract_array(array,ROIno,channelno,amountrois,frames){//[x+y*xmax+z*xmax*ymax]
	if(array.length<channelno*amountrois*frames)exit("Mistake occured. Array is not long enough for multiple dimensions!");
	sarray=newArray(frames);
	for(slice=0;slice<frames;slice++){
		sarray[slice]=array[slice+ROIno*frames+channelno*amountrois*frames];			
	};
	return sarray;
};
function print_channel_in_results(AallROIs,windowstitle,channelname,channelno){
	if(!List.get("onecellexp")){
		print_in_results("Mean of "+channelname,extract_array2(Amean,channelno,frames));
		if(amountrois>1)print_in_results("StdDev of "+channelname,extract_array2(ASD,channelno,frames));
		if(amountrois>1)print_in_results("StdErr of "+channelname,extract_array2(ASDE,channelno,frames));
		if(stimulation){
			print_in_results("Norm.Mean of "+channelname,extract_array2(Anormmean,channelno,frames));
			if(amountrois>1)print_in_results("Norm.StdDev of "+channelname,extract_array2(AnormSD,channelno,frames));
			if(amountrois>1)print_in_results("Norm.StdErr of "+channelname,extract_array2(AnormSDE,channelno,frames));
		};
		if(amountrois>2){
			print_in_results("Median of "+channelname,extract_array2(Amedian,channelno,frames));
			print_in_results("IQR of "+channelname,extract_array2(ASDM,channelno,frames));
			print_in_results("Maximum of "+channelname,extract_array2(Amax,channelno,frames));
			print_in_results("Minimum of "+channelname,extract_array2(Amin,channelno,frames));
			if(stimulation){
				print_in_results("Norm.Median of "+channelname,extract_array2(Anormmedian,channelno,frames));
				print_in_results("Norm.IQR of "+channelname,extract_array2(AnormSDM,channelno,frames));
			};
		};
	};
	if(List.get("onecellexp")){
		for(ROIno=0;ROIno<amountrois;ROIno++){
			c=ROIno+1;
			ROI="ROI No "+c;
			print_in_results(""+ROI+" mean of "+channelname,extract_array(AallROIs,ROIno,channelno,amountrois,frames));
			print_in_results(""+ROI+" mean SD of "+channelname,extract_array(AallROIsSD,ROIno,channelno,amountrois,frames));	
		};
	};
};
function print_channel_in_results2(AallROIs,windowstitle,channelname,channelno){
	print_in_results(""+channelname+"-amplitude change [%]",extract_array2(AFRETsc,channelno,amountrois));
	if(List.get("Fitequations")){
		for(q=0;q<AParametersc.length-1;q++){
			if(q==0)print_in_results("Fit parameter a of "+channelname,extract_array2(AParametera,channelno,amountrois));
			if(q==1)print_in_results("Fit parameter b of "+channelname,extract_array2(AParameterb,channelno,amountrois));
			if(q==2)print_in_results("Fit parameter c of "+channelname,extract_array2(AParameterc,channelno,amountrois));
			if(q==3)print_in_results("Fit parameter d of "+channelname,extract_array2(AParameterd,channelno,amountrois));
		};
		print_in_results("R^2 of "+channelname,extract_array2(AParameterR,channelno,amountrois));			
	};
};
function print_mean_amplitude_changes(AFRETsc,Atoanal,Awindownames,Achnames,dir_save,origtitle){
	meanFRETchange=newArray(Atoanal.length);
	SDmeanFRETchange=newArray(Atoanal.length);
	SDEmeanFRETchange=newArray(Atoanal.length);
	medianFRETchange=newArray(Atoanal.length);
	SDmedianFRETchange=newArray(Atoanal.length);
	for(ex=0;ex<Atoanal.length;ex++){
		channelno=Atoanal[ex];
		print_mean_amplitude_changes_per_channel(AFRETsc,Awindownames[channelno],Achnames[channelno],channelno,ex);
		if(List.get("saveFRETratio"))FRETpiccalc(dir_save,"Image - "+Achnames[channelno]+"-change per pixel",Awindownames[channelno],parseFloat(List.get("Stimulusafterframe")),parseFloat(List.get("Equilibrationtime")),FRETcalcchoice,AFRETsc[0+ex*amountrois],parseFloat(List.get("stopafterframe")));
	};
	if(!List.get("onecellexp")){
		fullpath=dir_save+"Mean Amplitude change results of "+origtitle+".txt";	
		selectWindow("Log");
		if(List.get("saveanalysis"))saveAs("Text", fullpath);
	};
	print("\\Clear");
};
function print_mean_amplitude_changes_per_channel(AFRETsc,windowstitle,channelname,channelno,ex){
	if(!List.get("onecellexp")){
		if(amountrois==1){
			meanFRETchange[ex]=AFRETsc[0+ex*amountrois];
			SDmeanFRETchange[ex]=0;	
			SDEmeanFRETchange[ex]=0;					
		};
		if(amountrois>=2){
			meanFRETchange[ex]=calMean(extract_array2(AFRETsc,ex,amountrois));
			SDmeanFRETchange[ex]=calSD(extract_array2(AFRETsc,ex,amountrois));	
			SDEmeanFRETchange[ex]=calSDE(extract_array2(AFRETsc,ex,amountrois));		
		};
		meanFRETchangeno=d2s(meanFRETchange[ex],2);	
		SDmeanFRETchangeno=d2s(SDmeanFRETchange[ex],2);
		SDEmeanFRETchangeno=d2s(SDEmeanFRETchange[ex],2);
		print(""+channelname+"-change results of "+List.get("origtitle"));
		print(""+channelname+"-change for each ROI was calculated in the following way:");
		if(FRETcalcchoice==1){
			print("Baseline = Average "+List.get("Measure")+" intensity of first "+List.get("Stimulusafterframe")+" frames");
			print("Response = Average "+List.get("Measure")+" intensity of last frames (frames "+List.get("Decaystart")+" - "+List.get("stopafterframe")+")");
			print(""+channelname+"-amplitude change = (Baseline - Response)*100 / Baseline");
			print("The Overall "+channelname+"-changes were either calculated from the mean or from the median of all single cell measurements.");
			print(" ");
		};
		if(FRETcalcchoice==2){
			print("Prediction frame = Frame of Stimulation+Equilibrationtime = "+List.get("Decaystart"));
			print("Baseline = y-Value of a Straight line fit for the first "+List.get("Stimulusafterframe")+" frames at Position "+List.get("Decaystart"));
			print("Response = y-Value of a Straight line fit for the last frames (frames "+List.get("Decaystart")+" - "+List.get("stopafterframe")+") at Position "+List.get("Decaystart"));
			print(""+channelname+"-amplitude change = (Baseline - Response)*100 / Baseline");
			print("The Overall "+channelname+"-changes were either calculated from the mean or from the median of all single cell measurements.");
			print(" ");
		};
		if(FRETcalcchoice==3){
			print("Baseline = Average "+List.get("Measure")+" intensity of first "+List.get("Stimulusafterframe")+" frames");
			print("Response = Maximal or minimal observed "+List.get("Measure")+" intensity of last frames (frames "+List.get("Decaystart")+" - "+List.get("stopafterframe")+")");
			print(""+channelname+"-amplitude change = (Baseline - Response)*100 / Baseline");
			print("The Overall "+channelname+"-changes were either calculated from the mean or from the median of all single cell measurements.");
			print(" ");
		};
		print("Mean overall "+channelname+"-change: "+meanFRETchangeno+" "+fromCharCode(177)+" "+SDmeanFRETchangeno+" % (StdDev)");
		print("Mean overall "+channelname+"-change: "+meanFRETchangeno+" "+fromCharCode(177)+" "+SDEmeanFRETchangeno+" % (StdErr)");
		if(amountrois>2){
			medianFRETchange[ex]=calMedian(extract_array2(AFRETsc,ex,amountrois));
			medianFRETchangeno=d2s(medianFRETchange[ex],2);
			SDmedianFRETchange[ex]=calQuartilsdiff(extract_array2(AFRETsc,ex,amountrois));
			SDmedianFRETchangeno=d2s(SDmedianFRETchange[ex],2);
			print("Median overall "+channelname+"-change: "+medianFRETchangeno+" "+fromCharCode(177)+" "+SDmedianFRETchangeno+" % (IQR)");	
			print("___________________________________________________________________________________");	
		};
	};
};
function plot_all_channels(Atoanal,Awindownames,Achnames,dir_save,origtitle){
	do_norm=true;
	for(ex=0;ex<Atoanal.length;ex++){
		channelno=Atoanal[ex];
		plot_channel_graphs(Awindownames[channelno],Achnames[channelno],ex);
	};
	if(Atoanal.length>1){
		if(!List.get("onecellexp")){
			PlotmultipleArrays(Atime,Anormmean,AnormSDE,Awindownames,Atoanal,"Plot - channel comparison of "+List.get("Measure")+" intensity changes as mean "+fromCharCode(177)+" StdErr of all ROIs versus time","Time [s]",""+List.get("Measure")+" intensity",origtitle,dir_save,do_norm);
			if(amountrois>3){
				if(List.get("pmccor"))PlotmultipleArrays(Atime,Anormmedian,AnormSDM,Awindownames,Atoanal,"Plot - channel comparison of "+List.get("Measure")+" intensity changes as median "+fromCharCode(177)+" IQR of all ROIs versus time","Time [s]","Median intensity",origtitle,dir_save,do_norm);
			};
		};
		if(List.get("onecellexp")){
			for(ROIno=0;ROIno<amountrois;ROIno++){
				c=ROIno+1;
				ROItraces=Extract_ROItraces_allch(AallROIs,ROIno,amountrois,frames,Atoanal.length);
				ROItracesSD=newArray(ROItraces.length);
				if(List.get("pmccor"))PlotmultipleArrays(Atime,ROItraces,ROItracesSD,Awindownames,Atoanal,"Plot - channel comparison of ROI "+c+" versus time","Time [s]",""+List.get("Measure"),origtitle,dir_save,do_norm);			
			};
		};
	};
};
function plot_channel_graphs(windowstitle,channelname,channelno){
	if(!List.get("onecellexp")){
		if(List.get("pmean")){
			PlotArray(Atime,extract_array2(Amean,channelno,frames),extract_array2(ASD,channelno,frames),"Plot - "+channelname+" "+List.get("Measure")+" intensity as mean "+fromCharCode(177)+" StdDev of all ROIs versus time","Time [s]",""+List.get("Measure")+" "+channelname+" intensity",List.get("origtitle"),dir_save);			
		};
		if(List.get("pmedian")){
			if(amountrois>3)PlotMArray(Atime,extract_array2(Amedian,channelno,frames),extract_array2(ASDM,channelno,frames),extract_array2(Amax,channelno,frames),extract_array2(Amin,channelno,frames),"Plot - "+channelname+" "+List.get("Measure")+" intensity as median of all ROIs versus time","Time [s]",""+List.get("Measure")+" "+channelname+" intensity",List.get("origtitle"),dir_save);					
		};
	};
	if(List.get("onecellexp")){
		if(List.get("pocaR")){
			for(ROIno=0;ROIno<amountrois;ROIno++){
				ROI=ROIno+1;
				PlotArray(Atime,extract_array(AallROIs,ROIno,channelno,amountrois,frames),extract_array(AallROIsSD,ROIno,channelno,amountrois,frames),"Plot - ROI "+ROI+" - "+channelname+" "+List.get("Measure")+" "+fromCharCode(177)+" StdDev versus time","Time [s]",""+List.get("Measure")+" "+channelname+" intensity",List.get("origtitle"),dir_save);				
			};
		};
	};
};
function Extract_ROItraces_allch(array,ROIno,amountrois,frames,noofch){
	sarray=newArray(frames*noofch);
	for(channelno=0;channelno<noofch;channelno++){
		for(i=0;i<frames;i++){
			sarray[i+channelno*frames]=array[i+ROIno*frames+channelno*amountrois*frames];			
		};
	};
	return sarray;
};
function Extract_ROItraces_of_onechannel(array,amountrois,frames,channelno){
	sarray=newArray(frames*amountrois);
	for(ROIno=0;ROIno<amountrois;ROIno++){
		for(i=0;i<frames;i++){
			sarray[i+ROIno*frames]=array[i+ROIno*frames+channelno*amountrois*frames];			
		};
	};
	return sarray;
};
function Extract_tracestoplot(array,Atoanal,frames,Stimulusafterframe,do_norm){
	for(i=0;i<Atoanal.length;i++){
		channelno=Atoanal[i];
		Aline=extract_array2(array,i,frames);
		/*if(stimulation){
			if(do_norm)Aline=normalizebaseline(Aline,getmeantonormalize(Aline,Stimulusafterframe));
		};*/
		if(i==0)Finalarray=Aline;
		if(i>0){
			Finalarray=Array.concat(Finalarray,Aline);	
		};
	};
	return Finalarray;
};
function Extract_errorbarstoplot(array,arraySD,Atoanal,frames,Stimulusafterframe,do_norm){
	for(i=0;i<Atoanal.length;i++){
		channelno=Atoanal[i];
		Alinenorm=extract_array2(array,i,frames);
		Aline=extract_array2(arraySD,i,frames);
		/*if(stimulation){
			if(do_norm)Aline=normalizebaseline(Aline,getmeantonormalize(Alinenorm,Stimulusafterframe));
		};*/
		if(i==0)Finalarray=Aline;
		if(i>0){
			Finalarray=Array.concat(Finalarray,Aline);	
		};
	};
	return Finalarray;
};
function PlotmultipleArrays(xValues,yValues,AStdErr,Awindownames,Atoanal,plottitle,xaxis,yaxis,origtitle,dir_save,do_norm){
	Alimits=removeNaN(xValues);
	Array.getStatistics(Alimits, xMin, xMax, mean, stdDev);
	Array.getStatistics(AStdErr, min, max, mean, stdDev);
	if(max==0)Bars=false;
	if(max>0)Bars=true;
	if(Bars){
		Aerrors=Extract_errorbarstoplot(yValues,AStdErr,Atoanal,frames,parseFloat(List.get("Stimulusafterframe")),do_norm);
		Aerrors=removeNaN(Aerrors);
		Array.getStatistics(Aerrors, min, Errorbars, mean, stdDev);
	};
	
	
	Alimits=Extract_tracestoplot(yValues,Atoanal,frames,parseFloat(List.get("Stimulusafterframe")),do_norm);
	Alimits=removeNaN(Alimits);
	Array.getStatistics(Alimits, yMin, yMax, mean, stdDev);
	xMaxorig=xMax;
	xMinorig=xMin;
	xspace=abs(xMin-xMax)*0.05;
	if(Bars)yspace=abs(Errorbars*1.05);
	if(!Bars)yspace=abs(yMin-yMax)*0.05;
	xMin = xMin-xspace;xMax=xMax+xspace;yMin=yMin-yspace;yMax=yMax+yspace;
	if(plotheight/Atoanal.length<14){
		plotheight=Atoanal.length*14.2;
	};
	stringlengthes=newArray(Atoanal.length);
	for(l=0;l<2;l++){	
		heightofchar=14/plotheight;
		widthofchar=7/plotwidth;
		begincharheight=1.2*heightofchar;
		for(i=0;i<Atoanal.length;i++){
			c=Atoanal[i];
			stringlengthes[i]=lengthOf(Awindownames[c])*widthofchar;		
		};
		stringlength=calMax(stringlengthes);
		textlength=stringlength+4*widthofchar;
		textwidth=1-textlength;
		timeswider=textlength+1+widthofchar;
		if(l==0)xMax=xMax*timeswider;
		linewidth=0.05*xMaxorig;
		if(l==0){
			plotwidthnew=timeswider*plotwidth;
			plotwidth=plotwidthnew;
			
		};
	};
	Plot.create(plottitle, xaxis, yaxis);
	Plot.setFrameSize(plotwidth, plotheight);
	Plot.setLineWidth(1);
	Plot.setLimits(xMin, xMax, yMin, yMax);
	if(stimulustoplots){
		Plot.setColor("cyan");
		for(i=0;i<1000;i++){
			add=(parseFloat(List.get("Equilibrationtime"))*parseFloat(List.get("spf"))/1000)*i;
			Plot.drawLine((parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMin, (parseFloat(List.get("Stimulusafterframe"))-1)*parseFloat(List.get("spf"))+add, yMax);	
		};
	};
	col=0;
	for(line=0;line<Atoanal.length;line++){
		channelno=Atoanal[line];
		Aline=extract_array2(yValues,line,frames);
		if(Bars)AError=extract_array2(AStdErr,line,frames);
		/*if(stimulation){
			if(do_norm){
				meantonormalize=getmeantonormalize(Aline,parseFloat(List.get("Stimulusafterframe")));
				Aline=normalizebaseline(Aline,meantonormalize);
				if(Bars){
					AError=normalizebaseline(AError,meantonormalize);
				};
			};
		};*/
		if(!Bars)add_line(xValues,Aline,Acolor[col],Awindownames[channelno],line);
		if(Bars)add_line_with_errorbars(xValues,Aline,AError,Acolor[col],Awindownames[channelno],line);
		col++;
		if(col==Acolor.length)col=0;
	};
	//Captions
	setJustification("center");
	Plot.addText(plottitle, 0.5, 0);
	setJustification("left");
	Plot.addText(shortnotice, 0, 0);
	setJustification("right");
	Plot.addText(origtitle, 1, 1+2.5*heightofchar);
	if(maxseriesnumber>1){
		setJustification("left");
		Plot.addText(origtitle2, 0, 1+2.5*heightofchar);			
	};
	Plot.setLineWidth(1);
	Plot.show();
	fullpath=dir_save+plottitle+".tif";
	if(List.get("saveanalysis")==true)saveAs("Tiff", fullpath);
};
function add_line_with_errorbars(xvalues,Aline,Aerror,color,name,line){
	if(calMean(Aline)!=0){
		xvalues=Array.trim(xvalues, Aline.length);
		Plot.setColor(color);
		Plot.setLineWidth(1);
		Plot.add("line",xvalues,Aline);
		if(calMean(Aerror)!=0&&Aline.length==Aerror.length){
			for(i=0;i<xValues.length;i++){
				Plot.drawLine(xValues[i], Aline[i]-(Aerror[i]), xValues[i], Aline[i]+(Aerror[i]));	
			};
		};
		setJustification("right");
		Plot.addText(""+fromCharCode(9472,9472),1-stringlength-widthofchar,begincharheight+(line*heightofchar));
		Plot.setColor("black");
		Plot.addText(name, 1-0.5*widthofchar, begincharheight+(line*heightofchar));	
	};
};
function add_line(xvalues,Aline,color,name,line){
	if(calMean(Aline)!=0){	
		xvalues=Array.trim(xvalues, Aline.length);
		Plot.setColor(color);
		Plot.add("line",xvalues,Aline);
		setJustification("right");
		Plot.addText(""+fromCharCode(9472,9472),1-stringlength-widthofchar,begincharheight+(line*heightofchar));
		Plot.setColor("black");
		Plot.addText(name, 1-0.5*widthofchar, begincharheight+(line*heightofchar));	
	};
};
function print_in_master_results(array,arraySD,tablename,columnname){
	run("Clear Results");
	//tablename="All norm Mean ratio traces of "+origtitle2;
	Path=dir_saveorig+tablename+".xls";
	if(File.exists(Path))open(Path);
	print_in_results_nocheck("Time [s]",Atime);
	print_in_results_nocheck(""+columnname+".",array);
	print_in_results_nocheck(""+columnname+" SD",arraySD);
	if(stimulation){
		print_in_results_nocheck(""+norm+columnname+".",normalizebaseline(array,getmeantonormalize(array,parseFloat(List.get("Stimulusafterframe")))));
		print_in_results_nocheck(""+norm+columnname+" SD",normalizebaseline(arraySD,getmeantonormalize(array,parseFloat(List.get("Stimulusafterframe")))));
	};
	selectWindow("Results");
	saveAs("Results", Path);
};
function print_in_master_results_mean(array,arraySD,arraySDE,normarray,normarraySD,normarraySDE,tablename,columnname){
	run("Clear Results");
	//tablename="All norm Mean ratio traces of "+origtitle2;
	Path=dir_saveorig+tablename+".xls";
	if(File.exists(Path))open(Path);
	print_in_results_nocheck("Time [s]",Atime);
	print_in_results_nocheck(""+List.get("Measure")+columnname+".",array);
	print_in_results_nocheck(""+List.get("Measure")+columnname+" StdDev",arraySD);
	print_in_results_nocheck(""+List.get("Measure")+columnname+" StdErr",arraySDE);
	if(stimulation){
		print_in_results_nocheck(""+norm+List.get("Measure")+columnname+".",normarray);
		print_in_results_nocheck(""+norm+List.get("Measure")+columnname+" StdDev",normarraySD);
		print_in_results_nocheck(""+norm+List.get("Measure")+columnname+" StdErr",normarraySDE);
	};
	selectWindow("Results");
	saveAs("Results", Path);
};
function print_in_master_results_median(array,arraySD,normarray,normarraySD,tablename,columnname){
	run("Clear Results");
	//tablename="All norm Mean ratio traces of "+origtitle2;
	Path=dir_saveorig+tablename+".xls";
	if(File.exists(Path))open(Path);
	print_in_results_nocheck("Time [s]",Atime);
	print_in_results_nocheck(""+List.get("Measure")+columnname+".",array);
	print_in_results_nocheck(""+List.get("Measure")+columnname+" IQR",arraySD);
	if(stimulation){
		print_in_results_nocheck(""+norm+List.get("Measure")+columnname+".",normarray);
		print_in_results_nocheck(""+norm+List.get("Measure")+columnname+" IQR",normarraySD);
	};
	selectWindow("Results");
	saveAs("Results", Path);
};
function plot_final_results(tablename,plottitle,xColumname,Acolumnname,msAorigtitle,Atracelength,xaxis,yaxis){
	//xaxis ="Time [s]";
	Path=dir_saveorig+tablename+".xls";
	if(File.exists(Path)){
		plotresults(Path,xColumname,Acolumnname,msAorigtitle,Atracelength,origtitle2,plottitle,xaxis,yaxis,dir_saveorig);				
	};
};
function add_strings_to_array(array,before,after){
	array2=newArray(array.length);
	for(i=0;i<array.length;i++){
		array2[i]=""+before+array[i]+after;		
	};
	return array2;
};
function initialise_arrays(){
	//Create all arrays depending on the number of experiments to analyse
	msAorigtitle=newArray(maxseriesnumber);
	msAExperimentnumber=newArray(maxseriesnumber); 
	msAframes=newArray(maxseriesnumber);
	msAsavepath=newArray(maxseriesnumber);
	msAROI=newArray(maxseriesnumber);
//Exptype=0
	msAmean=newArray(maxseriesnumber*Atoanal.length);
	msAmeanSD=newArray(maxseriesnumber*Atoanal.length);
	msAmeanSDE=newArray(maxseriesnumber*Atoanal.length);
	msAmedian=newArray(maxseriesnumber*Atoanal.length);
	msAmedianSD=newArray(maxseriesnumber*Atoanal.length);
//Exptype=1
	msAmeanFRETchange=newArray(maxseriesnumber*Atoanal.length);
	msASDmeanFRETchange=newArray(maxseriesnumber*Atoanal.length);
	msASDEmeanFRETchange=newArray(maxseriesnumber*Atoanal.length);
	msAmedianFRETchange=newArray(maxseriesnumber*Atoanal.length);
	msASDmedianFRETchange=newArray(maxseriesnumber*Atoanal.length);
	msAROIFRETchange=newArray(maxseriesnumber*parseFloat(List.get("ROIstoremember"))*Atoanal.length);
	msAROIFRETchangeSD=newArray(maxseriesnumber*parseFloat(List.get("ROIstoremember"))*Atoanal.length);
};
function update_parameterlist(){
	chcounter=0;
	for(ch=0;ch<parseFloat(List.get("chnumber"));ch++){
		cht=ch+1;
		if(List.get("chtype"+cht)!=Achanneltype[6]){
			if(List.get("chtype"+ch)!=Achanneltype[5]){
				chno=ch+1;
				List.set("minvalue_"+chno,Aminvalue[ch]);
				List.set("maxvalue_"+chno,Amaxvalue[ch]);
				List.set("background_"+chno,Abackground[ch]);
			};
		};
	};
};
function smooth_array(array,places){
	if(array.length>=3&&places<array.length){
		sarray=newArray(array.length);	
		for(i=0;i<array.length;i++){
			mean=0;
			counter=0;
			for(j=i-places;j<=i+places;j++){
				if(j>=0&&j<array.length){
					if(!isNaN(array[j])){
						mean=mean+array[j];	
						counter++;			
					};
				};
			};
			mean=mean/counter;
			sarray[i]=mean;
		};
		return sarray;
	};
	return array;
};
function cal_sum(array){
	array=Array.concat(array);
	sum=0;
	for(i=0;i<array.length;i++){
		sum=sum+array[i];		
	};
	return sum;
};
function create_mask(channel,minvaluename,rep,thresholding,thresholdmethod,processguieachloop){
	selectWindow(channel);
	wait(100);
	frames=nSlices;
	mask="Binary mask of "+channel;
	run("Select None");
	run("Duplicate...", "title=["+mask+"] duplicate range=1-["+frames+"]");		
	resize();
	setLocation(width,0);
	Atlim=threshold_channel(mask,thresholding,thresholdmethod,rep,processguieachloop,List.get(minvaluename));
	List.set(minvaluename,Atlim[0]);
	maxvalue=Atlim[1];
	selectWindow(mask);
	wait(100);
	setThreshold(List.get(minvaluename), maxvalue);
	if(List.get("thresholding")==3)run("Convert to Mask", "method="+List.get("thresholdmethod")+" background=Default calculate black");
	if(List.get("thresholding")!=3)run("Convert to Mask", "method=Default background=Default black");
	resetThreshold();
	if(List.get("Fill-holes"))run("Fill Holes", "stack");
	run("Open","stack");
	run("Close-","stack");
	if(List.get("watershed")){
		if(Exptype==0){
			if(!List.get("nucleuss"))run("Watershed","stack");
		}else{
			if(!List.get("onecellexp")&&!List.get("nucleuss"))run("Watershed","stack");	
		};
	};
	return mask;
};
function get_theor_maxvalue(){
	Bitd=bitDepth();
	maxvalue=pow(2, Bitd)-1;
	return maxvalue;	
};
function threshold_channel(channel,thresholding,thresholdmethod,rep,processguieachloop,min){
	Atlim=newArray(2);
	selectWindow(channel);
	wait(100);
	lower=min;
	upper=get_theor_maxvalue();
	frames=nSlices;
	getLocationAndSize(x, y, width, height);
	run("Threshold...");
	if(thresholding==1&&(rep==1||!List.get("processguieachloop"))){//manual during the analysis
		run("Threshold...");
		if(isOpen("Threshold")){//295x265
			selectWindow("Threshold");
			setLocation(width,0);	
		};
		if(frames==1){
			arrange_and_wait(1,channel,"Threshold","Please threshold the picture "+channel+" to define signal.\nEverything below the threshold (not coloured in red) will be excluded from the analysis!\nUse the window 'Threshold' to do so. Don't press 'Apply' in this window! Check if you have 'Dark background' ticked.\nThen press OK.",1,"oval");
		};
		if(frames>1){
			arrange_and_wait(1,channel,"Threshold","Please threshold the channel "+channel+" to define signal.\nEverything below the threshold (not coloured in red) will be excluded from the analysis!\nUse the window 'Threshold' to do so. Don't press 'Apply' in this window! Check if you have 'Dark background' ticked.\nThen press OK.",1,"oval");	
		};
		selectWindow(channel);
		wait(100);
		getThreshold(lower, upper);
	};
	if(thresholding==3){//Automatic with a predefined thresholding method
		setAutoThreshold(thresholdmethod+" dark stack");
		run("Threshold...");	
		getThreshold(lower, upper);
	};
	selectWindow(channel);
	wait(100);
	setThreshold(lower, upper);
	Atlim[0]=lower;
	Atlim[1]=upper;
	return Atlim;
};
function create_voronoi(channel,mask){
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	selectWindow(channel);
	setBatchMode("hide");
	wait(100);
	slices=nSlices;
	if(List.get("watershed")){
		if(slices>1)run("Watershed","stack");
		if(slices==1)run("Watershed");
	};
	voronoimask2="Nucleuschannel_mask";
	run("Duplicate...", "title=["+voronoimask2+"] duplicate range=1-["+frames+"]");
	selectWindow(channel);
	wait(100);
	if(slices>1)run("Voronoi", "stack");
	if(slices==1)run("Voronoi");
	max=get_theor_maxvalue();
	setThreshold(1, max);
	run("Convert to Mask", "method=Default background=Default black");
	if(slices>1)run("Invert", "stack");
	if(slices==1)run("Invert");
	wait(100);
	imageCalculator("Multiply stack", mask,channel);
	wait(100);
	if(isOpen(channel)){
		selectWindow(channel);
		wait(100);
		close();
	};
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
};
function arrange_and_wait(threshold,channel,channel2,message,updateRM,tool){
	selectWindow(channel);
	wait(100);
	getLocationAndSize(x, y, width, height);
	batchmode=is("Batch Mode");
	if(batchmode){
		if(isOpen(channel2)){
			selectWindow(channel2);
			setBatchMode("show");
			roiManager("Show All with labels");
		};
		if(isOpen(channel)){
			selectWindow(channel);
			setBatchMode("show");
			roiManager("Show All with labels");
		};
	};
	resetMinAndMax();
	//run("Enhance Contrast", "saturated=0.35");
	xorig=x;
	yorig=y;
	worig=width;
	horig=height;
	if(isOpen(channel2)){	
		selectWindow(channel2);
		wait(100);
		getLocationAndSize(x, y, width, height);
		xorig2=x;
		yorig2=y;
		worig2=width;
		horig2=height;
		resetMinAndMax();
		//run("Enhance Contrast", "saturated=0.35");
	};
	wfactor=(screenWidth-220)/screenWidth;
	hfactor=(screenHeight-220)/screenHeight;
	wspace=screenWidth*wfactor;
	hspace=screenHeight*hfactor;
	if(isOpen("Synchronize Windows")){
		selectWindow("Synchronize Windows");
		setLocation(wspace/2,hspace);		
	};
	if(isOpen(channel2)){
		selectWindow(channel2);
		wait(100);
		//setLocation(wspace/2,0,wspace/2,hspace);
		setLocation(wspace/2,0);
		roiManager("Show All with labels");
	};
	selectWindow(channel);
	wait(100);
	setLocation(0,0,wspace/2,hspace);
	if(isOpen(channel2)&&channel2!="Threshold"){
		selectWindow(channel2);
		wait(100);
		setLocation(wspace/2,0,wspace/2,hspace);
	};	
	selectWindow(channel);
	wait(100);
	roiManager("Show All with labels");
	if(threshold==1){
		run("Threshold...");
		setAutoThreshold("Triangle dark stack");
		getThreshold(lower, upper);
		setThreshold(lower, upper);
		setThreshold(lower, upper);
	};
	set_Tool(tool);
	waitForUser(macroinfo,message);
	if(batchmode){
		if(isOpen(channel)){
			selectWindow(channel);
			setBatchMode("hide");
		};
		if(isOpen(channel2)){
			selectWindow(channel2);
			setBatchMode("hide");
		};
	};
	if(isOpen(channel2)){	
		selectWindow(channel2);
		wait(100);
		setLocation(xorig2,yorig2,worig2,horig2);	
		if(updateRM)roiManager("Show All with labels");
	};
	selectWindow(channel);
	wait(100);
	setLocation(xorig,yorig,worig,horig);
	if(updateRM)roiManager("Show All with labels");
};
function add_to_array(array,value){
	for(i=0;i<array.length;i++){
		array[i]=array[i]+value;
	};
	return array;
};
function add_arrays(array1,array2){
	if(array1.length==array2.length){	
		array=newArray(array1.length);
		for(i=0;i<array.length;i++){
			array[i]=array1[i]+array2[i];
		};
		return array;
	};
	return array1;
};
function FREQcalc(xValues,yValues,yValuesSD,stimulation,Stimulusafterframe,Equilibrationtime,stopafterframe){
	if(stimulation){
		Stimulusafterframe2=Stimulusafterframe+Equilibrationtime;	
		xValues=Array.slice(xValues,Stimulusafterframe2,stopafterframe);
		yValues=Array.slice(yValues,Stimulusafterframe2,stopafterframe);
	};
	if(xValues.length==yValues.length&&xValues.length>3){
		meanv=calMean(yValues);//just mean
		SDv=calMean(yValuesSD)/2;
		meanv=meanv;
		smooth=smooth_array(yValues,round(xValues.length/10));
		yValuesSD=smooth_array(yValuesSD,round(xValues.length/10));
		//smooth=add_to_array(smooth,SDv);
		smooth=add_arrays(smooth,yValuesSD);
		Amaxx=newArray(0);
		Amaxy=newArray(0);
		localmaxx=0;
		WP=0;
		localmaxy=0;
		for(i=0;i<xValues.length;i++){
			if(!isNaN(yValues[i])){	
				if(yValues[i]>smooth[i]){
					if(yValues[i]>localmaxy){
						localmaxy=yValues[i];
						localmaxx=xValues[i];
					};
					WP=1;
				};
				if(yValues[i]<smooth[i]){
					if(WP>0){
						Amaxx=Array.concat(Amaxx,localmaxx);	
						Amaxy=Array.concat(Amaxy,localmaxy);	
						localmaxy=0;
					};
					WP=-1;	
				};
			};
		};
		period=0;
		periodSD=0;
		if(Amaxx.length>1){	
			Aperiods=newArray(Amaxx.length-1);
			for(i=1;i<Amaxx.length;i++){
				Aperiods[i-1]=(Amaxx[i]-Amaxx[i-1]);	
			};
			period=calMean(Aperiods);
			periodSD=calSD(Aperiods);
		};
		/*Plot.create("Title", "Time [s]", "mean intensity", xValues, yValues);Plot.drawLine(xValues[0], meanv, xValues[xValues.length-1], meanv);
		Plot.setColor("red");
		Plot.add("line", xValues, smooth);
		Plot.setColor("red");
		Plot.add("circle", Amaxx, Amaxy);Plot.setColor("black");
		Plot.show();*/
		return newArray(period,periodSD,Amaxx.length);
	};
	return newArray(0,0,1);
};
function check_memory(){
	x=parseFloat(IJ.currentMemory())/parseFloat(IJ.maxMemory());
	if(x>0.9)run("Collect Garbage");
	x=parseFloat(IJ.currentMemory())/parseFloat(IJ.maxMemory());
	if(x>0.95)exit("Not enough free memory: \n"+IJ.freeMemory());
};
function create_translocationchannel(channel,translocationchannel,method,loop){
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	selectWindow(channel);
	wait(100);
	run("Select None");
	roiManager("Deselect");
	if(method!="use outer rim of each cell"){
		selectWindow(channel);
	};
	if(method=="use outer rim of each cell"){
		selectWindow(thresholdmask);
	};
	wait(100);
	run("Duplicate...", "title=["+translocationchannel+"] duplicate range=1-["+nSlices+"]");
	run("Conversions...", " ");
	run("32-bit");
	selectWindow(translocationchannel);
	wait(100);
	if(Bitdorig==8)run("8-bit");
	if(Bitdorig==16)run("16-bit");
	if(Bitdorig!=8&&Bitdorig!=16){
		run("Conversions...", "scale");
		max=getmaximumpixel(translocationchannel);
		setMinAndMax(0, max);
		run("8-bit");
	};
	if(method=="top-hat filter"){
		Tophatpicture="Tophat filtered "+channel;
		run("Select None");
		run("Duplicate...", "title=["+Tophatpicture+"] duplicate range=1-["+nSlices+"]");
		selectWindow(Tophatpicture);
		wait(100);
		run("Minimum...", "radius=["+List.get("radius_trch")+"] stack");
		selectWindow(Tophatpicture);
		wait(100);
		run("Maximum...", "radius=["+List.get("radius_trch")+"] stack");
		imageCalculator("Subtract stack", translocationchannel,Tophatpicture);
		run("Rename...", "title=["+translocationchannel+"]");
		if(isOpen(Tophatpicture)){
			selectImage(Tophatpicture);
			close();
		};
	};
	if(method=="built-in 'Subtract background'"){
		run("Subtract Background...", "rolling=["+List.get("radius_trch")+"] stack");	
	};
	if(method=="use outer rim of each cell"){
		cwidth=round(parseFloat(List.get("radius_trch"))*1.5);
		run("Options...", "iterations=["+cwidth+"] count=1 black edm=Overwrite");
		//run("Options...", "iterations=["+List.get("radius_trch")+"] count=1 black edm=Overwrite");
		run("Select None");
		selectWindow(translocationchannel);
		wait(100);
		run("Conversions...", "scale");
		max=getmaximumpixel(translocationchannel);
		setMinAndMax(0, max);
		run("8-bit");
		run("Conversions...", " ");
		run("Erode", "stack");
		run("Options...", "iterations=1 count=1 black edm=Overwrite");
		run("Invert", "stack");
		imageCalculator("Multiply stack", translocationchannel,thresholdmask);
	};
	if(method=="built-in 'Subtract background' - exclude cytosol"){
		selectWindow(thresholdmask);
		run("Select None");
		wait(100);
		run("Duplicate...", "title=cytosol duplicate range=1-["+nSlices+"]");
		run("Conversions...", "scale");
		selectWindow("cytosol");
		wait(100);
		max=getmaximumpixel("cytosol");
		setMinAndMax(0, max);
		run("8-bit");
		run("Conversions...", " ");
		cwidth=round(parseFloat(List.get("radius_trch"))*1.5);
		run("Options...", "iterations=["+cwidth+"] count=1 black edm=Overwrite");
		selectWindow("cytosol");
		wait(100);
		run("Erode", "stack");
		run("Options...", "iterations=1 count=1 black edm=Overwrite");
		run("Invert", "stack");
		make_real_binary("cytosol");
		run("8-bit");
		selectWindow(translocationchannel);
		wait(100);
		run("Subtract Background...", "rolling=["+List.get("radius_trch")+"] stack");	
		imageCalculator("Multiply stack", translocationchannel,"cytosol");
		if(isOpen("cytosol")){
			selectWindow("cytosol");
			wait(100);
			if(List.get("savemask")){
				fullpath=dir_save+"cytosolic_part.tif";
				showStatus("Saving... Cytosolic part");
				saveAs("Tiff", fullpath);
			};
			close();
		};
	};
	if(method=="built-in 'Find Edges'"){
		run("Find Edges", "stack");
	};
	if(method=="built-in 'FeatureJ Laplacian'"){
		run("FeatureJ Laplacian", "compute smoothing=1.0 detect");
		run("Abs", "stack");
	};
	if(method=="combine 'Find Edges' and 'Subtract background'"){
		run("Find Edges", "stack");
		run("Subtract Background...", "rolling=["+List.get("radius_trch")+"] stack");	
	};
	run("Conversions...", " ");
	selectWindow(translocationchannel);
	wait(100);
	max=get_theor_maxvalue();
	setMinAndMax(0, max);
	run("Median...", "radius=1 stack");
	resize();
	run("32-bit");
	run("Conversions...", " ");
	getLocationAndSize(x, y, width, height);
	if((2*width)<=scwidth)setLocation(width,0);
	maxvalue=get_theor_maxvalue();
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
	if(List.get("NaN_translocation"))set_background_nan(translocationchannel,"1",loop,List.get("processguieachloop"),List.get("thresholdmethod"),1,maxvalue);
	selectWindow(translocationchannel);
	wait(100);
	run("Enhance Contrast", "saturated=0.35");
};
function calculate_translocationratio(POIchannel,markerchannel,POI_markername,POI_backgroundname,Rationame){
	if(List.get("method_trch")!="Manually define two pixel classes"){
		markermask="Mask of "+markerchannel;
		if(!isOpen(markermask)){
			create_translocationchannel(markerchannel,markermask,List.get("method_trch"),loop);
			transform_to_marker_mask(markermask,"minvalue-"+markerchannel,loop,List.get("thresholding"),List.get("thresholdmethod"),List.get("processguieachloop"));
		};
		batchmode=is("Batch Mode");
		if(!batchmode){
			setBatchMode(true);
		};
		selectWindow(markermask);
		in_markermask=make_inverse_mask(markermask);
	};
	if(List.get("method_trch")=="Manually define two pixel classes"){
		projectionchannel="Time projection of "+markerchannel;
		if(!isOpen(projectionchannel)){
			projectionchannel=create_thresholdpic(markerchannel,List.get("segmentationprojection"));
		};
		markermask=create_manual_mask(projectionchannel,"Manual Marker");
		in_markermask2=make_inverse_mask(markermask);
		make_real_binary(in_markermask2);
		run("8-bit");
		projectionchannel2="Time projection 2 of "+markerchannel;
		imageCalculator("Multiply create stack",projectionchannel,in_markermask2);
		run("Rename...", "title=["+projectionchannel2+"]");
		in_markermask=create_manual_mask(projectionchannel2,"Manual Background");
		if(isOpen(projectionchannel2)){
			imageCalculator("Multiply stack",in_markermask,in_markermask2);
			selectWindow(projectionchannel2);
			wait(100);
			close();
		};
		if(isOpen(in_markermask2)){
			selectWindow(in_markermask2);
			wait(100);
			close();
		};
	};
	make_real_binary(markermask);
	make_real_binary(in_markermask);
	selectWindow(POIchannel);
	imageCalculator("Multiply create stack",POIchannel,markermask);
	run("Rename...", "title=["+POI_markername+"]");
	set_zero_nan(POI_markername);
	imageCalculator("Multiply create stack", POIchannel,in_markermask);
	run("Rename...", "title=["+POI_backgroundname+"]");
	set_zero_nan(POI_backgroundname);
	if(tc==nooftrch){
		if(isOpen(markermask)){
			selectWindow(markermask);
			wait(100);
			fullpath=dir_save+markermask+".tif";
			if(List.get("savemask"))saveAs("Tiff", fullpath);
			close();
		};
	};
	if(isOpen(in_markermask)){
		selectWindow(in_markermask);
		wait(100);
		fullpath=dir_save+in_markermask+".tif";
		if(List.get("savemask"))saveAs("Tiff", fullpath);
		close();
	};
	POI_background_mean="Mean "+POI_backgroundname;
	POI_marker_mean="Mean "+POI_markername;
	replace_ROIs_with_mean(POI_backgroundname,POI_background_mean,List.get("Ratio_Measure"));
	replace_ROIs_with_mean(POI_markername,POI_marker_mean,List.get("Ratio_Measure"));
	imageCalculator("Divide create 32-bit stack",POI_marker_mean,POI_background_mean);
	run("Rename...", "title=["+Rationame+"]");
	selectWindow(POI_marker_mean);
	wait(100);
	close();
	selectWindow(POI_background_mean);
	wait(100);
	close();
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
};
function calculate_pearson(channel1,channel2,name_pearson,name_slope){
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	run("Conversions...", " ");
	run("Select None");
	subtract1="Subtract of "+channel1;
	subtract2="Subtract of "+channel2;
	numerator="Numerator";
	denominator="Denominator";
	square1="Square1";
	square2="Square2";
	mean1="Mean of "+channel1;
	mean2="Mean of "+channel2;
	//create mean1 and mean2
	replace_ROIs_with_mean(channel1,mean1,"Mean");
	selectWindow(mean1);
	wait(100);
	run("32-bit");
	replace_ROIs_with_mean(channel2,mean2,"Mean");
	selectWindow(mean2);
	wait(100);
	run("32-bit");
	//create subtract1 and subtract2
	imageCalculator("Subtract create 32-bit stack", channel1,mean1);
	run("Rename...", "title=["+subtract1+"]");
	run("32-bit");
	imageCalculator("Subtract create 32-bit stack", channel2,mean2);
	run("Rename...", "title=["+subtract2+"]");
	run("32-bit");
	if(isOpen(mean1)){
		selectWindow(mean1);
		wait(100);
		close();
	};
	if(isOpen(mean2)){
		selectWindow(mean2);
		wait(100);
		close();
	};
	imageCalculator("Multiply create 32-bit stack",subtract1,subtract2);
	run("Rename...", "title=["+numerator+"]");
	replace_ROIs_with_mean(numerator,"Mean of "+numerator,"RawIntDen");
	selectWindow(subtract1);
	wait(100);
	run("Square", "stack");
	replace_ROIs_with_mean(subtract1,square1,"RawIntDen");
	
	//setBatchMode("show");
	if(isOpen(numerator)){
		selectWindow(numerator);
		wait(100);
		close();
	};
	selectWindow(subtract2);
	wait(100);
	run("Square", "stack");
	replace_ROIs_with_mean(subtract2,square2,"RawIntDen");

	imageCalculator("Divide create 32-bit stack","Mean of "+numerator,square1);
	run("Rename...", "title=["+name_slope+"]");
	setMinAndMax(0, 1);
	run("Fire");
	if(isOpen(subtract1)){
		selectWindow(subtract1);
		wait(100);
		close();
	};
	if(isOpen(subtract2)){
		selectWindow(subtract2);
		wait(100);
		close();
	};
	imageCalculator("Multiply create 32-bit stack",square1,square2);
	run("Rename...", "title=["+denominator+"]");
	selectWindow(denominator);
	wait(100);
	run("Square Root", "stack");
	if(isOpen(square1)){
		selectWindow(square1);
		wait(100);
		close();
	};
	if(isOpen(square2)){
		selectWindow(square2);
		wait(100);
		close();
	};
	imageCalculator("Divide create 32-bit stack","Mean of "+numerator,denominator);
	run("Rename...", "title=["+name_pearson+"]");
	setMinAndMax(0, 1);
	run("Fire");
	if(isOpen("Mean of "+numerator)){
		selectWindow("Mean of "+numerator);
		wait(100);
		close();
	};
	if(isOpen(denominator)){
		selectWindow(denominator);
		wait(100);
		close();
	};
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
};
function make_inverse_mask(channel){
	selectWindow(channel);
	wait(100);
	inverse="Inverse of "+channel;
	run("Select None");
	run("Duplicate...", "title=["+inverse+"] duplicate range=1-["+nSlices+"]");
	if(!is("binary")){
		setThreshold(1, 255);
		run("Convert to Mask");
	};
	run("Invert", "stack");
	return inverse;	
};
function make_real_binary(channel){
	selectWindow(channel);
	run("32-bit");
	wait(100);
	//max=get_theor_maxvalue();
	max=getmaximumpixel(channel);
	run("Divide...", "value="+max+" stack");
	setMinAndMax(0, 1);
};
function replace_ROIs_with_mean(channel,newname,measure){
	selectWindow(channel);
	wait(100);
	run("Select None");
	run("Clear Results");
	for(i=0;i<Ameasure.length;i++){
		if(measure==Ameasure[i])setmeasure=Asetmeasure[i];
	};
	run("Set Measurements...", " "+setmeasure+" redirect=None decimal=3");
	//run("Set Measurements...", "  mean redirect=None decimal=3");
	run("Duplicate...", "title=["+newname+"] duplicate range=1-["+nSlices+"]");
	selectWindow(newname);
	wait(100);
	run("32-bit");
	nf=nSlices;
	ROIs=roiManager("count");
	roiManager("Deselect");
	if(Exptype==0){
		roiManager("Associate", "true");
		roiManager("Show All");
		roiManager("Measure");
		for (ROI =0; ROI < nResults; ROI++){
			roiManager("Select", ROI);
			mean=getResult(measure, ROI);
			setColor(mean);
			fill();
		};
	};
	if(Exptype==1){
		roiManager("Associate", "false");
		roiManager("Multi Measure");
		for(i=0;i<nf;i++){
			for(ROI=0;ROI<ROIs;ROI++){
				roiManager("Select", ROI);
				roiManager("Remove Slice Info");
				setSlice(i+1);
				roiManager("Select", ROI);
				ROIname=ROI+1;
				columname=""+measure+ROIname;
				mean=getResult(columname, i);
				setColor(mean);
				fill();
			};
		};
	};
	run("Select None");
	run("Clear Results");
};
function transform_to_marker_mask(channel,minvaluename,rep,thresholding,thresholdmethod,processguieachloop){
	selectWindow(channel);
	wait(100);
	frames=nSlices;
	run("Select None");
	resize();
	getLocationAndSize(x, y, width, height);
	setLocation(width,0);
	Atlim=threshold_channel(channel,thresholding,thresholdmethod,rep,processguieachloop,List.get(minvaluename));
	List.set(minvaluename,Atlim[0]);
	maxvalue=Atlim[1];
	selectWindow(channel);
	wait(100);
	setThreshold(List.get(minvaluename), maxvalue);
	if(List.get("thresholding")==3)run("Convert to Mask", "method="+List.get("thresholdmethod")+" background=Default calculate black");
	if(List.get("thresholding")!=3)run("Convert to Mask", "method=Default background=Default black");
	resetThreshold();
	run("Median...", "radius=1 stack");
};
function set_zero_nan(channelname){
        selectWindow(channelname);
        wait(100);
        ID=getImageID();
        run("32-bit");
	max=get_theor_maxvalue();
	selectWindow(channelname);
	wait(100);
	if(isActive(ID)){
		setThreshold(1, max);
		run("NaN Background", "stack");
	};
	if(!isActive(ID)){
		selectImage(ID);
		setThreshold(1, max);
		run("NaN Background", "stack");
	};
	resetThreshold();
};
function define_channels_to_analyze(){
	Awindownames=newArray(parseFloat(List.get("chnumber")));
	Achnames=newArray(parseFloat(List.get("chnumber")));
	Achextension=newArray(parseFloat(List.get("chnumber")));
	Achcolor=newArray(parseFloat(List.get("chnumber")));
	Aminvalue=newArray(parseFloat(List.get("chnumber")));
	Amaxvalue=newArray(parseFloat(List.get("chnumber")));
	Abackground=newArray(parseFloat(List.get("chnumber")));
	Atoanal=newArray(0);
	Atoanalch=newArray(0);
	Atoanalchno=newArray(0);
	Asegch=newArray(0);
	Asegchno=newArray(0);
	donorno=0;
	acceptorno=0;
	intensityno=0;
	cellstainno=0;
	nucleusno=0;
	transmissiono=0;
	noofratioch=0;
	List.set("cellstainingch",0);
	List.set("nucleuss",0);
	List.set("translocationch",0);
	ae=false;
	for(ch=0;ch<parseFloat(List.get("chnumber"));ch++){
		chno=ch+1;
		Achnames[ch]=List.get("chname"+chno);
		Awindownames[ch]=""+Achnames[ch]+" channel";
		Achextension[ch]=List.get("chabbrev"+chno);
		Achcolor[ch]=List.get("chcolor"+chno);
		Aminvalue[ch]=List.get("minvalue_"+chno);
		Abackground[ch]=List.get("background_"+chno);
	//Test the channel type
		if(List.get("chtype"+chno)==Achanneltype[0]){
			donorno++;
			List.set("donorchannel"+donorno,Awindownames[ch]);
			List.set("donorname"+donorno,Achnames[ch]);
			Atoanal=Array.concat(Atoanal,ch);
			Asegch=Array.concat(Asegch,Awindownames[ch]);
			Asegchno=Array.concat(Asegchno,ch);
		};
		if(List.get("chtype"+chno)==Achanneltype[1]){
			acceptorno++;
			List.set("acceptorchannel"+acceptorno,Awindownames[ch]);
			List.set("acceptorname"+acceptorno,Achnames[ch]);
			Atoanal=Array.concat(Atoanal,ch);
			Asegch=Array.concat(Asegch,Awindownames[ch]);
			Asegchno=Array.concat(Asegchno,ch);
		};
		if(donorno!=0&&donorno==acceptorno&&donorno!=noofratioch){
			noofratioch++;
			rationame=""+List.get("acceptorname"+noofratioch)+"-"+List.get("donorname"+noofratioch)+"-ratio";
			Achnames=Array.concat(Achnames,rationame);	
			Awindownames=Array.concat(Awindownames,""+rationame);
			List.set("ratiochannel"+noofratioch,""+rationame);
			no=Awindownames.length-1;
			Atoanal=Array.concat(Atoanal,no);
			Asegch=Array.concat(Asegch,Awindownames[no]);
			Asegchno=Array.concat(Asegchno,no);	
		};
		if(List.get("chtype"+chno)==Achanneltype[2]){
			Atoanal=Array.concat(Atoanal,ch);
			Asegch=Array.concat(Asegch,Awindownames[ch]);
			Asegchno=Array.concat(Asegchno,ch);
			intensityno++;
		};
		if(List.get("chtype"+chno)==Achanneltype[3]){
			Atoanal=Array.concat(Atoanal,ch);
			List.set("cellstainingch",1);
			cellstainno++;
			List.set("cellstainingchannel",Awindownames[ch]);
		};
		if(List.get("chtype"+chno)==Achanneltype[4]){
			Atoanal=Array.concat(Atoanal,ch);
			List.set("nucleuss",1);
			nucleusno++;
			List.set("nucleuschannel",Awindownames[ch]);
		};
		if(List.get("chtype"+chno)==Achanneltype[5]){
			Atoanal=Array.concat(Atoanal,ch);
			Asegch=Array.concat(Asegch,Awindownames[ch]);
			Asegchno=Array.concat(Asegchno,ch);
			transmissiono++;
	};
	};
	if(donorno!=acceptorno)exit("The data set does not contain the same number of nominator and denominator imaging channels!");
	if(nucleusno>1||cellstainno>1)exit(""+nucleusno+" cell segmentation channels were selected. Only one cell staining channel is supported.");
	for(i=0;i<Atoanal.length;i++){
		Atoanalch=Array.concat(Atoanalch,Awindownames[Atoanal[i]]);
		Atoanalchno=Array.concat(Atoanalchno,Atoanal[i]);
	};
	if(List.get("cellstainingch")){
		Asegch=newArray(0);
		Asegch=Array.concat(Asegch,List.get("cellstainingchannel"));		
	};
	if(Atoanal.length==0){
		if(List.get("cellstainingch")){
			exit("Please select channel to perform analysis. Only a cell staining channel was chosen.");
		};
		if(List.get("nucleuss")){
			exit("Please select channel to perform analysis. Only nucleus staining channel was chosen.");
		};
	};
	if((parseFloat(List.get("segchno"))+1)>Asegch.length){
		List.set("segchno",0);
	};
	if(Atoanal.length==0)exit("No channel for analysis was selected.");
	List.set("segmentationchannel",Awindownames[Atoanal[parseFloat(List.get("segchno"))]]);
};
function replace_string(string,old,new){
	x=-1;
	y=indexOf(old, "+");
	if(y==0)x=y;
	y=indexOf(old, "?");
	if(y==0)x=y;
	y=indexOf(old, "*");
	if(y==0)x=y;
	if(x<0)string=replace(string, old, new);
	return string;
};
function set_Tool(tool){
	initial=IJ.getToolName();
	found=0;
	for(i=0;i<=22;i++){
		setTool(i);
		x=IJ.getToolName();
		if(x==tool){
			i=22;
			found=1;
		};
	};
	if(found==0){
		setTool(initial);
	};
};
function get_SetMeasurementString(){
	for(i=0;i<Ameasure.length;i++){
		if(List.get("Measure")==Ameasure[i])setmeasure=Asetmeasure[i];
	};
	Adefaults=split(List.get("Parameter_bin"));
	Atomeasure=subset_array(AsetMeasurements,Adefaults);
	Atomeasure=Array.concat(setmeasure,Atomeasure);
	SetMeasurementString=array2string(removeDuplicates(Atomeasure)," ");
	return SetMeasurementString;
};
function get_from_results_array(array,position){
	array2=newArray(array.length);
	if(position>(nResults-1)){
		Array.fill(array2,NaN);
		return array2;
	};
	for(i=0;i<array.length;i++){
		array2[i]=getResult(array[i],position);
	};
	return array2;
};
function write_in_resultstring(channel,array,ROIname,normarray,frames){
	title=List.get("origtitle");
	Adefaults=split(List.get("Parameter_bin"));
	Aheading=subset_array(AmeasureAbbrev,Adefaults);
	Aheading=remove_arrayEntry(Aheading,List.get("Measure"));
	Aheading=add_strings_to_array(Aheading,"",ROIname);
	roino=round(parseFloat(ROIname))-1;
	if(stimulation){
		meanc=CalAmplitudeChange(ASlice,array,parseFloat(List.get("Stimulusafterframe")),1,parseFloat(List.get("Equilibrationtime")),parseFloat(List.get("stopafterframe")));
		fitc=CalAmplitudeChange(ASlice,array,parseFloat(List.get("Stimulusafterframe")),2,parseFloat(List.get("Equilibrationtime")),parseFloat(List.get("stopafterframe")));
		minc=CalAmplitudeChange(ASlice,array,parseFloat(List.get("Stimulusafterframe")),4,parseFloat(List.get("Equilibrationtime")),parseFloat(List.get("stopafterframe")));
		maxc=CalAmplitudeChange(ASlice,array,parseFloat(List.get("Stimulusafterframe")),5,parseFloat(List.get("Equilibrationtime")),parseFloat(List.get("stopafterframe")));
		baselinev=getmeantonormalize(array,parseFloat(List.get("Stimulusafterframe")));
		Asresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,baselinev,meanc,fitc,minc,maxc);
		AvariableResults=get_from_results_array(Aheading,0);
		Asresultstring=Array.concat(Asresultstring,AvariableResults);
		istring=a2resultsline(Asresultstring);
		sresultstring+=istring;
		File.append(sresultstring,sresultstringpath);
		sresultstring="";
	};	
	for(row=0;row<frames;row++){
		if(List.get("CellClassification")){
			if(stimulation){
				Aresultstring=newArray(""+title,title+"."+channel+"."+ROIname,date,channel,ROIname,AclassROIs[roino],title+"."+ROIname,amountrois,List.get("Stimulusafterframe"),List.get("Equilibrationtime"),List.get("stopafterframe"),baselinev,meanc,fitc,minc,maxc,Atime[row],array[row],normarray[row]);
			};
			if(!stimulation){
				Aresultstring=newArray(""+title,title+"."+channel+"."+ROIname,date,channel,ROIname,AclassROIs[roino],title+"."+ROIname,amountrois,List.get("stopafterframe"),Atime[row],array[row]);		
			};
		}else{
			if(stimulation){
				Aresultstring=newArray(""+title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,List.get("Stimulusafterframe"),List.get("Equilibrationtime"),List.get("stopafterframe"),baselinev,meanc,fitc,minc,maxc,Atime[row],array[row],normarray[row]);
			};
			if(!stimulation){
				Aresultstring=newArray(""+title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,List.get("stopafterframe"),Atime[row],array[row]);		
			};
		};
		AvariableResults=get_from_results_array(Aheading,row);
		Aresultstring=Array.concat(Aresultstring,AvariableResults);
		istring=a2resultsline(Aresultstring);
		resultstring+=istring;					
	};
	File.append(resultstring,resultstringpath);
	resultstring="";
};
function write_in_resultstring_nucleus(channel,array,ROIname,normarray,frames){
	title=List.get("origtitle");
	Adefaults=split(List.get("Parameter_bin"));
	Aheading=subset_array(AmeasureAbbrev,Adefaults);
	Aheading=remove_arrayEntry(Aheading,List.get("Measure"));
	row=0;
	roino=round(parseFloat(ROIname))-1;
	if(List.get("CellClassification")){
		if(Exptype==0){
			if(!List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,"Nucleus",title+"."+ROIname,1,1,frames,array[row]);
			if(List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,"Nucleus",title+"."+ROIname,1,1,1,frames,array[row]);
		};
		if(Exptype!=0){
			if(stimulation){
				Aresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,List.get("Stimulusafterframe"),List.get("Equilibrationtime"),List.get("stopafterframe"),0,0,0,0,0,0,array[row],0);
			};
			if(!stimulation){
				Aresultstring=newArray(""+title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,List.get("stopafterframe"),0,array[row]);		
			};
		};
	}else{
		if(Exptype==0){
			if(!List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,1,1,frames,array[row]);
			if(List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,1,1,1,frames,array[row]);
		};
		if(Exptype!=0){
			if(stimulation){
				Aresultstring=newArray(title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,List.get("Stimulusafterframe"),List.get("Equilibrationtime"),List.get("stopafterframe"),0,0,0,0,0,0,array[row],0);
			};
			if(!stimulation){
				Aresultstring=newArray(""+title,title+"."+channel+"."+ROIname,date,channel,ROIname,title+"."+ROIname,amountrois,List.get("stopafterframe"),0,array[row]);		
			};
		};
	};
	AvariableResults=get_from_results_array(Aheading,row);
	Aresultstring=Array.concat(Aresultstring,AvariableResults);
	istring=a2resultsline(Aresultstring);
	resultstring+=istring;
	File.append(resultstring,resultstringpath);
	resultstring="";
};
function write_in_resultstring2(date,channel,ROIno,Sliceno,Asubtitle,mean){
	Adefaults=split(List.get("Parameter_bin"));
	Aheading=subset_array(AmeasureAbbrev,Adefaults);
	Aheading=remove_arrayEntry(Aheading,List.get("Measure"));
	title=List.get("origtitle");
	for(row=0;row<ROIno.length;row++){
		if(List.get("CellClassification")){
			if(!List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIno[row],date,channel,ROIno[row],AclassROIs[row],title+"."+ROIno[row],Sliceno[row],ROIno.length,frames,mean[row]);
			if(List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIno[row],date,channel,ROIno[row],AclassROIs[row],title+"."+ROIno[row],Sliceno[row],Asubtitle[row],ROIno.length,frames,mean[row]);
		}else{
			if(!List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIno[row],date,channel,ROIno[row],title+"."+ROIno[row],Sliceno[row],ROIno.length,frames,mean[row]);
			if(List.get("seriesgrouping"))Aresultstring=newArray(title,title+"."+channel+"."+ROIno[row],date,channel,ROIno[row],title+"."+ROIno[row],Sliceno[row],Asubtitle[row],ROIno.length,frames,mean[row]);
		};
		AvariableResults=get_from_results_array(Aheading,row);
		Aresultstring=Array.concat(Aresultstring,AvariableResults);
		istring=a2resultsline(Aresultstring);
		resultstring+=istring;
	};
	File.append(resultstring,resultstringpath);
	resultstring="";
};
function write_resultstring_header(){
	resultstringpath=""+dir_save+origtitle2+"_dataset.txt";
	Adefaults=split(List.get("Parameter_bin"));
	Aheading=subset_array(AmeasureAbbrev,Adefaults);
	Aheading=remove_arrayEntry(Aheading,List.get("Measure"));
	if(List.get("CellClassification")){
		if(Exptype==1){
			sresultstringpath=""+dir_save+origtitle2+"_short_dataset.txt";
			if(stimulation){
				Aresultstring=newArray("Experiment.ID","Trace.ID","date","channel","ROI","ROI.Class","ROI.ID","total.ROI.number","Stimulation.after.frame","Time.for.reequilibration","No.of.frames","Baseline","Mean.change","line.Fitted.change","Min.change","Max.change","time",List.get("Measure"),"Norm."+List.get("Measure"));
				Asresultstring=newArray("Experiment.ID","Trace.ID","date","channel","ROI","ROI.Class","ROI.ID","total.ROI.number","Baseline","Mean.change","line.Fitted.change","Min.change","Max.change");
				Asresultstring=Array.concat(Asresultstring,Aheading);
				sresultstring=a2resultsline(Asresultstring);
				File.saveString(sresultstring,sresultstringpath);
			};
			if(!stimulation){
				Aresultstring=newArray("Experiment.ID","Trace.ID","date","channel","ROI","ROI.Class","ROI.ID","total.ROI.number","No.of.frames","time",List.get("Measure"));
			};
		};
		if(Exptype==0){
			if(!List.get("seriesgrouping"))Aresultstring=newArray("Experiment.ID","Measurement.ID","date","channel","ROI","ROI.Class","ROI.ID","ROI.from.slice","total.ROI.number","total.No.of.slices",List.get("Measure"));
			if(List.get("seriesgrouping"))Aresultstring=newArray("Experiment.ID","Measurement.ID","date","channel","ROI","ROI.Class","ROI.ID","ROI.from.slice","subtitle","total.ROI.number","total.No.of.slices",List.get("Measure"));
		};
	}else{
		if(Exptype==1){
			sresultstringpath=""+dir_save+origtitle2+"_short_dataset.txt";
			if(stimulation){
				Aresultstring=newArray("Experiment.ID","Trace.ID","date","channel","ROI","ROI.ID","total.ROI.number","Stimulation.after.frame","Time.for.reequilibration","No.of.frames","Baseline","Mean.change","line.Fitted.change","Min.change","Max.change","time",List.get("Measure"),"Norm."+List.get("Measure"));
				Asresultstring=newArray("Experiment.ID","Trace.ID","date","channel","ROI","ROI.ID","total.ROI.number","Baseline","Mean.change","line.Fitted.change","Min.change","Max.change");
				Asresultstring=Array.concat(Asresultstring,Aheading);
				sresultstring=a2resultsline(Asresultstring);
				File.saveString(sresultstring,sresultstringpath);
			};
			if(!stimulation){
				Aresultstring=newArray("Experiment.ID","Trace.ID","date","channel","ROI","ROI.ID","total.ROI.number","No.of.frames","time",List.get("Measure"));
			};
		};
		if(Exptype==0){
			if(!List.get("seriesgrouping"))Aresultstring=newArray("Experiment.ID","Measurement.ID","date","channel","ROI","ROI.ID","ROI.from.slice","total.ROI.number","total.No.of.slices",List.get("Measure"));
			if(List.get("seriesgrouping"))Aresultstring=newArray("Experiment.ID","Measurement.ID","date","channel","ROI","ROI.ID","ROI.from.slice","subtitle","total.ROI.number","total.No.of.slices",List.get("Measure"));
		};
	};
	Aresultstring=Array.concat(Aresultstring,Aheading);
	resultstring=a2resultsline(Aresultstring);
	File.saveString(resultstring,resultstringpath);
	resultstring="";
	sresultstring="";
};
function a2resultsline(array){
	line="";
	for(i=0;i<array.length;i++){
		if(i<(array.length-1))line=line+array[i]+"\t";
		if(i==(array.length-1))line=line+array[i]+"\n";	
	};
	return line;
};
function remove_arrayEntry(array,entry){
	c=0;
	while(c<array.length){
		if(array[c]==entry){
			bA=Array.slice(array,0,c);
			cA=Array.slice(array,c+1,array.length);
			array=Array.concat(bA,cA);			
		}else c++;
	};
	return array;
};
function removeDuplicates(aA){
	c=0;
	while(c<aA.length){
		if(isDuplicate(aA[c],aA)){
			bA=Array.slice(aA,0,c);
			cA=Array.slice(aA,c+1,aA.length);
			aA=Array.concat(bA,cA);			
		}else c++;
	};
	return aA;
	function isDuplicate(element,array){
		no=0;
		for(i=0;i<array.length;i++){
			if(element==array[i])no++;
		};
		if(no>1)return 1;
		if(no<=1)return 0;
	};
};
function array2string(array,delimiter){
	string="";
	for(i=0;i<array.length;i++){
		string+=""+array[i]+delimiter;
	};
	return string;
};
function subset_array(array,array_logic){
	if(array.length!=array_logic.length){
		return array;	
	}else{
		sarray=newArray(0);
		for(i=0;i<array.length;i++){
			if(array_logic[i]==1){
				sarray=Array.concat(sarray,array[i]);
			};
		};
		return sarray;
	};
};
function calculate_SE(transfer_seCorr,donor,acceptor,transfer,alpha,beta,gamma,delta){//Rbleedthrough,Rcrossexitation
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	alpha=parseFloat(alpha);
	beta=parseFloat(beta);
	gamma=parseFloat(gamma);
	delta=parseFloat(delta);
	donor_corr="Corrected "+donor;
	acceptor_corr="Corrected "+acceptor;
	selectWindow(donor);
	wait(100);
	run("Duplicate...", "title=["+donor_corr+"] duplicate range=1-["+nSlices+"]");
	selectWindow(acceptor);
	wait(100);
	run("Duplicate...", "title=["+acceptor_corr+"] duplicate range=1-["+nSlices+"]");
	selectWindow(transfer);
	wait(100);
	run("Duplicate...", "title=["+transfer_seCorr+"] duplicate range=1-["+nSlices+"]");
	selectWindow(donor_corr);
	wait(100);
	run("Multiply...", "value=["+beta+"] stack");
	selectWindow(acceptor_corr);
	wait(100);
	acceptor_factor=gamma-alpha*beta;
	run("Multiply...", "value=["+acceptor_factor+"] stack");
	imageCalculator("Subtract stack", transfer_seCorr,donor_corr);
	imageCalculator("Subtract stack", transfer_seCorr,acceptor_corr);
	selectWindow(transfer_seCorr);
	wait(100);
	corr=1-beta*delta;
	run("Divide...", "value=["+corr+"] stack");
	if(isOpen(donor_corr)){
		selectWindow(donor_corr);
		wait(100);
		close();
	};
	if(isOpen(acceptor_corr)){
		selectWindow(acceptor_corr);
		close();
	};
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
	return transfer_seCorr;
};
function calculate_colocalization(Ri,Gi,noofcolocch){
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	run("Conversions...", " ");
	run("Select None");
	if(List.get("Coloc_Pearson")||List.get("Coloc_Slope")){
	//create Ravg and Gavg
		Ri_Ravg="Ri - Ravg";
		Gi_Gavg="Gi - Gavg";
		Ravg="Ravg of "+Ri;
		Gavg="Gavg of "+Gi;
		Ri_Ravg_x_Gi_Gavg="(Ri-Ravg) * (Gi-Gavg)";
		Sum_Ri_Ravg_x_Gi_Gavg="Sum((Ri-Ravg) * (Gi-Gavg))";
		sum_square_Ri="Sum (square(Ri-Ravg))";
		sum_square_Gi="Sum (square(Gi-Gavg))";
		sum_square_Ri_Ravg="Sum (square(Ri-Ravg))";
		sum_square_Gi_Gavg="Sum (square(Gi-Gavg))";
		denominator="Denominator";
		//
		replace_ROIs_with_mean(Ri,Ravg,"Mean");
		replace_ROIs_with_mean(Gi,Gavg,"Mean");
	//create Ri_Ravg and Gi_Gavg
		imageCalculator("Subtract create 32-bit stack", Ri,Ravg);
		run("Rename...", "title=["+Ri_Ravg+"]");
		run("32-bit");
		imageCalculator("Subtract create 32-bit stack", Gi,Gavg);
		run("Rename...", "title=["+Gi_Gavg+"]");
		if(isOpen(Ravg)){
			selectWindow(Ravg);
			wait(100);
			close();
		};
		if(isOpen(Gavg)){
			selectWindow(Gavg);
			wait(100);
			close();
		};
	//create Ri_Ravg * Gi_Gavg
		imageCalculator("Multiply create 32-bit stack",Ri_Ravg,Gi_Gavg);
		run("Rename...", "title=["+Ri_Ravg_x_Gi_Gavg+"]");
	//Create Mean of Ri_Ravg_x_Gi_Gavg
		replace_ROIs_with_mean(Ri_Ravg_x_Gi_Gavg,Sum_Ri_Ravg_x_Gi_Gavg,"RawIntDen");
		if(isOpen(Ri_Ravg_x_Gi_Gavg)){
			selectWindow(Ri_Ravg_x_Gi_Gavg);
			wait(100);
			close();
		};
	//Create sum_squared
		selectWindow(Ri_Ravg);
		wait(100);
		run("Square", "stack");
		replace_ROIs_with_mean(Ri_Ravg,sum_square_Ri_Ravg,"RawIntDen");	
		selectWindow(Gi_Gavg);
		wait(100);
		run("Square", "stack");
		replace_ROIs_with_mean(Gi_Gavg,sum_square_Gi_Gavg,"RawIntDen");	
		if(isOpen(Ri_Ravg)){
			selectWindow(Ri_Ravg);
			wait(100);
			close();
		};
		if(isOpen(Gi_Gavg)){
			selectWindow(Gi_Gavg);
			wait(100);
			close();
		};
		if(List.get("Coloc_Slope")){
			imageCalculator("Divide create 32-bit stack",Sum_Ri_Ravg_x_Gi_Gavg,sum_square_Ri_Ravg);
			run("Rename...", "title=["+List.get("ColocName_Slope"+noofcolocch)+"]");
			setMinAndMax(0, 1);
			run("Fire");
		};
		if(List.get("Coloc_Pearson")){
			imageCalculator("Multiply create 32-bit stack",sum_square_Ri_Ravg,sum_square_Gi_Gavg);
			run("Rename...", "title=["+denominator+"]");
			selectWindow(denominator);
			wait(100);
			run("Square Root", "stack");
			imageCalculator("Divide create 32-bit stack",Sum_Ri_Ravg_x_Gi_Gavg,denominator);
			run("Rename...", "title=["+List.get("ColocName_Pearson"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
		};
		if(isOpen(sum_square_Ri_Ravg)){
			selectWindow(sum_square_Ri_Ravg);
			wait(100);
			close();
		};
		if(isOpen(sum_square_Gi_Gavg)){
			selectWindow(sum_square_Gi_Gavg);
			wait(100);
			close();
		};
		if(isOpen(Sum_Ri_Ravg_x_Gi_Gavg)){
			selectWindow(Sum_Ri_Ravg_x_Gi_Gavg);
			wait(100);
			close();
		};
		if(isOpen(denominator)){
			selectWindow(denominator);
			wait(100);
			close();
		};
	};
	if(List.get("Coloc_Manders_M")||List.get("Coloc_Intersection")){
		trRi="tr Ri";
		trGi="tr Gi";
		sum_trRi="Sum(tr Ri)";
		sum_trGi="Sum(tr Gi)";
		trRitrGi="tr Ri * tr Gi";
		sum_trRitrGi="Sum(tr Ri * tr Gi)";
		sum_Ri="Sum Ri";
		sum_Gi="Sum Gi";
		RitrGi="Ri * tr Gi";
		trRiGi="tr Ri * Gi";
		sum_RitrGi="Sum(Ri * tr Gi)";
		sum_trRiGi="Sum(tr Ri * Gi)n";
	//Calculate trGi and trRi
		selectWindow(Ri);
		wait(100);
		run("Duplicate...", "title=["+trRi+"] duplicate range=1-["+nSlices+"]");
		selectWindow(trRi);
		wait(100);
		run("32-bit");
		transform_to_coloc_mask(trRi,"minvalue-tr-"+Ri,1,1,List.get("thresholdmethod"),List.get("processguieachloop"));
		make_real_binary(trRi);
		selectWindow(Gi);
		wait(100);
		run("Duplicate...", "title=["+trGi+"] duplicate range=1-["+nSlices+"]");
		selectWindow(trGi);
		wait(100);
		run("32-bit");
		transform_to_coloc_mask(trGi,"minvalue-tr-"+Gi,1,1,List.get("thresholdmethod"),List.get("processguieachloop"));
		make_real_binary(trGi);
	//calculate trRitrGi and trRiGi and RitrGi
		if(List.get("Coloc_Intersection")){
			imageCalculator("Multiply create 32-bit stack",trRi,trGi);
			run("Rename...", "title=["+trRitrGi+"]");
		};
		if(List.get("Coloc_Manders_M")){
			imageCalculator("Multiply create 32-bit stack",trRi,Gi);
			run("Rename...", "title=["+trRiGi+"]");
			imageCalculator("Multiply create 32-bit stack",Ri,trGi);
			run("Rename...", "title=["+RitrGi+"]");
		};
	//Calculate Sums of sum_triGi and sum_trRi and sum_trRitrGi and sum_RitrGi and sum_trRiGi
		if(List.get("Coloc_Intersection")){
			replace_ROIs_with_mean(trRi,sum_trRi,"RawIntDen");	
			replace_ROIs_with_mean(trGi,sum_trGi,"RawIntDen");	
			replace_ROIs_with_mean(trRitrGi,sum_trRitrGi,"RawIntDen");
			if(isOpen(trRitrGi)){
				selectWindow(trRitrGi);
				wait(100);
				close();
			};
		};
		if(isOpen(trRi)){
			selectWindow(trRi);
			wait(100);
			close();
		};
		if(isOpen(trGi)){
			selectWindow(trGi);
			wait(100);
			close();
		};	
		if(List.get("Coloc_Manders_M")){
			replace_ROIs_with_mean(trRiGi,sum_trRiGi,"RawIntDen");
			if(isOpen(trRiGi)){
				selectWindow(trRiGi);
				wait(100);
				close();
			};
			replace_ROIs_with_mean(RitrGi,sum_RitrGi,"RawIntDen");
			if(isOpen(RitrGi)){
				selectWindow(RitrGi);
				wait(100);
				close();
			};
			replace_ROIs_with_mean(Ri,sum_Ri,"RawIntDen");
			replace_ROIs_with_mean(Gi,sum_Gi,"RawIntDen");
		};
		if(List.get("Coloc_Manders_M")){
			imageCalculator("Divide create 32-bit stack",sum_RitrGi,sum_Ri);
			run("Rename...", "title=["+List.get("ColocName_Manders_M1"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
			wait(100);
			if(isOpen(sum_RitrGi)){
				selectWindow(sum_RitrGi);
				wait(100);
				close();
			};
			if(isOpen(sum_Ri)){
				selectWindow(sum_Ri);
				wait(100);
				close();
			};
			imageCalculator("Divide create 32-bit stack",sum_trRiGi,sum_Gi);
			run("Rename...", "title=["+List.get("ColocName_Manders_M2"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
			if(isOpen(sum_trRiGi)){
				selectWindow(sum_trRiGi);
				wait(100);
				close();
			};
			if(isOpen(sum_Gi)){
				selectWindow(sum_Gi);
				wait(100);
				close();
			};
		};
		if(List.get("Coloc_Intersection")){
			imageCalculator("Divide create 32-bit stack",sum_trRitrGi,sum_trRi);
			run("Rename...", "title=["+List.get("ColocName_Intersection_i1"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
			wait(100);
			if(isOpen(sum_trRi)){
				selectWindow(sum_trRi);
				wait(100);
				close();
			};
			imageCalculator("Divide create 32-bit stack",sum_trRitrGi,sum_trGi);
			run("Rename...", "title=["+List.get("ColocName_Intersection_i2"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
			if(isOpen(sum_trGi)){
				selectWindow(sum_trGi);
				wait(100);
				close();
			};
			if(isOpen(sum_trRitrGi)){
				selectWindow(sum_trRitrGi);
				wait(100);
				close();
			};
		};
	};
	if(List.get("Coloc_Overlap")||List.get("Coloc_Manders_k")){	
	//create Ri*Gi
		RiGi="Ri*Gi";
		Sum_RiGi="Sum(Ri*Gi)";
		square_Ri="square(Ri-Ravg)";
		square_Gi="square(Gi-Gavg)";
		sum_square_Ri="Sum (square(Ri-Ravg))";
		sum_square_Gi="Sum (square(Gi-Gavg))";
		denominator="denominator_Overlap";
		imageCalculator("Multiply create 32-bit stack",Ri,Gi);
		run("Rename...", "title=["+RiGi+"]");
	//Create Mean of and Ri*Gi
		replace_ROIs_with_mean(RiGi,Sum_RiGi,"RawIntDen");
		if(isOpen(RiGi)){
			selectWindow(RiGi);
			wait(100);
			close();
		};
	//Create Sum_squared
		selectWindow(Ri);
		wait(100);
		run("Duplicate...", "title=["+square_Ri+"] duplicate range=1-["+nSlices+"]");
		selectWindow(square_Ri);
		wait(100);
		run("32-bit");
		run("Square", "stack");
		replace_ROIs_with_mean(square_Ri,sum_square_Ri,"RawIntDen");	
		if(isOpen(square_Ri)){
			selectWindow(square_Ri);
			wait(100);
			close();
		};
		selectWindow(Gi);
		run("Duplicate...", "title=["+square_Gi+"] duplicate range=1-["+nSlices+"]");
		selectWindow(square_Gi);
		wait(100);
		run("32-bit");
		run("Square", "stack");
		replace_ROIs_with_mean(square_Gi,sum_square_Gi,"RawIntDen");	
		if(isOpen(square_Gi)){
			selectWindow(square_Gi);
			wait(100);
			close();
		};
		if(List.get("Coloc_Overlap")){
			imageCalculator("Multiply create 32-bit stack",sum_square_Ri,sum_square_Gi);
			run("Rename...", "title=["+denominator+"]");
			selectWindow(denominator);
			wait(100);
			run("Square Root", "stack");
			imageCalculator("Divide create 32-bit stack",Sum_RiGi,denominator);
			run("Rename...", "title=["+List.get("ColocName_Overlap"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
			if(isOpen(denominator)){
				selectWindow(denominator);
				wait(100);
				close();
			};
		};	
		if(List.get("Coloc_Manders_k")){
			imageCalculator("Divide create 32-bit stack",Sum_RiGi,sum_square_Ri);
			run("Rename...", "title=["+List.get("ColocName_Manders_k1"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
			wait(100);
			imageCalculator("Divide create 32-bit stack",Sum_RiGi,sum_square_Gi);
			run("Rename...", "title=["+List.get("ColocName_Manders_k2"+noofcolocch)+"]");
			setMinAndMax(0,1);
			run("Fire");
		};
		if(isOpen(Sum_RiGi)){
			selectWindow(Sum_RiGi);
			wait(100);
			close();
		};
		if(isOpen(sum_square_Ri)){
			selectWindow(sum_square_Ri);
			wait(100);
			close();
		};
		if(isOpen(sum_square_Gi)){
			selectWindow(sum_square_Gi);
			wait(100);
			close();
		};	
	};
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
};
function transform_to_coloc_mask(channel,minvaluename,rep,thresholding,thresholdmethod,processguieachloop){
	selectWindow(channel);
	wait(100);
	frames=nSlices;
	run("Select None");
	resize();
	getLocationAndSize(x, y, width, height);
	setLocation(width,0);
	Atlim=threshold_channel(channel,thresholding,thresholdmethod,rep,processguieachloop,List.get(minvaluename));
	List.set(minvaluename,Atlim[0]);
	maxvalue=Atlim[1];
	selectWindow(channel);
	wait(100);
	setThreshold(parseFloat(List.get(minvaluename)), maxvalue);
	if(List.get("thresholding")==3)run("Convert to Mask", "method="+List.get("thresholdmethod")+" background=Default calculate black");
	if(List.get("thresholding")!=3)run("Convert to Mask", "method=Default background=Default black");
	resetThreshold();
};
function transform_markermask(channel){
	selectWindow(channel);
	wait(100);
	slices=nSlices;
	for(i=0;i<slices;i++){
		setSlice(i+1);
		run("Select All");
		setBackgroundColor(0, 0, 0);
		run("Clear", "slice");
	};
	replace_ROIs_with_value(channel,255);
};
function replace_ROIs_with_value(channel,value){
	selectWindow(channel);
	wait(100);
	run("Select None");
	run("Clear Results");
	selectWindow(channel);
	wait(100);
	nf=nSlices;
	ROIs=roiManager("count");
	roiManager("Deselect");
	if(Exptype==0){
		roiManager("Associate", "true");
		roiManager("Show All");
		for (ROI =0; ROI < ROIs; ROI++){
			roiManager("Select", ROI);
			setColor(value);
			fill();
		};
	};
	if(Exptype==1){
		roiManager("Associate", "false");
		for(i=0;i<nf;i++){
			for(ROI=0;ROI<ROIs;ROI++){
				roiManager("Select", ROI);
				roiManager("Remove Slice Info");
				setSlice(i+1);
				roiManager("Select", ROI);
				setColor(value);
				fill();
			};
		};
	};
	run("Select None");
	run("Clear Results");
};
function create_mask_from_ROIs(channel){
	mask="Binary mask of "+channel;
	selectWindow(channel);
	wait(100);
	frames=nSlices;
	run("Select None");
	run("Duplicate...", "title=["+mask+"] duplicate range=1-["+frames+"]");	
	selectWindow(mask);
	wait(100);
	run("8-bit");	
	transform_markermask(mask);
	resize();
	setLocation(width,0);
	return mask;
};
function manual_cell_classification(channel,Aclasses){
	closing=false;
	if(List.get("classificationchannel")!=List.get("segmentationchannel")){
		if(Exptype==0){
			i_channel=create_thresholdchannel(List.get("classificationchannel"));
		};
		if(Exptype==1){
			i_channel=create_thresholdpic(List.get("classificationchannel"),List.get("segmentationprojection"));
		};
		closing=true;
	}else{
		if(!isOpen(channel)){
			if(Exptype==0){
				i_channel=create_thresholdchannel(List.get("segmentationchannel"));
			};
			if(Exptype==1){
				i_channel=create_thresholdpic(List.get("segmentationchannel"),List.get("segmentationprojection"));
			};
			closing=true;
		}else{
			closing=false;
			i_channel=channel;
		};
	};
	if(Exptype==0){
		roiManager("Associate", "true");
	};
	if(Exptype==1){
		roiManager("Associate", "false");
	};
	mask="Cell Classification Mask of "+i_channel;
	amountrois=roiManager("count");
	AROIclass=newArray(amountrois);
	for(i=0;i<amountrois;i++){
		AROIclass[i]="not classified";
	};
	selectWindow(i_channel);
	wait(100);
	frames=nSlices;
	run("Duplicate...", "title=["+mask+"] duplicate range=1-["+frames+"]");
	selectWindow(mask);
	run("8-bit");
	run("Fire");
	wait(100);
	run("Divide...", "value=2 stack");
	run("Subtract...", "value=1 stack");
	selectWindow(mask);
	wait(100);
	setForegroundColor(255, 255, 255);
	color=getValue("foreground.color");
	color=color-1;
	getLocationAndSize(x, y, width, height);
	setLocation(0,0);
	setThreshold(color, 255);
	if(List.get("runbatchmode")){
		if(isOpen(mask)){
			selectWindow(mask);
			wait(100);
			setBatchMode("show");
		};
	};
	for(i=0;i<Aclasses.length;i++){
		set_Tool("Pencil Tool");
		selectWindow(mask);
		wait(100);
		mask2=mask+" class "+Aclasses[i];
		run("Duplicate...", "title=["+mask2+"] duplicate range=1-["+frames+"]");
		selectWindow(mask2);
		for(c=0;c<amountrois;c++){
			if(AROIclass[c]!="not classified"){
				roiManager("Select", c);
				run("Clear");
				run("Select None");
			};
		};
		wait(100);
		setLocation(0,0);
		roiManager("Show All");
		arrange_and_wait(0,mask2,List.get("classificationchannel"),"Please mark cells that belong to class '"+Aclasses[i]+"'. \nDraw a point or a line in the corresponding cells with the 'Pencil Tool' in the top left image '"+mask2+"'.\nThen press OK.",0,"Pencil Tool");
		batchmode=is("Batch Mode");
		if(!batchmode){
			setBatchMode(true);
		};
		selectWindow(mask2);
		wait(100);
		setBatchMode("hide");
		color=getValue("foreground.color");
		color=color-1;
		setThreshold(color, 255);
		run("Convert to Mask", "method=Default background=Dark black");
		for(ROI=0;ROI<amountrois;ROI++){
			selectWindow(mask2);
			run("Select None");
			run("Clear Results");
			roiManager("Select", ROI);
			getStatistics(area, mean);
			run("Select None");
			if(mean>0){
				AROIclass[ROI]=Aclasses[i];
			};
		};
		if(isOpen(mask2)){
			selectWindow(mask2);
			wait(100);
			close();
		};
		if(!List.get("runbatchmode"))setBatchMode("exit and display");
	};
	if(List.get("runbatchmode")){
		batchmode=is("Batch Mode");
		if(!batchmode){
			setBatchMode(true);
		};
		if(isOpen(channel)){
			selectWindow(channel);
			setBatchMode("hide");
		};
	};
	if(closing){
		if(isOpen(i_channel)){
			selectWindow(i_channel);
			wait(100);
			close();
		};
	};
	if(isOpen(mask)){
		selectWindow(mask);
		wait(100);
		close();
	};
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
	return AROIclass;
};
function create_manual_mask(channel,name){
	mask=""+name+" mask of "+channel;
	selectWindow(channel);
	wait(100);
	frames=nSlices;
	run("Duplicate...", "title=["+mask+"] duplicate range=1-["+frames+"]");
	selectWindow(mask);
	run("8-bit");
	run("Fire");
	wait(100);
	run("Divide...", "value=2 stack");
	run("Subtract...", "value=1 stack");
	selectWindow(mask);
	//run("Enhance Contrast", "saturated=0.35");
	setForegroundColor(255, 255, 255);
	color=getValue("foreground.color");
	setColor(color);
	color=color-1;
	selectWindow(mask);
	resize();
	getLocationAndSize(x, y, width, height);
	setLocation(0,0);
	setThreshold(color, 255);
	if(List.get("runbatchmode")){
		if(isOpen(mask)){
			selectWindow(mask);
			wait(100);
			setBatchMode("show");
		};
	};
	resize();
	set_Tool("Pencil Tool");
	waitForUser("Please manually classify pixels by using the Pencil Tool in the "+mask+".\nThis is information is used to classify "+name+" pixels.\nThen press OK.");
	setLocation(x,y);
	batchmode=is("Batch Mode");
	if(!batchmode){
		setBatchMode(true);
	};
	selectWindow(mask);
	wait(100);
	setBatchMode("hide");
	if(List.get("runbatchmode")){
		if(isOpen(channel)){
			selectWindow(channel);
			setBatchMode("hide");
		};
	};
	selectWindow(mask);
	wait(100);
	color=getValue("foreground.color");
	color=color-1;
	setThreshold(color, 255);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Divide...", "value=255 stack");
	setMinAndMax(0, 1);
	wait(100);
	if(!List.get("runbatchmode"))setBatchMode("exit and display");
	return mask;
};