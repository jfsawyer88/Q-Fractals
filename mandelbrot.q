/////////////////////////////////////
// here we have a function to draw //
// the mandelbrot set and write    //
// it to a given file              //
/////////////////////////////////////

\l bmp.q  / load function to output bitmaps
sq:{x*x}  / squaring function


/ functional update for mandelbrot table
update_mandelbrot:{[mandelbrot]
 c:enlist (<;(+;(sq;`z_x);(sq;`z_y));4); / only update where pixel where
                                         / pixel has not yet escaped
 a:`z_x`z_y`esc!(
  (+;`c_x;(-;(sq;`z_x);(sq;`z_y))); / update real part
  (+;`c_y;(*;2;(*;`z_x;`z_y)));     / update imaginary part
  (+;1;`esc)                        / increment escape time
  );
 ![mandelbrot;c;0b;a] / NB: no groupbys
 }


///////////////////////////////////////////////
/ draw the mandelbrot set colored
/ based on escape time algorithm
draw_mandelbrot:{[file;width;xrange;yrange;iterations]
 height: `long$(yrange[1]-yrange[0]) * width % xrange[1]-xrange[0];
 shape:   height,width;  / resolution of image
 npixels: height*width;  / number of pixels
 pixel_width:  (deltas xrange)[1] %  width; /  width of each pixel
 pixel_height: (deltas yrange)[1] % height; / height of each pixel

 palette:({0x00,/:x,'x})`byte$floor(255%6-1)*til 6; /color palette, black to cyan

 mandelbrot:([]
  z_x: npixels# 0f;  / x and y values of z coordinates
  z_y: npixels# 0f;  / all initialized to (0,0)
  esc: npixels#-1j;  / when the pixel blows up (or escapes)
                     / NB: they all survive the first iteration
  c_x: xrange[0]+pixel_width *   npixels#         til width;  / c coordinates
  c_y: yrange[0]+pixel_height*raze width#'reverse til height  / filling window
  );

 / escape time for each pixel
 / adjust escape time so that colors will be selected cyclically
 / force the escape time corresponding to the mandelbrot set to be black
 esc_time:(iterations update_mandelbrot/ mandelbrot) `esc;
 esc_time:@[esc_time; where esc_time=iterations-1  ;: ;0N] mod count palette;
 esc_time:@[esc_time; where null esc_time ;: ;count palette];

 / write to file
 write_bmp[file; (palette,enlist 0x000000) shape#esc_time]
 }
