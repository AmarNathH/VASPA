#!/bin/sh
echo "VASP Automator Script"
echo "Running at Process ID:$$"

echo "Enter initial ENCUT:"
read ENCUT
echo "Enter ENCUT_step:"
read ENCUT_step
echo "Is the material planar(P) or Bulk(B)? "
read mat_state
echo "Enter no of initial K-points :"
read KPOI
echo "Enter KPOI_step:"
read KPOI_step

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

acc=0.001

touch ENCUT_data
echo "ENCUT Convergence">ENCUT_data
echo "Running jobfile with ENCUT = $ENCUT and KPOINTS = $KPOI"
./jobfile
#grep -Po 'E0= \K[^ ]+' out >> ENCUT_data
ENERGY=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY=$(printf "%.6f" "$delta_E")
delta_E=$(grep -Po 'E0= \K[^ ]+' out)
delta_E=$(printf "%.6f" "$delta_E")
echo "ENCUT = $ENCUT, KPOINTS = $KPOI, E0 = $ENERGY, dE = 0" >> ENCUT_data


while [ 1 -eq "$(echo "$delta_E > $acc" | bc -l)" ]; do
ENCUT=$(echo "$ENCUT + $ENCUT_step"|bc)
KPOI=$(echo "$KPOI + $KPOI_step"|bc)
echo "Running jobfile with ENCUT = $ENCUT and KPOINTS = $KPOI"
./jobfile
ENERGY=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY=$(printf "%.6f" "$delta_E")
delta_E=$(echo "$delta_E - $ENERGY" |bc)
echo "ENCUT = $ENCUT, KPOINTS = $KPOI, E0 = $ENERGY, dE = $delta_E" >> ENCUT_data
done

