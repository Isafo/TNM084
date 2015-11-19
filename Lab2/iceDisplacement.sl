#include "voronoi.sl"

displacement iceDisplacement() {

	float crackfreq = 3;

	// Output parameters used for voronoi()
	float f1, f2, x1, y1, x2, y2; 

	voronoi_f2_2d(s, t, crackfreq*10, 0.7, f1, f2, x1, y1, x2, y2);
	
  	float clampValue = clamp(f1, 0.0, 1.0);
	
	// Adding displacement along the normal direction
  	P = P - N * 0.01 * clampValue;
	P += N * 0.02  * f2;

	//recalculate the normal
	N = calculatenormal(P);

}