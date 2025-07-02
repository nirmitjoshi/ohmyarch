#!/bin/bash

logo() {
	echo -ne "


 ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗     █████╗ ██████╗  ██████╗██╗  ██╗      ██╗██████╗ 
██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔════╝██║  ██║     ██╔╝╚════██╗
██║   ██║███████║    ██╔████╔██║ ╚████╔╝     ███████║██████╔╝██║     ███████║    ██╔╝  █████╔╝
██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝      ██╔══██║██╔══██╗██║     ██╔══██║    ╚██╗  ╚═══██╗
╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ██║  ██║██║  ██║╚██████╗██║  ██║     ╚██╗██████╔╝
 ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝      ╚═╝╚═════╝ 
                                                                                              
-----------------------------------------------------------------------------------------------

"
}

set_pref() {
	if grep -Eq "^${1}.*" $PREF_FILE; then
		sed -i -e "/^${1}.*/d" $PREF_FILEdeletes preference if it exists
	fi
	echo "${1}=${2}" >>$PREF_FILE
}

getch() {
	local char

	stty -echo
	stty raw
	echo -ne "Press any key to continue... "
	IFS= read -n 1 char
	stty echo
	stty -raw
}

root_check() {
	if [[ "$(id -u)" != "0" ]]; then
		echo -ne "ERROR! This script must be ran as ROOT\n"
		exit 0
	fi
}

arch_check() {
	if [[ ! -e /etc/arch-release ]]; then
		echo -ne "ERROR! This script must be ran in Arch Linux!\n"
		exit 0
	fi
}

bootmode_check() {
	command=$(cat /sys/firmware/efi/fw_platform_size)
	if [ "$command" -eq 64 ]; then
		clear
		logo
	elif [ "$command" -eq 32 ]; then
		echo "System is x32 UEFI"
		echo "This script presently supports only x64 UEFI Installation, so exiting..."
		sleep 3s
		exit 0
	else
		echo "System is not in UEFI"
		echo "This script presently supports only x64 UEFI Installation, so exiting..."
		sleep 3s
		exit 0
	fi
}

pacman_check() {
	if [[ -f /var/lib/pacman/db.lck ]]; then
		echo "ERROR! Pacman is blocked."
		echo -ne "If not running remove /var/lib/pacman/db.lck.\n"
		exit 0
	fi
}

bg_check() {

	root_check
	bootmode_check
	arch_check
	pacman_check

}

clrscr() {

	clear
	logo
}

get_hostname() {

	read -p "Enter hostname for the system: " hostname

	if [[ ${#hostname} -lt 1 || ${#hostname} -gt 255 ]]; then
		echo "ERROR! Hostname length must be between 1 and 255 characters."
		get_hostname
	fi

	if ! [[ "$hostname" =~ ^[a-zA-Z0-9.-]+$ ]]; then
		echo "ERROR! Hostname contains invalid characters. Use letters, digits, dots, and hyphens."
		get_hostname
	fi

	if [[ "${hostname:0:1}" == "." || "${hostname: -1}" == "." ]]; then
		echo "ERROR! Hostname cannot start or end with a dot."
		get_hostname
	fi

	set_pref "hostname" "$hostname"
	echo -e "\n"
}

get_username() {

	read -p "Enter USERNAME for user: " username

	if [[ ${#username} -lt 1 || ${#username} -gt 32 ]]; then
		echo "Invalid: Username length must be between 1 and 32 characters."
		get_username
	fi

	if ! [[ "$username" =~ ^[a-z0-9_-]+$ ]]; then
		echo "Invalid: Username contains invalid characters. Use lowercase letters, digits, underscores, and hyphens."
		get_username
	fi

	if [[ "${username:0:1}" == "-" ]]; then
		echo "Invalid: Username cannot start with a hyphen."
		get_username
	fi

	case "$username" in
	root | daemon | nobody | other_reserved_usernames)
		echo "Invalid: Reserved username. Choose a different username."
		get_username
		;;
	*) ;;
	esac

	set_pref "username" "$username"
}

get_password_root() {
	read -rs -p "Please enter password for ROOT: " PASSWORD1
	echo -ne "\n"
	read -rs -p "Please re-enter password: " PASSWORD2
	echo -ne "\n"
	if [[ "$PASSWORD1" == "$PASSWORD2" ]]; then
		set_pref "root_pass" "$PASSWORD1"
	else
		echo -ne "ERROR! Passwords do not match. \n"
		get_password_root
	fi
}

get_password_user() {
	read -rs -p "Please enter password for user: " PASSWORD1
	echo -ne "\n"
	read -rs -p "Please re-enter password: " PASSWORD2
	echo -ne "\n"
	if [[ "$PASSWORD1" == "$PASSWORD2" ]]; then
		set_pref "user_pass" "$PASSWORD1"
	else
		echo -ne "\nERROR! Passwords do not match. \n"
		get_password_user
	fi
}

get_timezone() {

	time_zone="$(curl --fail https://ipapi.co/timezone)"
	echo -ne "System detected your timezone to be '$time_zone' \n"
	echo -ne "Is this correct? (Y/n): "
	read selection

	case ${selection} in
	y | Y | yes | Yes | YES | "")
		echo -e "\nOkay setting your timezone as ${time_zone}"
		set_pref "timezone" "$time_zone"
		;;
	n | N | no | NO | No)
		echo "Please enter your desired timezone (e.g. Asia/Kolkata):"
		read new_timezone
		echo -e "\nOkay setting your timezone as ${new_timezone}"
		set_pref "timezone" "$new_timezone"
		;;
	*)
		echo "Wrong option. Try again"
		get_timezone
		;;
	esac
}

get_disk() {
	valid_disk=false

	while [ "$valid_disk" = false ]; do
		clear
		logo
		echo -e "Please select disk dor Arch Installation\n"
		echo -e "Available disks:\n"
		lsblk
		echo -e "\n"
		read -p "Enter disk (e.g /dev/sdX): " disk

		# Check if the disk exists and is a block device
		if [ -e "$disk" ] && [ -b "$disk" ]; then
			valid_disk=true
		else
			echo -e "\nInvalid disk. Please enter a valid disk device again."
			getch
		fi
	done

	clear
	logo
	echo "You have selected $disk"
	echo -e "NOTE: This will wipe out whole disk make sure you have backed it up!\n"
	read -p "Confirm your disk selection (Y/n): " confirm
	case ${confirm} in
	y | Y | yes | Yes | YES | "")
		echo -e "\nOkay setting your disk as ${disk}"
		set_pref "disk" "$disk"
		getch
		;;
	*)
		echo "Please Select your disk again"
		get_disk
		;;
	esac

	disk_size() {
		clear
		logo
		# Getting the disk size in GB (in base-2 system)
		usable_space_gb=$(lsblk -b -n -o SIZE -d "$disk" | awk '{ printf "%.2f", $1 / (1024^3) }')

		echo -e "Usable disk space on $disk is: $usable_space_gb GB"
		echo -e "\n\e[1mImportant Things to NOTE:\e[0m"
		echo -e "1) 512Mb of disk size will be used for BOOT Partition"
		echo -e "2) Remaining Space after ROOT partition will be used for HOME"
		echo -e "3) HOME Partition should atleast be of 5GB"
		echo -e "4) Both ROOT and HOME partitions will be ext4\n"
		read -p "Enter Partition size for ROOT (in GB): " root_partn_size_gb

		usable_space_mb=$(lsblk -b -n -o SIZE -d "$disk" | awk '{ printf "%d", $1 / (1024^2) }')
		root_partn_size_mb=$((root_partn_size_gb * 1024))

		if [ "$((root_partn_size_mb + 512))" -gt "$usable_space_mb" ]; then
			echo -e "\nERROR! ROOT Partition size exceeds the disk Space"
			echo -e "Please Re-enter a valid partition size...\n"
			getch
			disk_size
		elif [ "$((root_partn_size_mb + 512 + 5120))" -gt "$usable_space_mb" ]; then # 512Mb + 5Gb
			echo -e "\nERROR! No Space left for HOME Partition (see point 3)"
			echo -e "Please Re-enter a valid partition size...\n"
			getch
			disk_size
		else
			echo "$root_partn_size_gb"
			set_pref "root_partn_size_gb" "$root_partn_size_gb"
		fi
	}

	disk_size

}
