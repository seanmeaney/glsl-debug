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


void main() 
{
    vec4 pixel;
    // can start with fixed color...
	pixel = vec4(0.3,0.4,0.6,1.0);
	// ...or color from vertex
	pixel = color_interp;

	// light color (pure white by default)
	vec4 lightcol = vec4(1,1,1,1);
	lightcol = light_color;

	// view position -- 0 in view space
	vec3 v = vec3(0,0,0);

	// view direction -- object position treated as origin
	vec3 vv = normalize(v - position_interp);
	vec3 lv = normalize(light_pos - position_interp); // light direction, object position as origin
	vec3 n = normalize(normal_interp); // must normalize interpolated normal
	
	float diffuse = max(dot(n, lv), 0.0);

    float amb = 0.4; // ambient coefficient

	
    // Specular highlights (Phong reflection)
	vec3 r = -lv + 2*dot(lv, n) *n;
    float spec = pow(max(dot(r, vv), 0.0), specPower);

	
    // Use variable "pixel", surface color, to help determine fragment color
    gl_FragColor = light_color*pixel*diffuse +
	   light_color*vec4(1,1,1,1)*spec + // specular might not be colored
	   light_color*pixel*amb; // ambcol not used, could be included here
}
