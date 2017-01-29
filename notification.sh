#!/bin/bash
CONTINUE=1

while [ $CONTINUE -eq 1 ]; do

  # Wait 10 minutes.
  sleep 3m

  # The response to a zenity question is in the $? variable.
  CONTINUE=`zenity --question --title="UPDATE DAILIES" --text="Tolong Update Pekerjaan Anda Hari ini dalam format Video/Gambar ke folder DAILIES di Server sesuai tanggal hari ini !" --ok-label="OK" --cancel-label="Belum" --display=:0.0; echo $?`;

done
