#version 130

// Attributes passed from the vertex shader
in vec3 position_interp;
in vec3 normal_interp;
in vec4 color_interp;
in vec2 uv_interp;
in vec3 light_pos;

// Uniform (global) buffer
uniform sampler2D texture_map;
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
        checkerColor = checkerColor * (1.0 - blue) + vec4(0.0, 0.0, blue, 1.0);;
    }

    
    gl_FragColor = checkerColor;
}
