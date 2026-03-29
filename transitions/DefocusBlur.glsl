// Author: Sergey Kosarevsky
// License: MIT
// Ported from https://gist.github.com/corporateshark/b9f8e5675c647e615419

uniform float blurSize; // = 0.02

// 12-tap Poisson disk
// https://github.com/spite/Wagner/blob/master/fragment-shaders/poisson-disc-blur-fs.glsl
const vec2 Disk[12] = vec2[](
  vec2(-0.326, -0.406),
  vec2(-0.840, -0.074),
  vec2(-0.696,  0.457),
  vec2(-0.203,  0.621),
  vec2( 0.962, -0.195),
  vec2( 0.473, -0.480),
  vec2( 0.519,  0.767),
  vec2( 0.185, -0.893),
  vec2( 0.507,  0.064),
  vec2( 0.896,  0.412),
  vec2(-0.322, -0.933),
  vec2(-0.792, -0.598)
);

vec4 transition(vec2 uv) {
  float T = progress;
  float half_ = 0.5;
  float D = (T < half_) ? mix(0.0, blurSize, T / half_) : mix(blurSize, 0.0, (T - half_) / half_);
  vec4 C0 = getFromColor(uv);
  vec4 C1 = getToColor(uv);
  for (int i = 0; i < 12; i++) {
    C0 += getFromColor(Disk[i] * D + uv);
    C1 += getToColor(Disk[i] * D + uv);
  }
  C0 /= 13.0;
  C1 /= 13.0;
  return mix(C0, C1, T);
}
