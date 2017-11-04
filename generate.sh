#!/bin/bash
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

if [ -e extra_INCAR_tags ]
then
echo "Found extra_INCAR_tags file"
cat extra_INCAR_tags >> INCAR
echo "INCAR tags added:"
cat extra_INCAR_tags
else
echo "No extra_INCAR_tags file found"
fi


echo "k-points">KPOINTS
echo "0">>KPOINTS
echo "Monkhorst-pack">>KPOINTS
echo "na na na">>KPOINTS
echo "0 0 0">>KPOINTS
echo "KPOINTS generated successfully"

