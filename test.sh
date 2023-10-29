#! /bin/bash

echo '--------------------------'
echo "User Name: YANGHANG
Student Number: 12210140"
echo "[ MENU ]"
echo "▪ 1. Get the data of the movie identified by a specific movie id from u.item 
▪ 2. Get the data of ‘action’ genre movies from'u.item'
▪ 3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
▪ 4. Delete the ‘IMDb URL’ from ‘u.item’
▪ 5. Get the data about users from 'u.user’
▪ 6. Modify the format of 'release date' in 'u.item’
▪ 7. Get the data of movies rated by a specific 'user id' from 'u.data'
▪ 8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
▪ 9. Exit"
echo '--------------------------'

while true
do
	echo -n "Enter your choice [ 1-9 ] :"
	read number
	case $number in
		1) 	echo -n "Please enter 'move id'(1~1682): "
			read moveid
			sed -n "${moveid}p" u.item
			;;
		2)	echo -n "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n)"
			read yn
			if [ "$yn" = "y" ]
			then
				awk -F'|' '$7 == 1 {print $1, $2)}' u.item
			fi
			;;
		3)	echo -n "Please enter 'move id'(1~1682): "
                        read moveid
			echo -n "avaerage rating of $moveid :"
			awk -F'\t' -v n=$moveid 'NR==n {printf "%.6f\n", $3}' u.data
			;;
		4)	echo -n "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n)"
			read yn
			if [ "$yn" = "y" ]
                        then
				awk -F'|' '{ $5 = ""; print }' OFS='|' u.item > new_u.item
                        fi
			int=1
			while [ "$int" -lt 11 ]
			do
    				sed -n "${int}p" new_u.item
    				int=$((int + 1))
			done
			;;
		5)	echo -n "Do you want to get the data about usersfrom ‘u.user’?(y/n)"
			read yn
                        if [ "$yn" = "y" ]
                        then
                                int=1
                                while [ "$int" -lt 11 ]
                                do
                                echo -n "User "
                                sed -n "${int}p" u.user |  awk -F'|' '{print $1, "is ",$2, "years old ",$3,$4}'
                                int=$((int + 1))
                                done
			fi
			;;
		6)	echo -n "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n)"
	read yn
	if [ "$yn" = "y" ]
	then
		awk -F'|' '{ cmd = "date -d \"" $3 "\" \"+%Y%m%d\""; cmd | getline new_date; close(cmd); $3 = new_date; print }' u.item > temp_file
		mv temp_file u.item
		tail -n 10 u.item
	fi
	;;

		7) echo -n "Please enter the ‘user id’(1~943): "
   read user_id

   echo "$user_id"
   awk -v user="$user_id" -F'\t' '$1 == user {printf "%s|", $2}' u.data | sed 's/|$//' | awk 'BEGIN {FS = "|"} {OFS = "|"; $1=$1; print}'

   awk -v user="$user_id" -F'\t' '$1 == user {print $2}' u.data | sort -n | uniq | while read line; do grep "$line|" u.item; done | head -10 | awk -F'|' '{print $1, "|", $2}'
   awk -F'|' '$1 == user_id {print $1, $2)}' u.item


			;;
		8)	echo -n "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n)"
			read yn
                        if [ "$yn" = "y" ]
                        then                          
				user_id=$(awk -F'|' '$2 >= 20 && $2 <= 29 && $3 == "programmer" {print $1; exit}' u.user)
			       if [ -n "$user_id" ]
				then
			 		awk -F'\t' -v user_id="$user_id" '$1 == user_id {print $3}' u.data
				fi
                        fi
                        ;;

		9) 	echo "Bye!"
			exit 0
			;;
		*)	 echo -n "Please input number betwen 1 and 9,"
			;;
	esac
done
