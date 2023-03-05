#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec4 normal;
out float hide;

vec2 tex = textureSize(Sampler0, 0);

const vec4[] head = vec4[](
    vec4(24., 8., 16., 16.),
    vec4(8., 8., 0., 16.),
    vec4(16., 0., 8., 8.),
    vec4(24., 8., 16., 0.),
    vec4(16., 8., 8., 16.),
    vec4(32., 8., 24., 16.)
);

const vec4[] leg = vec4[](
    vec4(12., 4., 8., 16.),
    vec4(4., 4., 0., 16.),
    vec4(8., 0., 4., 4.),
    vec4(12., 4., 8., 0.),
    vec4(8., 4., 4., 16.),
    vec4(16., 4., 12., 16.)
);

const vec4[] arm = vec4[](
    vec4(11., 4., 7., 16.),
    vec4(4., 4., 0., 16.),
    vec4(7., 0., 4., 4.),
    vec4(10., 4., 7., 0.),
    vec4(7., 4., 4., 16.),
    vec4(14., 4., 11., 16.)
);

const vec4[] body = vec4[](
    vec4(16., 4., 12., 16.),
    vec4(4., 4., 0., 16.),
    vec4(12., 0., 4., 4.),
    vec4(20., 4., 12., 0.),
    vec4(12., 4., 4., 16.),
    vec4(24., 4., 16., 16.)
);

vec2 newCoord(float type, float side, float id, float x, float y) {
    int sidee = int(side);
    if(type == 0.){
        if(id == 0.){
            return vec2(head[sidee][0] + x, head[sidee][1] + y) / 64.;
        }else if(id == 1.){
            return vec2(head[sidee][2] + x, head[sidee][1] + y) / 64.;
        }else if(id == 2.){
            return vec2(head[sidee][2] + x, head[sidee][3] + y) / 64.;
        }else if(id == 3.){
            return vec2(head[sidee][0] + x, head[sidee][3] + y) / 64.;
        }
    }else if(type == 1.){
        if(id == 0.){
            return vec2(body[sidee][0] + x, body[sidee][1] + y) / 64.;
        }else if(id == 1.){
            return vec2(body[sidee][2] + x, body[sidee][1] + y) / 64.;
        }else if(id == 2.){
            return vec2(body[sidee][2] + x, body[sidee][3] + y) / 64.;
        }else if(id == 3.){
            return vec2(body[sidee][0] + x, body[sidee][3] + y) / 64.;
        }
    }else if(type == 2.){
        if(id == 0.){
            return vec2(leg[sidee][0] + x, leg[sidee][1] + y) / 64.;
        }else if(id == 1.){
            return vec2(leg[sidee][2] + x, leg[sidee][1] + y) / 64.;
        }else if(id == 2.){
            return vec2(leg[sidee][2] + x, leg[sidee][3] + y) / 64.;
        }else if(id == 3.){
            return vec2(leg[sidee][0] + x, leg[sidee][3] + y) / 64.;
        }
    }else if(type == 3.){
        if(id == 0.){
            return vec2(arm[sidee][0] + x, arm[sidee][1] + y) / 64.;
        }else if(id == 1.){
            return vec2(arm[sidee][2] + x, arm[sidee][1] + y) / 64.;
        }else if(id == 2.){
            return vec2(arm[sidee][2] + x, arm[sidee][3] + y) / 64.;
        }else if(id == 3.){
            return vec2(arm[sidee][0] + x, arm[sidee][3] + y) / 64.;
        }
    }
}

void main() {
    vec2 UV = UV0;
    texCoord1 = UV0;

    float part = mod(floor(gl_VertexID / 24.), 14.);
    float sid = floor(mod(gl_VertexID, 24.) / 4.);
    float point = mod(gl_VertexID, 4.);
    float arm = 2.;
    if(texture(Sampler0, vec2(54./64., 20./64.)).rgb == vec3(0., 0., 0.) && texture(Sampler0, vec2(50./64., 16./64.)).rgb == vec3(0., 0., 0.)){
        arm = 3.;
    }
    hide = 1.;
    if(tex == vec2(64., 64.)){
        hide = 0.;
    }
    
    if(part == 0.0){
        UV = newCoord(0., sid, point, 0., 0.); //head
    }else if(part == 1.0){
        UV = newCoord(0., sid, point, 32., 0.); //hat
    }else if(part == 2.0){
        UV = newCoord(1., sid, point, 16., 16.); //body
    }else if(part == 3.0){
        UV = newCoord(1., sid, point, 16., 32.); //jacket
    }else if(part == 4.0){
        UV = newCoord(2., sid, point, 16., 48.); //left leg
    }else if(part == 5.0){
        UV = newCoord(2., sid, point, 0., 48.); //left pant
    }else if(part == 6.0){
        if(UV0.x > 0.5){
            hide = 1.;
        }
        UV = newCoord(2., sid, point, 0., 16.); //right leg
    }else if(part == 7.0){
        UV = newCoord(2., sid, point, 0., 32.); //right pant
    }else if(part == 8.0){
        UV = newCoord(arm, sid, point, 32., 48.); //left arm
    }else if(part == 9.0){
        UV = newCoord(arm, sid, point, 48., 48.); //left sleeve
    }else if(part == 10.0){
        UV = newCoord(arm, sid, point, 40., 16.); //right arm
    }else if(part == 11.0){
        UV = newCoord(arm, sid, point, 40., 32.); //right sleeve
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
