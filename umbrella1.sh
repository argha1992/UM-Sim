#!/bin/bash

# Use . as the decimal separator
export LC_NUMERIC=en_US.UTF-8

# Rang and spacing of the reaction coordinate
MIN_WINDOW=1.1
MAX_WINDOW=4.9
#MAX_WINDOW=10.0
WINDOW_STEP=0.2

for window in $(seq ${MIN_WINDOW} ${WINDOW_STEP} ${MAX_WINDOW})
do

  mkdir $window

  cp md.mdp $window
  cp topol.top $window
  cp index_pull.ndx $window
  cp -r toppar/ $window
  #cp ../../2.1_initial_configuration/$window/eq.gro $window
  cd $window

  sed "s/POS1/$window/g" -i md.mdp

  #gmx_mpi editconf -f ../../2.1_initial_configuration/$window/eq.gro -box 16 16 10 -o eq2.gro
  #gmx_mpi grompp -f md.mdp -c eq2.gro -r eq2.gro -p topol.top -n index_pull.ndx -maxwarn -1 -o md.tpr
  gmx_mpi grompp -f md.mdp -c ../../2.1_initial_configuration/$window/eq.gro -r ../../2.1_initial_configuration/$window/eq.gro -p topol.top -n index_pull.ndx -maxwarn -1 -o md.tpr
  
  
  gmx_mpi mdrun -deffnm md -c md.gro -v -px md_x -pf md_f &> mdrun.log
  #gmx_mpi mdrun -deffnm md -c md.gro -v -px md_x -pf md_f &> mdrun.log
  cd ../

done
