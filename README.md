# Automator
Scripts for automating SCF calculations, optimizing ENCUT, K-Points and lattice parameters required for carrying out VASP Calculations.

## Usage
The jobfile should be without nohup and &, and if you come across any error such as not able to run the script due to any error please run (the error is caused due to non UNIX line endings in code)
```
sed -i -e 's/\r$//' automator.sh
sed -i -e 's/\r$//' generate.sh
```
