#!/bin/bash

#This program will generate a hash command line in linux

cd Desktop

touch Generate_key.txt

sha256sum  Generate_key.txt

date > hresult.txt

echo " " >> hresult.txt

sha256sum Generate_key.txt >> hresult.txt

echo "This is effing cool." >> Generate_key.txt

echo " " >> hresult.txt

date >> hresult.txt

echo " " >> hresult.txt

chmod 744 hresult.txt

sha256sum Generate_key.txt >> hresult.txt

echo "Script Complete" 

exit 0
