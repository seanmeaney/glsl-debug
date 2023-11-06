#version 130

// Attributes passed from the vertex shader
in vec3 position_interp;
in vec3 normal_interp;
in vec4 color_interp;
in vec2 uv_interp;

// Uniform (global) buffer
uniform sampler2D texture_map;
uniform vec3 light_pos;
uniform vec4 light_color;
uniform vec4 object_color;
uniform float specPower;

// Uniform for the checkerboard shader
uniform float timer;

void main() 
{
    // Number of checkers and their size
    int numCheckers = 16;
    float checkerSize = 1.0 / float(numCheckers);

    // Calculate the checkerboard coordinates
    float checkerX = floor(uv_interp.x / checkerSize);
    float checkerY = floor(uv_interp.y / checkerSize);

    // Alternate the checkerboard colors
    vec4 checkerColor;
    if (mod(int(checkerX) + int(checkerY), 2) == 0) {
        checkerColor = vec4(1.0, 1.0, 1.0, 1.0); // White
    } else {
        checkerColor = vec4(0.0, 0.0, 0.0, 1.0); // Black
        // Blend the checkerboard with a blue color based on the timer
        float blue = mod(timer * 0.25, 1.0); // Slowly increase blue over time (and back to black when reaching 1)
        checkerColor = checkerColor * (1.0 - blue) + vec4(0.0, 0.0, blue, 1.0);
    }


    // Calculate lighting
    vec3 v = vec3(0,0,0);
    vec4 pixel = checkerColor;
    vec3 vv = normalize(v - position_interp);
	vec3 lv = normalize(light_pos - position_interp); // light direction, object position as origin
	vec3 n = normalize(normal_interp); // must normalize interpolated normal
	
	float diffuse = max(dot(n, lv), 0.0);

    float amb = 0.4; // ambient coefficient

	
    // Specular highlights (Phong reflection)
	vec3 r = -lv + 2*dot(lv, n) *n;
    // r = reflect(-lv, n);
    float spec = pow(max(dot(r, vv), 0.0), specPower);

    // Calculate final fragment color
	gl_FragColor = light_color*pixel*diffuse +
	   light_color*vec4(1,1,1,1)*spec + // specular might not be colored
	   light_color*pixel*amb; // ambcol not used, could be included here
}
