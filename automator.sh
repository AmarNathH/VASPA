#!/bin/bash
echo "VASP Automator Script"
echo "Running at Process ID:$$"

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

read -p "Experiment Name:" EXP_N
read -p "Enter initial ENCUT:" ENCUT
read -p "Enter ENCUT_step:" ENCUT_step
read -p "Is the material planar(P) or Bulk(B)? " mat_state
read -p "Enter no of initial K-points :" KPOI
read -p "Enter KPOI_step:" KPOI_step

./generate.sh $EXP_N

echo "Setting initial ENCUT and KPOINT values..."
sed -i "3s/na/$ENCUT/" INCAR
if [ $mat_state="P" ]
then
sed -i "4s/na na na/$KPOI $KPOI 1/" KPOINTS
else
sed -i "4s/na na na/$KPOI $KPOI $KPOI/" KPOINTS
fi

deltaE_cutoff=0.001 #an accuracy of 1meV

touch ENCUT_data #stores ENCUT data
echo "ENCUT Convergence">ENCUT_data
echo "Running jobfile with ENCUT = $ENCUT and KPOINTS = $KPOI"
./jobfile

delta_E=60
ENERGY_I=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY_I=$(printf "%.10f" "$ENERGY_I")
if [ 1 -eq "$(echo "$ENERGY_I < 0"|bc -l)" ]
then
ENERGY_I=$(echo "0-$ENERGY_I"|bc)
fi

echo "ENCUT = $ENCUT, KPOINTS = $KPOI, E0 = $ENERGY_I, dE = 0" >> ENCUT_data

#loop to calculate ENCUT convergence
while [ 1 -eq "$(echo "$delta_E > $deltaE_cutoff" | bc -l)" ]; do
ENCUT=$(echo "$ENCUT + $ENCUT_step"|bc)
sed -i "3s/.*/ENCUT = $ENCUT/" INCAR #replace ENCUT line in INCAR 
echo "Running jobfile with ENCUT = $ENCUT and KPOINTS = $KPOI"
./jobfile
ENERGY_F=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY_F=$(printf "%.10f" "$ENERGY_F")
if [ 1 -eq "$(echo "$ENERGY_F <0"|bc -l)"  ]
then
ENERGY_F=$(echo "0 - $ENERGY_F"|bc)
fi

delta_E=$(echo "$ENERGY_F - $ENERGY_I" |bc)
if [ 1 -eq "$(echo "$delta_E<0"|bc -l)"  ]
then
delta_E=$(echo "0 - $delta_E"|bc)
fi

echo "ENCUT = $ENCUT, KPOINTS = $KPOI, E0 = $ENERGY_F, dE = $delta_E" >> ENCUT_data
ENERGY_I=$(echo "$ENERGY_F"|bc)
done

