#!/usr/bin/env bash
clear
name 'Ahmad'
echo "Hello $nam"
echo -e "\nThis is my script.\n"
echo -e "The files in #PWD are:\n$(ls)"
echo -e"\nCopying the passwed file to your current dir.\n"
cp /etc/passwd $PWD
echo -e "The files in #PWD are now \n$(ls)"
echo " "
echo "Have great day!"

