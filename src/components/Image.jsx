import { useAspect, useTexture } from '@react-three/drei';
import React, { useMemo } from 'react'
import vertex from '../shaders/image/vertex.glsl'
import fragment from '../shaders/image/fragment.glsl'
import { useControls } from 'leva';
import { useEffect } from 'react';
import { Color, Vector2 } from 'three';

const Image = () => {
   const texture = useTexture('/cat.webp');
   const depthMapTexture = useTexture('/cat-depth-map-blured.png');
   
   const { progress, shadowColor, glowColor, center, strength, power } = useControls({
      progress: { value: 0.5, min: 0, max: 1, step: 0.01 },
      shadowColor: { value: '#f00' },
      glowColor: { value: '#fff' },
      center: { value: { x: 0.5, y: 0.5 } },
      strength: { value: 1, min: 0, max: 1, step: 0.01 },
      power: { value: 3 }
   })


   const uniforms = useMemo(() => ({
      uTexture: { value: texture },
      uDepthMap: { value: depthMapTexture },
      uProgress: { value: 0 },
      uGlowColor: { value: new Color(shadowColor) },
      uShadowColor: { value: new Color(glowColor) },
      uCenter: { value: new Vector2(0.5, 0.5) },
      uStrength: { value: 1 },
      uPower: { value: power }
   }), [])

   useEffect(() => {
      uniforms.uProgress.value = progress;
      uniforms.uGlowColor.value = new Color(glowColor);
      uniforms.uShadowColor.value = new Color(shadowColor);

      uniforms.uCenter.value.set(center.x, center.y);
      uniforms.uStrength.value = strength;
      uniforms.uPower.value = power;
   }, [progress, shadowColor, glowColor, center, strength, power])
   
   
   return (
      <mesh scale={5}>
         <planeGeometry />
         <shaderMaterial
            uniforms={uniforms}
            vertexShader={vertex}
            fragmentShader={fragment}
         />
      </mesh>
   )
}

export default Image
