import bpy
import os
import sys

objects = bpy.data.objects
scene = bpy.context.scene

for obj in objects:
    if obj.type == 'CAMERA':
        obj.select = 1
        # bpy.ops.object.make_local(type='SELECT_OBJECT')
        scene.camera = obj

bpy.ops.wm.save_as_mainfile(filepath=bpy.data.filepath)
