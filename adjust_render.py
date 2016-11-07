import bpy
import os

filename = bpy.path.basename(bpy.context.blend_data.filepath)
filename = os.path.splitext(filename)[0]
filename = filename.split('_light')
filename = bpy.path.ensure_ext(filename[0], ext = '.blend')

blendpath = bpy.path.abspath (bpy.context.blend_data.filepath)
blenddir, blendfile= os.path.split(blendpath)
filepath = os.path.join(blenddir + '/' + filename)

objects = bpy.data.objects
scene = bpy.context.scene
render = scene.render

render.fps = 25
render.resolution_y = 720
render.pixel_aspect_x = 1

bpy.ops.wm.save_as_mainfile(filepath=bpy.data.filepath)
