import { Canvas } from '@react-three/fiber'
import React from 'react'
import Experience from './Experience'

const Scene = () => {
  return (
    <div id="canvas">
      <Canvas>
        <Experience />
      </Canvas>
    </div>
  )
}

export default Scene
