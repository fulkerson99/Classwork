#!/bin/bash
#This program Creates, Modifys, Displays, and deletes crontab jobs.
#Joseph Fulkerson






#Function selection
function task_slct(){

cat <<-EOF
**********************************
* (1)----------Create Task       *
* (2)----------Display Job List  *
* (3)----------Modify Job        *
* (4)----------Delete Job        *
* (5)----------Exit              *
**********************************
EOF
read options
	case $options in
	1) create_job;;
	
	2) display_list;;

	3) modify_job ;;
		
	4) delete_job ;;

	5) exit;;
		
esac



}


function create_job(){
echo "*****Enter Crontab Time Parameters*****"
echo
read -p "Minute (0-59, *):  " v1
echo $v1
read -p "Hour (0-29, *):  " v2
echo $v2
read -p "Day of the Month (1-31, *):  " v3
echo $v3
read -p "Month (1-12, *) or (jan,feb,mar,...):  " v4
echo $v4
read -p "Day of the Week (0-6, *):  " v5
echo $v5
read -p "Command:  " cmmd
echo $cmmd

echo "Crontab Command Entered"
echo $v1 $v2 $v3 $v4 $v5 $v6 $cmmd

echo "Save Command (y/n)?"
read options1
case $options1 in
	y)
		echo $v1 $v2 $v3 $v4 $v5 $v6 $cmmd >> joblist
		echo "--Task Saved to Job List--"
		crontab joblist
		task_slct;;
	n) 
		create_job;;
	esac
	

}



function display_list(){
echo "*****Job List*****"
crontab -l
echo 
task_slct
}



function modify_job(){

vi joblist
crontab joblist
echo "--Job List Modified--"
task_slct
}



function delete_job(){
 vi joblist
 crontab joblist
 echo "--Job List Deleted--"
 task_slct
}




#main function display
task_slct
touch joblist > /dev/null 2>&1

exit 0
