import bpy

scene = bpy.context.scene
use_nodes = scene.use_nodes
tree = scene.node_tree
nodes = tree.nodes
links = tree.links
render = scene.render

if use_nodes:
    for node in nodes:
        if node.type == 'OUTPUT_FILE':
            nodes.remove(node)

bpy.ops.shots.relink()
#bpy.ops.set.renderpath()
