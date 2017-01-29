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

for obj in objects:
    if obj.get is not None and obj.type != 'LAMP':
        bpy.data.objects.remove(obj, do_unlink=True)

link = True

with bpy.data.libraries.load(filepath, link=link) as (data_from, data_to):
    data_to.objects = data_from.objects

for obj in data_to.objects:
    if obj is not None:
        scene.objects.link(obj)

bpy.ops.wm.save_as_mainfile(filepath=bpy.data.filepath)
