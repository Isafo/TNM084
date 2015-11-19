#include "voronoi.sl"

surface ice(float crackfreq = 3) {
	
	//create noise where there should be alot of cracks at light parts
	//and not so many at darker parts

	// declare the colors used
	color iceColor = color(0.02, 0.19, 0.27);
	color crackColor = color(0.55, 0.77, 0.89);
	color gradientCrackColor = color(0.22, 0.66, 0.81);
	color black = color(0, 0, 0);

	// Output parameters used for voronoi()
	float f1, f2, x1, y1, x2, y2; 

	voronoi_f2_2d(s, t, crackfreq * 2, 0.7, f1, f2, x1, y1, x2, y2);

	// Offset the s and t coordinates with the values from voronoi to get sharp changes in direction for the cracks
	float sd = s + 0.08 * f1;
	float td = t + 0.08 * f2;

	// generate the large white cracks
	voronoi_f2_2d(sd, td, crackfreq, 0.7, f1, f2, x1, y1, x2, y2);
	float largeCrack = clamp(2*(f2-f1), 0.0, 1.0);
	
	// generate small white cracks
	voronoi_f2_2d(sd, td, crackfreq*4, 0.7, f1, f2, x1, y1, x2, y2);
	float smallCrack = clamp(f2-f1, 0.0, 1.0);

	// Threshold the large crack with filterstep() to get sharp edges
	float whiteLargeCrack = filterstep(0.02, largeCrack);
	// Create a gradient around the large crack with smoothstep
	float gradientLargeCrack = smoothstep(0.3, 1.0, largeCrack);

	// Threshold the small crack with filterstep() to get sharp edges
	float whiteSmallCrack = filterstep(0.02, smallCrack);
	// Create a function with smoothstep for decreasing the opacity of the small crack inside the gradient for the large crack
	float gradientSmallCrack = smoothstep(0.3, 0.8, largeCrack);
	
	// small cracks should only exist in the "gradient" area
	float tinyCrack = max(whiteSmallCrack, gradientSmallCrack);
  
	// Mix the final color 
	// big cracks + gradient around big cracks + small cracks
	Ci = mix(crackColor, black, whiteLargeCrack) + mix(crackColor, black, tinyCrack) + mix(gradientCrackColor, iceColor, gradientLargeCrack);
	// Do not alter opacity, just pass it on
	Oi = Os;
}