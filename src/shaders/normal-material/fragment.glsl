varying vec3 vNormal;

void main() {
   vec3 normal = normalize(vNormal) * 0.5 + 0.5;
   gl_FragColor = vec4(normal, 1.0);
}