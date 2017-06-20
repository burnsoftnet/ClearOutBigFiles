# ClearOutBigFiles
The Clear Out Big Files Shell Script ( lookforbigfiles.sh ) was created to help free up space on a linux base machine when you know the common area(s) were the drive tends to take up space.
<br/>
This script came about when a certain application was taking up all the space due to a number of logs that it created without cleaning up the old log files. Some files would be a majority kilobytes, others in the meg, and others in the gigabyte. While a majority you can delete them, there are some that was in use and could not be deleted.
<br/>
This script will allow you to set the max size in kb, so anything bigger then that would be deleted, zipped or nulled. set the path you want to monitor and set the file type that you want to look for. Addition switches to the script will allow you to say if you want all the files deleted, zeroed out / nulled, or zip them up.
<br/>
<center>
<img scr="https://github.com/burnsoftnet/ClearOutBigFiles/blob/master/help_menu.png">
</center>
<br/>
This is a script that you can setup via cron to run on a regular basis for a variety of paths that you want to clean up, or if it is just the one, you can preset some defaults and all you have to do is pass the path that you want to clean up.
