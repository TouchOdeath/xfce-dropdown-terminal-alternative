#!/bin/bash
function makeWindowDropDown(){
	##minimize window immediately in hopes of smooth drawing animation when window appears
	windowWait "Terminal - "
	winid=$(wmctrl -l | grep "Terminal - " | awk '{print $1}')
	xdotool windowminimize $winid
	
	#set size of window
	#WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | awk -F "x" '{print $1}')
	#HEIGHT=$(xdpyinfo | awk '/dimensions/{print $2}' | awk -F "x" '{print $2}')
	#HEIGHT=$(($HEIGHT / 2))
	xdotool windowsize $winid 100% 70%
	
	#move window to top
	xdotool windowmove $winid 0 0
	
	#set window to always be on top
	winname=$(xprop -id $winid | grep WM_NAME | head -1 | awk -F ' = ' '{print $2}'| cut -c2- | sed 's/.$//')
	wmctrl -r "$winname" -b toggle,above
	
	#activate window
	xdotool windowactivate $winid
	
	#set cursor focus to window
	wmctrl -a "$winname"
}

#Wait for Window to appear by string
##window name as param
#time as optional param
function windowWait(){
	time=${2:-.25}
	while true
	do
		if xdotool search --name "$1" > /dev/null; then
			break
		fi
		sleep $time
	done
}

function runTerminal(){
	nohup xfce4-terminal > /dev/null 2>&1&
}


#determine if xfce4-terminal is running, if its not, then start it
if pgrep -x "xfce4-terminal" > /dev/null
then
    ##is XFCE-TERMINAL visible?
    winid=$(wmctrl -l | grep "Terminal - " | awk '{print $1}')
    #if [ -z "${winid}" ]; then
    if [[ "$winid" -eq 0 ]]; then
		##not visible, show window
		xdotool windowmap $(xdotool search --pid $(ps -ax | grep xfce4-terminal | head -1 | awk '{print $1}') | tail -1)
	else
		xdotool windowunmap $(xdotool search --pid $(ps -ax | grep xfce4-terminal | head -1 | awk '{print $1}') | tail -1)
	fi
else
   runTerminal
   makeWindowDropDown
fi
