#include "voronoi.sl"

surface ice(float crackfreq = 3) {
	
	//create noise where there should be alot of cracks at light parts
	//and not so many at darker parts


	color iceColor = color(0.02, 0.19, 0.27);
	color crackColor = color(0.55, 0.77, 0.89);
	color gradientCrackColor = color(0.22, 0.66, 0.81);
	color black = color(0, 0, 0);

	float f1, f2, x1, y1, x2, y2; // Output parameters for voronoi()

	voronoi_f2_2d(s, t, crackfreq * 2, 0.7, f1, f2, x1, y1, x2, y2);

	// Perturb the texture coordinates to get curved cracks
	float sd = s + 0.08 * f1;
	// Decorrelate noise in s and t by an arbitrary offset
	float td = t + 0.08 * f2;

	voronoi_f2_2d(sd, td, crackfreq, 0.7, f1, f2, x1, y1, x2, y2);
	float largeCrack = clamp(2*(f2-f1), 0.0, 1.0);
	
	// Second pattern, similar but 4x smaller
	voronoi_f2_2d(sd, td, crackfreq*4, 0.7, f1, f2, x1, y1, x2, y2);
	float smallCrack = clamp(f2-f1, 0.0, 1.0);

	// Threshold the large crack with filterstep() or smoothstep
	float whiteLargeCrack = filterstep(0.02, largeCrack);
	float gradientLargeCrack = smoothstep(0.3, 1.0, largeCrack);

	// Threshold the small crack with filterstep() or smoothstep
	float whiteSmallCrack = filterstep(0.02, smallCrack);
	float gradientSmallCrack = smoothstep(0.3, 0.8, largeCrack);
	
	// small cracks should only exist in the "gradient" area
	float tinyCrack = max(whiteSmallCrack, gradientSmallCrack);
  
	// Mix the final color 
	// big cracks + gradient around big cracks + small cracks
	Ci = mix(crackColor, black, whiteLargeCrack) + mix(crackColor, black, tinyCrack) + mix(gradientCrackColor, iceColor, gradientLargeCrack);
	// Do not alter opacity, just pass it on
	Oi = Os;
}