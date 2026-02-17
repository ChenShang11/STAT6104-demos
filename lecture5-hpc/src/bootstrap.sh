#!/bin/sh
#
# Submit the bootrstrap job for Slurm.
#
#SBATCH --account=stats 			# this is my account (what is yours?)
#SBATCH --job-name=Bootstrap-Small-Mem		# the job name
#SBATCH -c 32					# the number of CPU cores to use 
#SBATCH --time=0-00:30				# the time the job will take to run D-HH:MM
#SBATCH --mem-per-cpu=100m			# the memory the job will use per CPU core

echo "Let's begin our bootstrap adventures!"

module load julia

julia --threads=auto bootstrap-plot.jl

date

# End of script
