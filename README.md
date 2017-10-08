# Automator
Scripts for automating SCF calculations, optimizing ENCUT, K-Points and lattice parameters required for carrying out VASP Calculations.

## Usage
The jobfile should be without nohup and &, and if you come across any error such as not able to run the script due to any error please run (the error is caused due to non UNIX line endings in code)
```
sed -i -e 's/\r$//' automator.sh
sed -i -e 's/\r$//' generate.sh
```
You can also use chmod u+x command for resolving file permission issues
## Running ENCUT and KPOINT optimisation
The script automator.sh can be used to run ENCUT and KPOINT optimisation, INCAR and KPOINT files will be generated automatically with default values.(Before running the script make sure you have POTCAR and POSCAR files).
The output will be stored in ENCUT_data and KPOINT_data, and it will contain energy values for corresponding ENCUT and KPOINT values.

## Running Lattice parameter optimisation
After doing ENCUT and KPOINT optimisation, The script optimize_latparam.sh can be used to run lattice parameter optimisations, the script basically runs all the files in POSCAR_files directory (Please make sure you make the directory under the same name and put POSCAR files there).

Format for POSCAR files to be stored in POSCAR_files directory : \_POSCAR_<Desired_name>

<Desired_name> can be anything without spaces, the output POSCAR_data will contain the file names and corresponding energy values.
