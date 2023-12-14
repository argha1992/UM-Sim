#!/bin/bash

# Use . as the decimal separator
export LC_NUMERIC=en_US.UTF-8

# Rang and spacing of the reaction coordinate
MIN_WINDOW=0.1
MAX_WINDOW=4.9
WINDOW_STEP=0.2

for window in $(seq ${MIN_WINDOW} ${WINDOW_STEP} ${MAX_WINDOW})
do

  mkdir $window

  cp *.mdp $window
  cp topol.top $window
  cp index_pull.ndx $window
  cp -r toppar/ $window
  cp step6.7_equilibration.gro $window

  cd $window

  sed "s/POS1/$window/g" -i pull.mdp
  sed "s/POS1/$window/g" -i em.mdp 
  sed "s/POS1/$window/g" -i em2.mdp 
  sed "s/POS1/$window/g" -i eq.mdp
  sed "s/POS1/$window/g" -i eq2.mdp



  gmx_mpi grompp -f pull.mdp -c step6.7_equilibration.gro -r step6.7_equilibration.gro -p topol.top -o pull.tpr -n index_pull.ndx -maxwarn -1
  gmx_mpi mdrun -deffnm pull -c pull.gro -v &> pullrun.log

  gmx_mpi grompp -f em.mdp -c pull.gro  -r pull.gro -p topol.top  -o em.tpr -n index_pull.ndx -maxwarn -1
  gmx_mpi mdrun -deffnm em -c em.gro -v  &> emrun.log

  gmx_mpi grompp -f em2.mdp -c em.gro -r em.gro -p topol.top  -o em2.tpr -n index_pull.ndx -maxwarn -1
  gmx_mpi mdrun -deffnm em2 -c em2.gro -v &> em2run.log

  gmx_mpi grompp -f eq.mdp -c em2.gro -r em2.gro -p topol.top  -o eq.tpr -n index_pull.ndx -maxwarn -1
  gmx_mpi mdrun -deffnm eq -c eq.gro -v -px eq_x -pf eq_f &> eqrun.log

  gmx_mpi grompp -f eq2.mdp -c eq.gro -r eq.gro -p topol.top  -o eq2.tpr -n index_pull.ndx -maxwarn -1
  gmx_mpi mdrun -deffnm eq2 -c eq2.gro -v -px eq2_x -pf eq2_f &> eq2run.log


  cd ../

done
