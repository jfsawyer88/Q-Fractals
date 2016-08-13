/////////////////////////////////////
// here we have a function to draw //
// the mandelbrot set and write    //
// it to a given file              //
/////////////////////////////////////

\l bmp.q
sq:{x*x}


///////////////////////////////////////////////////
/ mandelbrot table
/ contains information for each pixel
mandelbrot:([]
 z_x:       `float$();
 z_y:       `float$();
 magnitude: `float$();
 c_x:       `float$();
 c_y:       `float$()
 )
 
draw_mandelbrot:{[file; width; height; xrange; yrange; iterations]

 / purge any previous data
 delete from `mandelbrot;
 
 shape:   height,width;
 npixels: height*width;
 pixel_width:  (deltas xrange)[1] % width;
 pixel_height: (deltas yrange)[1] % height;
 
 `mandelbrot insert (
  npixels#0f;  / x and y values of z coordinates
  npixels#0f;  / all initialized to (0,0)
  npixels#0f;  / (square of) magnitude of each z value
  xrange[0]+pixel_width *   npixels#         til width;  / c coordinates
  yrange[0]+pixel_height*raze width#'reverse til height  / filling window
  );

 / iterate the p_c polynomials on
 / the origin 'iterations' times
 do[iterations;
  update
  z_x: c_x + sq[z_x] - sq[z_y],
  z_y: c_y + 2 * z_x * z_y,
  magnitude: sq[z_x]+sq[z_y]
  from `mandelbrot where magnitude < 4  / note that we need only worry
  ];                                    / about pixels whose magnitude < 4

 / light up only those pixels whose magnitude < 4
 /write_bmp[file; (0x000000;0xffff00) shape#4>mandelbrot `magnitude]
 /blue
 write_bmp[file; (0x000000;0x8080ff) shape#4>mandelbrot `magnitude]
 }  



///////////////////////////////////////////////
/ draw the mandelbrot set with shading
/ based on when the pixel explodes
mandelbrot_shading:([]
 z_x:       `float$();
 z_y:       `float$();
 magnitude: `float$();
 level:      `long$();
 c_x:       `float$();
 c_y:       `float$()
 )

draw_mandelbrot_shading:{[file; width; height; xrange; yrange; iterations]

 / purge any previous data
 delete from `mandelbrot_shading;

 shape:   width,height;
 npixels: width*height;
 pixel_width:  (deltas xrange)[1] % width;
 pixel_height: (deltas yrange)[1] % height;

 `mandelbrot_shading insert (
  npixels# 0f;  / z_x:       x and y values of z coordinates
  npixels# 0f;  / z_y:       all initialized to (0,0)
  npixels# 0f;  / magnitude: (square of) magnitude of each z value
  npixels#-2j;  / level:     when the pixel blows up
  xrange[0]+pixel_width *   npixels#         til width;  / c_x: c coordinates
  yrange[0]+pixel_height*raze width#'reverse til height  / c_y: filling window
  );

 do[iterations;
  update
  z_x: c_x + sq[z_x] - sq[z_y],
  z_y: c_y + 2 * z_x * z_y,
  magnitude: sq[z_x]+sq[z_y],
  level: level+1
  from `mandelbrot_shading where magnitude < 4  / note that we need only worry
  ];                                            / about pixels whose magnitude < 4

 update magnitude: sq[z_x]+sq[z_y], level: level+1 from `mandelbrot_shading where magnitude < 4;
 update level:level+1 from `mandelbrot_shading where magnitude < 4;
  
 shades:{0x00,/:x,\:0x00}`byte$floor(255%6-1)*til 6; /green
 write_bmp[file; shades shape#(mandelbrot_shading `level) mod 6]
 }
