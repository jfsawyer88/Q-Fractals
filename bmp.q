// writes a pixel array to a bmp file
write_bmp:{ [file; pixel_array]

 height:count       pixel_array;  / height
 width: count first pixel_array;  / width

 data: raze each (reverse each) each pixel_array;    / raze pixels
 data: data ,\: ((0 3 2 1) (3*width) mod 4) # 0x00;  / pad rows
 data: raze reverse data;                            / raze rows

 psize: count data;

 / create header
 header:0x424d;
 header,:4#reverse 0x00 vs 54+psize;
 header,:0x000000003600000028000000;
 header,:4#reverse 0x00 vs width;
 header,:4#reverse 0x00 vs height;
 header,:0x0100180000000000;
 header,:4#reverse 0x00 vs psize;
 header,:0x130b0000130b00000000000000000000;

 / write header and data to file
 file 1: header,data
 }
