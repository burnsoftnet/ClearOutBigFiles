#!/bin/bash
#lookforbigfiles.sh
#Version: 1.0.4
#by J Mireles
useage()
{
	echo "usage: $ScriptName options <n|s <KB>|p <PATH>|t <FILETYPE>|h|d|m|v <TARGET>|r|z>"
	echo "-n					empty file(s)"
	echo "-s <NUMNER>			Enter in the max size in KB that is acceptable"
	echo "-p <path>				The file path /a/"
	echo "-t <filetype>        File type example: *.log"
	echo "-d					Debug Mode"
	echo "-m 					Move File(s) ( -v is required)"
	echo "-v <TargetPath>		Target Path to move to /temp/"
	echo "-r 					Delete File(s)"
	echo "-h					Brings up this help"
	echo "-z					zips up file in current location"
	echo ""
	echo "EXAMPLES:"
	echo ""
	echo "Set Size to 200KB (-s) Path is users wallpapers (-p) and look for all jpg (-t) NO ACTIONS SET JUST REPORT"
	echo "$ScriptName -s 200 -p /users/wallpaper/ -t *.jpg"
	echo ""
	echo "Set Size to 200KB (-s) Path is users wallpapers (-p) and look for all jpg (-t) Empty File (-n)"
	echo "$ScriptName -s 200 -p /users/wallpaper/ -t *.jpg -n"
	echo ""
	echo "Set Using Default Size Path is users wallpapers (-p) and look for all jpg (-t) Delete File (-r)"
	echo "$ScriptName -p /users/wallpaper/ -t *.jpg -r"
	echo ""
	echo "Set Using Default Size & file type Path is users wallpapers (-p) and move File (-m) to (-v) /users/junk/"
	echo "$ScriptName -p /users/wallpaper/ -m -v /users/junk/"
	echo ""
	echo "Set Using Default Size Path is users wallpapers (-p) and look for all jpg (-t) zip File (-z)"
	echo "$ScriptName -p /users/wallpaper/ -t *.jpg -z"
	echo ""
	echo ""
	echo "There are Also Defaults set in the script that you can use and all you have to do is pass the path"
	echo "$ScriptName -p /Users/temp/"
	exit 1
}
writedebug()
{
	if $buggerme ; then
		echo "$1"
	fi
}
donullit()
{
	echo "Empty file $1"
	cp /dev/null $1;
}

domoveit()
{
	echo "moving file from $1 to $2"
	mv $1 $2;
}
doremoveit()
{
	echo "removing file $1"
	rm -rf $1;
}
dozipit()
{
	echo "zipping file $1"
	bzip2 -9 $1;
	
}
removebackslash()
{
	SourcePath=${1%/};
}
ScriptName="lookforbigfiles.sh"; #Name of script, for Help File Purpose.
#UseFriendlydu=true; # if your OS supports the du -h option then it is used, else turn off and we assume KB
useParam=true; #instead of passing parameters, hard code it in the script and skip the function that looks for params
nullit=false; #set action to empty file, 
buggerme=false; #turn on and off debugging
maxsize=600; #set the max file size in KB that is acceptable anything above it will be reported and action taken upon it.
SourcePath="";  #  Set the Source Path, Used then useParam is FALSE
filetype="*.jpg"; # set the type of files that you want to look for
movefile=false;  #set the action to Move the File, Will be ignored is NULL or remove is set to true
destinationPath="/temp/"; # set the target directory to move the files to when the movefile is set to true
removefile=false; # set the action to delete the file, WILL be ignored is NULL or move is set to true
zipIT=false; #zip the file in the loacation that it currently at

if $useParam ; then
	if [[ $# -gt 0 ]] ; then
	while getopts "v:s:p:t:dnhmrz" opt; do
		case $opt in
			n) nullit=true;; #null or empty the file
			s) maxsize=$OPTARG;;  # make file size in kB
			p) SourcePath=$OPTARG;; #source path to look in
			t) filetype=$OPTARG;;  #file type
			d) buggerme=true;;
			m) movefile=true;;
			v) destinationPath=$OPTARG;;
			r) removefile=true;;
			z) zipIT=true;;
			?) echo "Invalid option: -$OPTARG" >&2
			      exit 1;; #handle error: unknow options or missin requirement. 
			:)
			      echo "Option -$OPTARG requires an argument." >&2
			      exit 1
			      ;;
			h) useage;;
		esac
	done;
	else
		useage;
	fi
else
	if [[ -n "$SourcePath" ]] ; then
		echo "Source Directory - $SourcePath"
	else
		echo "Missing Hardcoded Source Directory!"
		exit 1
	fi
fi

myOS=$(uname -a | cut -f1);
if [["$myOS" = "AIX"]] ; then
	UseFriendlydu=false;
else
	UseFriendlydu=true
fi
#echo "$myOS";
#exit
writedebug "buggerme=$buggerme"
writedebug "nullit=$nullit"
writedebug "maxsize=$maxsize" 
writedebug "SourcePath=$SourcePath"
writedebug "FileType=$filetype"
writedebug "ZipIT=$zipIT"
writedebug "UseFriendlydu=$UseFriendlydu"

#SourcePath=${$SourcePath/};
removebackslash $SourcePath;
Lookin="$SourcePath/$filetype"
#echo $Lookin;
#exit;
if $nullit ; then
	movefile=false;
	removefile=false;
	zipIT=false;
elif $movefile ; then
	removefile=false;
	nullit=false;
	zipIT=false;
elif $removefile ; then
	movefile=false;
	nullit=false;
	zipIT=false;
elif $zipIT ; then
	movefile=false;
    nullit=false;
    removefile=false;
fi

for f in $Lookin; do
	a=$(du -ks $f | cut -f1)
	if [[ -n "$a" ]] ; then
		if (($a > $maxsize)); then
			if $nullit ; then
				donullit $f;
			elif $movefile ; then
				domoveit $f $destinationPath;
			elif $removefile ; then
				doremoveit $f;
			elif $zipIT ; then
				dozipit $f;
			else
				if $UseFriendlydu ; then
					b=$(du -h $f | cut -f1)
					echo "BIGFILE! $f is $b"
				else
					echo "BIGFILE! $f is $a KB"
				fi
			fi
		fi
	fi
done