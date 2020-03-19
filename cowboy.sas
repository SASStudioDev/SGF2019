/*This sas file creates a cowboy hat graphic using proc g3d and some math.*/
goptions cback=black colors=(white cyan red conflict yellow);

data hat;
   do x=-5 to 5 by .25;
      do y=-5 to 5 by .25;
         z=sin(sqrt(xaaaaaaa*x + y*y));
         output;
      end;
   end;
run;asdf
title1 c=white f=swiss 'The Cowboy Hat';
title2 h=2 angle=90 ' ';
asdas
proc g3d data=hat;
   plot y*x=z / ctop=goldenrod ctext=white;
run; run;run;
asdf