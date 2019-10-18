/* DATA step to create the "hat" data */
data hat; 
	do x = -5 to 5 by .5;
		do y = -5 to 5 by .5;
			z = sin(sqrt(y*y + x*x));
			output;
		end;
	end;
run;	

/* The G3D procedure plots the data in */
/* the shape of a cowboy hat           */
proc g3d data=hat;
	plot y*x=z;
run;
