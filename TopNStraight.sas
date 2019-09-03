/*************************************************/
/* Copyright 2008-2010 SAS Institute Inc.        */
/* Top N report for entire data set              */
/* Use macro variables to customize the data     */
/* source.                                       */
/* DATA - SAS library.member for input data      */
/* REPORT - column to report on                  */
/* MEASURE - column to measure for the report    */
/* MEASUREFORMAT - specify to preserve measure   */
/*  format in the report (currency, for example) */
/* STAT - SUM or MEAN                            */
/* N - The "N" in Top N - how many to show       */ asdf
/*************************************************/
%let data=SASHELP.CARS;
%let report=MODEL;
%let measure=INVOICE;
%let measureformat=%str(format=DOLLAR12.2);
%let stat=SUM;
%let n=10;
title "Top Models by Invoice price";
footnote;
/* summarize the data and store */
/* the output in an output data set */
proc means data=&data &stat noprint;
	var &measure;
	class &report;
	output out=summary &stat=&measure /levels;
run;

/* store the value of the measure for ALL rows and 
/* the row count into a macro variable for use  */
/* later in the report */
proc sql noprint;
select &measure,_FREQ_ into :overall,:numobs
from summary where _TYPE_=0;
quit;

/* sort the results so that we get the TOP values */
/* rising to the top of the data set */
proc sort data=work.summary out=work.topn;
  where _type_>0;
  by descending &measure;
run;

/* Pass through the data and output the first N */
/* values  */
data topn;
  length rank 8;
  label rank="Rank";
  set topn;
  by descending &measure;
  rank+1;
  if rank le &n then output;
run;

/* Create a report listing for the top values */
footnote2 "&stat of &measure for ALL values of &report: &overall (&numobs total rows)";
proc report data=topn;
	column rank &report &measure;
	define rank /display;
	define &measure / analysis &measureformat;	
run;
quit; 

/* Create a simple bar graph for the data to show the rankings */
/* and relative values */
goptions xpixels=600 ypixels=400;
proc gchart data=topn
;
	hbar &report / 
		sumvar=&measure
		descending
		nozero
		clipref
		frame	
		discrete
		type=&stat
;
run;
quit;
