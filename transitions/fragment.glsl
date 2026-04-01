// Author: lbl
// License: MIT
float time = 0.;//@0
float duration = 5.;//@0
float random(vec2 par){
   return fract(sin(dot(par.xy,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 random2(vec2 par){
	float rand = random(par);
	return vec2(rand, random(par+rand));
}

#define POINTS 10
vec4 filte(vec2 uv) {
    vec2 point[POINTS];
    for(int i = 0; i< POINTS; i++) {
        point[i] = random2(vec2(float(i)));
    }
    float m_dist = 10000.;
    float id = 0.;
    vec4 col = vec4(0.);
    
    for (int i = 0; i < POINTS; i++) {
        vec2 dir = normalize( random2(vec2(float(i),float(i) + 11.) ) );
        float v = (1. + random(dir)*.5) *.2;
        vec2 ofst = dir * clamp(time - .5,0.,duration) * v;
        mat3 T = mat3(1.,0.,0.,  0.,1.,0., -ofst,1.); /*求逆*/
        
        vec2 U = (T * vec3(uv,1.)).xy;
        float m_dist = distance(U, point[i]);
        bool match = true;

        /*todo: 这里要优化成网格 */
        if(U.x > 0. && U.x < 1. && U.y > 0. && U.y < 1.) {
            for(int j = 0; j < POINTS; j++) {
                float dist = distance(U, point[j]);
                if(dist < m_dist) match = false;
            }
        }else {
            match = false;
        }
 
        if(match) {
            col = getFromColor(U);
            break;
        }else {
        
          col =  getToColor(uv);
        }
    }
    return col;
}

 

vec4 transition (vec2 uv) {
  time = progress * 8.;
  duration = 8.;
  return  filte(uv);
}

 
