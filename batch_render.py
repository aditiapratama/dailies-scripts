import os
import sys
import subprocess

for file in os.listdir("."):
    if file.endswith("_light.blend"):
        file = os.path.abspath(file)
        filename = os.path.basename(os.path.splitext(file)[0])
        frame = 10 #pick random frame here
        command = 'D:\\blender-2.78-windows64\\blender.exe -b "%s"' %file \
                    + ' -y -F PNG -x 1' \
                    + ' -o Z:\\PROJECTS\\jayagiri\\render\\frames\\light\\002\\%s_####' %filename \
                    + ' -f %s' %frame
        subprocess.run(r'C:\WINDOWS\system32\cmd.exe /C "%s"' %command)
