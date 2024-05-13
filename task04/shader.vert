#version 120 

// see the GLSL 1.2 specification:
// https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

uniform bool is_reflection; // variable of the program
varying vec3 normal; // normal vector pass to the rasterizer and fragment shader

void main()
{
    normal = vec3(gl_Normal);// set normal and pass it to fragment shader

    // "gl_Vertex" is the *input* vertex coordinate of triangle.
    // "gl_Vertex" has type of "vec4", which is homogeneious coordinate
    float x0 = gl_Vertex.x/gl_Vertex.w;// x-coord
    float y0 = gl_Vertex.y/gl_Vertex.w;// y-coord
    float z0 = gl_Vertex.z/gl_Vertex.w;// z-coord
    if (is_reflection) {
        vec3 nrm = normalize(vec3(0.4, 0.0, 1.0)); // normal of the mirror
        vec3 org = vec3(-0.3, 0.0, -0.5); // point on the mirror
        // write code to change the input position (x0,y0,z0).
        // the transformed position (x0, y0, z0) should be drawn as the mirror reflection.
        //
        // make sure the occlusion is correctly computed.
        // the mirror is behind the armadillo, so the reflected image should be behind the armadillo.
        // furthermore, make sure the occlusion is correctly computed for the reflected image.
        vec3 p = vec3(x0, y0, z0); // point out of the mirror
        vec3 q = p - 2*dot(p-org,nrm)*nrm; // point on the reflection inside the mirror
        x0 = q.x;
        y0 = q.y;

        float z1=(dot(org,nrm)-nrm.x*x0-nrm.y*y0)/nrm.z;// Projection point on the mirror
        z0 = q.z*0.01+z1*0.99;// z coor between the reflection inside the mirror and the projection on the mirror.

    }
    // do not edit below

    // "gl_Position" is the *output* vertex coordinate in the
    // "canonical view volume (i.e.. [-1,+1]^3)" pass to the rasterizer.
    gl_Position = vec4(x0, y0, -z0, 1);// opengl actually draw a pixel with *maximum* depth. so invert z
}
