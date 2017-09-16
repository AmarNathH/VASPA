#!/bin/sh
echo "VASP Automator Script"
echo "Running at Process ID:$$"

echo "Initial ENCUT : $1"
echo "Initial Kpoints : $2"

if [ -e INCAR ]
then
echo "INCAR found"
else
echo "INCAR not found, please use generator script to make one"
exit 0
fi

if [ -e KPOINTS ]
then
echo "KPOINTS found"
else
echo "KPOINTS not found, please use generator script to make one"
exit 0
fi

echo "Setting initial ENCUT and KPOINT values..."
sed -i "3s/na/$1/" INCAR
sed -i "4s/na na na/$2/" KPOINTS
