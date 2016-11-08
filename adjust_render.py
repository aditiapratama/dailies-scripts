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
render.use_placeholder = 1
render.display_mode = 'NONE'
render.resolution_y = 720
render.resolution_x = 1280
render.resolution_percentage = 100
render.pixel_aspect_x = 1
render.pixel_aspect_y = 1
render.use_antialiasing = True
render.use_stamp = False
render.use_simplify = False
render.antialiasing_samples = '8'
render.image_settings.compression = 90
render.image_settings.file_format = 'PNG'
render.image_settings.color_mode = 'RGBA'
render.alpha_mode = 'TRANSPARENT'

for obj in objects:
    if obj.type == 'CAMERA':
        obj.select = 1
        scene.camera = obj

bpy.ops.file.make_paths_relative()

if scene.cgru:
    scene.cgru.adv_options = True
    scene.cgru.relativePaths = True
    scene.cgru.pause = True
    for scn in bpy.data.scenes:
        totalFrame = scn.frame_end - scn.frame_start
        if totalFrame >= 150:
            scene.cgru.fpertask = 5
        else:
            scene.cgru.fpertask = 10
    if bpy.path.basename(bpy.data.filepath).endswith("_light.blend"):
        filename = bpy.path.basename(bpy.context.blend_data.filepath)
        filename = os.path.splitext(filename)[0]
        filename = filename.split('_light')
        filename = filename[0]
        filename = filename[2:4]
        priority = 251 - int(filename)
        for scn in bpy.data.scenes:
            scn.cgru.priority = priority

filename = bpy.path.basename(bpy.context.blend_data.filepath)
filename = os.path.splitext(filename)[0]

if filename:
    bpy.context.scene.render.filepath = os.path.join("//../../render/frames", filename, filename + "_")

bpy.ops.wm.save_as_mainfile(filepath=bpy.data.filepath)
