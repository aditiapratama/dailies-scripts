import os
import shutil

for file in os.listdir("."):
    if file.endswith("_light.blend"):
        file = os.path.abspath(file)
        filename = os.path.basename(os.path.splitext(file)[0])
        filename = filename.split('_light')
        filename = filename[0]
        filename = filename[2:4]

        for i in range(59):
            count = int(filename) + i+1
            middle = '%0*d' % (2, count)
            newname = '01' + middle + '00_light.blend'
            #print(newname)
            shutil.copy(file, newname)
