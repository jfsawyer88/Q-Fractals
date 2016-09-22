///////////////////////////////////////
// iterated funciton system fractals //
///////////////////////////////////////

\l bmp.q  / load function to output bitmaps

/ draw a ifs fractal given matrix transformations
draw_IFS:{[file; ms; win; wh; iterations]
 IFS: wh#0; / iniitalize each pixel as white
 ptp: ({[a;c;b;d;w;h;x] floor ((x) - (a,c)) % ((b-a),(d-c))%(w,h)}.)(win,wh); / point to pixel
 fil: {[x;wh](flip x) where all (x>=0) and (x<wh)}[;wh]; / filter out points outside of window
 rt: {x mmu y rand count y}[;ms]; / random transformation
 indices: fil ptp 2#flip iterations rt\ 100 rt/ 0.1 0.1 1;        / indices to color
 IFS: (reverse wh)#@[raze IFS;;:;1] sum (1, wh[0])* flip indices; / update IFS
 write_bmp[file; (0xffffff;0x000000) reverse IFS] / reverse since y axis
                                                  / is indexed downwards
 }

//////////////////////////////
// Functions to help build
// matrix transformations
//
/rotation matrix, input in degrees
rotat: {`float${(cos[x], sin[x], 0; neg[sin[x]], cos[x], 0; 0 0 1)} (2*acos[0])*x%180}
/scaling matrix
scale:{`float$(x, 0 0; 0, y, 0;0 0 1)}
/translation matrix
trans:{`float$(1 0 0;0 1 0; x, y, 1)}
//////////////////////////////
