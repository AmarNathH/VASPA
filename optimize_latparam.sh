#!/bin/bash

echo "CAUTION: Please do ENCUT and KPOINT optimisation before lattice parameter optimisation"
read -p "No of cores you want to run simulation on:" N_CORES 

POSCAR_filelist=(POSCAR_files/*_POSCAR*)
touch POSCAR_data
echo "POSCAR_data" > POSCAR_data
COUNT=0
ENERGY=0

echo "Running simulation for ${#POSCAR_filelist[@]} POSCAR files"

while [ "$COUNT" -ne "${#POSCAR_filelist[@]}" ]
do
cat "${POSCAR_filelist[$COUNT]}" > POSCAR
echo "Running calculation for ${POSCAR_filelist[$COUNT]}"
./jobfile N_CORES 
ENERGY=$(grep -Po 'E0= \K[^ ]+' out)
ENERGY=$(printf "%.10f" "$ENERGY")
echo "File:${POSCAR_filelist[$COUNT]} Energy:$ENERGY" >> POSCAR_data
((COUNT++))
done

