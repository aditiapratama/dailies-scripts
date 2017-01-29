import os
import sys
import subprocess

for file in os.listdir("."):
    if file[-7:-6].isnumeric() and file.find("light") != -1:
        file = os.path.abspath(file)
        filename = os.path.basename(os.path.splitext(file)[0])
        frame = 10 #pick random frame here
        if sys.platform.startswith('win32'):
            command = 'D:\\blender-2.78-windows64\\blender.exe -b "%s"' %file \
                        + ' -y -F PNG -x 1' \
                        + ' -o Z:\\sync\\projects\\jayagiri\\render\\frames\\light\\002\\%s_####' %filename \
                        + ' -f %s' %frame
            subprocess.run(r'C:\WINDOWS\system32\cmd.exe /C "%s"' %command)
        elif sys.platform.startswith('linux'):
            command = '/opt/cgru/software_setup/start_blender.sh -b "%s"' %file \
                        + ' -y -F PNG -x 1' \
                        + ' -o /media/farm/sync/projects/jayagiri/render/frames/light/002/%s_####' %filename \
                        + ' -f %s' %frame
            subprocess.run(command, shell=True)
