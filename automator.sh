#!/bin/sh
echo "VASP Automator Script"
echo "Running at Process ID:$$"

echo "Enter initial ENCUT:"
read ENCUT
echo "Is the material planar(P) or Bulk(B)? "
read mat_state
echo "Enter no of initial K-points :"
read KPOI

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
sed -i "3s/na/$ENCUT/" INCAR
if [ $mat_state="P" ]
then
sed -i "4s/na na na/$KPOI $KPOI 1/" KPOINTS
else
sed -i "4s/na na na/$KPOI $KPOI $KPOI/" KPOINTS
fi
