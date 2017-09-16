#!/bin/sh
echo "Generating INCAR and KPOINTS..."
touch INCAR
touch KPOINTS

echo "System = $1" >INCAR
echo "ISTART = 0">>INCAR
echo "ENCUT = na">>INCAR
echo "EDIFF = 1e-05">>INCAR
echo "NSW = 0">>INCAR
echo "ICHARG = 2">>INCAR
echo "IBRION = -1">>INCAR
echo "INCAR generated sucessfully"

echo "k-points">KPOINTS
echo "0">>KPOINTS
echo "Monkhorst-pack">>KPOINTS
echo "na na na">>KPOINTS
echo "0 0 0">>KPOINTS
echo "KPOINTS generated successfully"

echo "Please create jobfile, POSCAR and PODCAR files"

