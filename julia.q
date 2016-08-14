/////////////////////////////////
// now we can draw a julia set //
/////////////////////////////////

\l bmp.q
sq:{x*x}


draw_julia:{[file; width; height; xrange; yrange; iterations; c]

 / purge any previous data
 delete from `julia;

 shape:   height,width;
 npixels: height*width;
 Pixel_width:  (deltas xrange)[1] % width;
 pixel_height: (deltas yrange)[1] % height;

 `julia_shading insert (
  xrange[0]+pixel_width *   npixels#         til width;   / z_x: x-coordinate
  yrange[0]+pixel_height*raze width#'reverse til height;  / z_y: y-coordinate
  npixels# 0f;  / mag:  (square of) magnitude of each z value
  npixels#-2j   / lev:  when the pixel blows up
  );

 do[iterations;
  update
  z_x: c[0] + sq[z_x] - sq[z_y],
  z_y: c[1] + 2 * z_x * z_y,
  mag: sq[z_x] + sq[z_y],
  lev: lev + 1
  from `julia where mag < 4
  ];

 update mag: sq[z_x]+sq[z_y], lev: lev+1 from `julia where mag < 4;
 update lev: lev+1 from `julia where mag < 4;

 /shades: {x,\:0x0000} `byte$floor(255%6-1)*til 6; / red
 write_bmp[file; (0x000000;0x0000ff) shape#4>julia `mag]
 }




julia_shading:([]
 z_x: `float$(); / x-coordinate
 z_y: `float$(); / y-coordinate
 mag: `float$(); / magnitude (squared)
 lev:  `long$()  / exploding iteration
 )


draw_julia_shading:{[file; width; height; xrange; yrange; iterations; c]

 / purge any previous data
 delete from `julia_shading;

 shape:   width,height;
 npixels: width*height;
 pixel_width:  (deltas xrange)[1] % width;
 pixel_height: (deltas yrange)[1] % height;

 `julia_shading insert (
  xrange[0]+pixel_width *   npixels#         til width;   / z_x: x-coordinate
  yrange[0]+pixel_height*raze width#'reverse til height;  / z_y: y-coordinate
  npixels# 0f;  / mag:  (square of) magnitude of each z value
  npixels#-2j   / lev:  when the pixel blows up
  );

 do[iterations;
  update
  z_x: c[0] + sq[z_x] - sq[z_y],
  z_y: c[1] + 2 * z_x * z_y,
  mag: sq[z_x] + sq[z_y],
  lev: lev + 1
  from `julia_shading where mag < 4
  ];

 update mag: sq[z_x]+sq[z_y], lev: lev+1 from `julia_shading where mag < 4;
 update lev: lev+1 from `julia_shading where mag < 4;

 shades: {x,\:0x0000} `byte$floor(255%20-1)*til 20; / red
 /shades: {0x0000,/:x} `byte$floor(255%20-1)*til 20; / blue
 write_bmp[file; shades shape#(julia_shading `lev) mod 6]
 }
