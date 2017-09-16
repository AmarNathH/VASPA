#!/bin/sh
echo "VASP Automator Script"
echo "Running at Process ID:$$"

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

