/////////////////////////////////
// now we can draw a julia set //
/////////////////////////////////

\l bmp.q
sq:{x*x}


/ functional update for julia table
update_julia:{[julia; c_x; c_y]
 c:enlist (<;(+;(sq;`z_x);(sq;`z_y));4); / only update where pixel where
                                         / pixel has not yet escaped
 a:`z_x`z_y!(
  (+;c_x;(-;(sq;`z_x);(sq;`z_y))); / update real part
  (+;c_y;(*;2;(*;`z_x;`z_y)))      / update imaginary part
  );
 ![julia;c;0b;a] / NB: no groupbys
 }

/ functional exec, outputs boolean
/ indicating whether or not the
/ pixel escaped
julia_esc:{[julia]
 ?[julia;();();(+;(sq;`z_x);(sq;`z_y))] < 4
 }


///////////////////////////////////////////////
/ draw a julia set
draw_julia:{[file;width;xrange;yrange;iterations; c]
 height: `long$(yrange[1]-yrange[0]) * width % xrange[1]-xrange[0];
 shape:   height,width;  / resolution of image
 npixels: height*width;  / number of pixels
 pixel_width:  (deltas xrange)[1] %  width; /  width of each pixel
 pixel_height: (deltas yrange)[1] % height; / height of each pixel

 julia:([]
  z_x: xrange[0]+pixel_width *   npixels#         til width;  / z coordinates
  z_y: yrange[0]+pixel_height*raze width#'reverse til height  / filling window
  );

 / boolean, whether or not pixel escaped
 esc: julia_esc iterations update_julia[;c[0];c[1]]/ julia;

 / write to file
 write_bmp[file; (0x000000;0x0000ff) shape#esc]
 }
