#include <glm/vec3.hpp>
#include <glm/vec4.hpp>

//small class that simply stores light attributes and sets the shader uniforms
class Light {
    
    public:
        glm::vec3 pos;
        glm::vec4 color;
        float specPower;

        inline void setLightUniforms(GLuint program){
            glUseProgram(program);
            GLint bitchWhere = glGetUniformLocation(program, "light_pos");
            glUniform3f(bitchWhere, pos.x, pos.y, pos.z);
            bitchWhere = glGetUniformLocation(program, "light_color");
            glUniform4f(bitchWhere, color.x, color.y, color.z, color.a);
            bitchWhere = glGetUniformLocation(program, "specPower");
            glUniform1f(bitchWhere, specPower); 
        }
};

