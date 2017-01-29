import bpy
import os
import sys

scene = bpy.context.scene

if scene.cgru:
    bpy.ops.cgru.submit()
