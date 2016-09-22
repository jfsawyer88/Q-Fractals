//////////////////////////
// examples outputs for //
// various fractals     //
//////////////////////////


///////////////////////////////////////////////////////////////////
/ the mandelbrot set
\l mandelbrot.q

\ts draw_mandelbrot[
 `:mandelbrot.bmp;
 2000;
 -2 0.5;
 -1.15 1.15;
 48
 ]

/ zooming into the mandelbrot set
zoom_inputs: flip
 (hsym `${"mandelbrot_zoom",x,".bmp"} each string each 1+til 7;
 reverse 0.161250 + 2 5 8 13 20 35 70 *\: -0.01 0.01;
 reverse 0.638438 + 2 5 8 13 20 35 70 *\: -0.01 0.01)
\ts (draw_mandelbrot[ ;2000; ; ;48].) each zoom_inputs


///////////////////////////////////////////////////////////////////
/ julia sets
\l julia.q

\ts draw_julia[
 `:julia.bmp;
 3000;
 -1.5 1.5;
 -1 1;
 250;
 -0.7269 0.1889
 ]


///////////////////////////////////////////////////////////////////
/ iterated function systems
\l ifs.q

/ matrix transformations for sierpenski triangle
sier0: scale[0.5;0.5] mmu trans[0.00;0.0]
sier1: scale[0.5;0.5] mmu trans[0.50;0.0]
sier2: scale[0.5;0.5] mmu trans[0.25;0.5]
sier:(sier0;sier1;sier2)
\ts draw_IFS[`sierpenski_triangle.bmp; sier; 0 0 1 1; 1000 1000; 1000000]


/ fractal words

/////////////////////
/ initials JFS

/ three strokes for J
j0:scale[0.280;0.1] mmu rotat[ 0] mmu trans[0.00;0.9]
j1:scale[0.360;0.1] mmu rotat[90] mmu trans[0.45;0.0]
j2:scale[0.125;0.1] mmu rotat[ 0] mmu trans[0.00;0.0]
J: (j0;j1;j2)

/ three strokes for F
f0:scale[0.12;0.1] mmu rotat[ 0] mmu trans[1.075;0.90]
f1:scale[0.13;0.1] mmu rotat[ 0] mmu trans[1.075;0.45]
f2:scale[0.40;0.1] mmu rotat[90] mmu trans[1.050;0.00]
F:(f0;f1;f2)

/ five strokes for S
s0:scale[0.19;0.1] mmu rotat[ 0] mmu trans[1.95;0.90]
s1:scale[0.15;0.1] mmu rotat[ 0] mmu trans[1.95;0.45]
s2:scale[0.19;0.1] mmu rotat[ 0] mmu trans[1.85;0.00]
s3:scale[0.21;0.1] mmu rotat[90] mmu trans[1.92;0.45]
s4:scale[0.21;0.1] mmu rotat[90] mmu trans[2.44;0.00]
S:(s0;s1;s2;s3;s4)

\t draw_IFS[`JFS.bmp; (J,F,S); 0 0 2.5 1; 1250 500; 1000000]
