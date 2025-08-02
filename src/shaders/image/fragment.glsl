uniform sampler2D uTexture;
uniform sampler2D uDepthMap;
uniform float uProgress;
uniform vec3 uGlowColor;
uniform vec3 uShadowColor;
uniform vec2 uCenter;
uniform float uStrength;
uniform float uPower;

varying vec2 vUv;

vec3 overlay(vec3 base, vec3 blend) {
   return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), step(0.5, base));
}

float getStrip(float progress, float thickness, vec2 uv, vec2 origin) {
   float center = length(uv - vec2(origin));
   float strip = smoothstep(progress - thickness, progress, center);
   strip *= smoothstep(progress + thickness, progress, center);

   return strip;
}


void main() {
   float depthMap = 0.9 - texture2D(uDepthMap, vUv).r;
   

   float thickness = 0.3;
   vec2 origin = uCenter;

   float strip1 = getStrip(uProgress, thickness, vUv, origin);
   float strip2 = getStrip(uProgress, thickness, vUv, origin);
   strip2 = pow(strip2, uPower);

   float center = length(vUv - vec2(0.5));
   float x = sin(vUv.x * 3.141 * 0.5);
   float y = sin(vUv.y * 3.141 * 0.5);
   // vec3 image = texture2D(uTexture, uv * (strip1 * 0.05 + 1.0)).rgb;

   float scale = 2.0;
   vec2 scaleOrigin = vec2(1.0);
   vec2 scaledUv = (vUv - scaleOrigin) * scale + scaleOrigin;
   vec3 image = texture2D(uTexture, vUv * (strip2 * 0.2 * scaledUv * depthMap * uStrength + 1.0)).rgb;
   // vec3 image = texture2D(uTexture, vUv).rgb;


   vec3 shadowColor = uShadowColor;
   vec3 glowColor = uGlowColor;

   float redShadow = strip1 * (1.0 - strip2);
   vec3 finalHighlightColor = glowColor * strip2 + shadowColor * redShadow * depthMap;

   // Repeating dots background
   float dotSpacing = 0.01;
   float dotRadius = 0.7 * strip1;
   vec2 grid = fract(vUv / dotSpacing);
   float dist = length(grid - 0.5);
   float dots = smoothstep(dotRadius, dotRadius - 0.01, dist);

   vec3 overlayColor = overlay(image, finalHighlightColor * dots);
   vec3 finalColor = mix(image, overlayColor, strip1 * depthMap * uStrength);

   gl_FragColor = vec4(finalColor, 1.0);
   // gl_FragColor = vec4(depthMap, depthMap, depthMap, 1.0);
   // gl_FragColor = vec4(dots, dots, dots, 1.0);
   // gl_FragColor = vec4(strip2, strip2, strip2, 1.0);
   // gl_FragColor = vec4(finalHighlightColor, 1.0);
   // gl_FragColor = vec4(strip, strip, strip, 1.0);
}