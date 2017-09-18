#!/usr/bin/bash

echo "VASP Automator Script"
echo "Running at Process ID:$$"

read -p "Enter initial ENCUT:" ENCUT
read -p "Enter ENCUT_step:" ENCUT_step
read -p "Is the material planar(P) or Bulk(B)? " mat_state
read -p "Enter no of initial K-points :" KPOI
read -p "Enter KPOI_step:" KPOI_step

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

if [ -e POTCAR ]
then
echo "POTCAR found"
else
echo "POTCAR not found"
exit 0
fi

if [ -e POSCAR ]
then
echo "POSCAR found"
else
echo "POSCAR not found"
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

deltaE_cutoff=0.001 #an accuracy of 1meV
deltaE_cutoff=$(echo "$deltaE_cutoff*(-1)"|bc)

touch ENCUT_data #stores ENCUT data
echo "ENCUT Convergence">ENCUT_data
echo "Running jobfile with ENCUT = $ENCUT and KPOINTS = $KPOI"
./jobfile
ENERGY=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY=$(printf "%.6f" "$ENERGY")
delta_E=$(printf "%.6f" "$ENERGY")
echo "ENCUT = $ENCUT, KPOINTS = $KPOI, E0 = $ENERGY, dE = 0" >> ENCUT_data
#delta_E=$(echo "$delta_E*(-1)"|bc) #to make delta_E positive for loop enter

#loop to calculate ENCUT convergence
while [ 1 -eq "$(echo "$delta_E < $deltaE_cutoff" | bc -l)" ]; do
ENCUT=$(echo "$ENCUT + $ENCUT_step"|bc)
#write code for writing ENCUT value to INCAR
sed -i "3s/.*/ENCUT = $ENCUT/" INCAR#replace ENCUT line in INCAR 
echo "Running jobfile with ENCUT = $ENCUT and KPOINTS = $KPOI"
./jobfile
ENERGY=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY=$(printf "%.6f" "$delta_E")
delta_E=$(echo "$ENERGY - $delta_E" |bc)
echo "ENCUT = $ENCUT, KPOINTS = $KPOI, E0 = $ENERGY, dE = $delta_E" >> ENCUT_data
done

