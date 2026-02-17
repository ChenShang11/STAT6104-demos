# HPC Tutorial

Here are the things that we are going to do in this tutorial:

1. SSH into the cluster
2. Practice linux commands
3. Launch an interactive job
4. Submit a job through a bash script

I intend for this tutorial to take 90 minutes.

## SSH Into the Cluster (5 minutes)

We will first begin by using SSH (Secure Shell Protocol) to log into the cluster.
If you are on Linux / Mac OS, you can do this by running

>  ssh <YOUR UNI>@<CLUSTER>.rcs.columbia.edu

If you are using Windows, then you can use an SSH client like PuTTY [link](https://putty.org/index.html) and I think Windows Terminal also has support for this now.

**NOTE**: You are on the login node! Do not run anything computationally intensive from this login node! It is only for submitting jobs and basic processes, e.g. text editing.

## Practicing Linux Commands (15 minutes)

We are on the Columbia research clusters (Ginsberg, Insomnia, etc) which run Linux operating system.
We will need to become familiar with Linux commands like:

- `pwd`: print your working directory
- `ls`: list your files
- `cd`: change directory
  - `cd dir` moves you into the local directory dir
  - `cd ../` moves you up into the parent directory
- `mkdir` creates a new directory

Next, let me get you used to using a basic command-line text editor: nano.

- Create a new directory in your home directory called `hello-world`
- Use nano to create a new file `hello-world.jl` that computes a determinant, prints out hello, world message including number of threads

**Additional Items**

- You can set up VSCode to edit files remotely via ssh [link](https://code.visualstudio.com/docs/remote/ssh)
- You should try to debug your programs entirely on your computer first

## Interactive Session (20 minutes)

We can launch an interactive job using the following command:

> srun --pty -t 0-02:00 -A <ACCOUNT> /bin/bash

where you replace <ACCOUNT> with your account.
Mine is `stats` because I am on Ginsburg, but yours is probably `edu`, if you got access to Insomnia thru this class.

In the interactive session, let's go ahead and set up Julia.

- note that we can't run julia by typing `julia` in the command line. This is because it's not loaded
- run `module load julia`
- we are directed to run `juliaup` which creates
- run Julia, add the following packages: Revise, Statistics, StatsBase, Plots
- now that we are on a compute node, we can run our `hello-world.jl` as `julia --threads=auto hello-world.jl`

Interactive sessions are great for debugging or making minor changes to your code, but not much else.
So, let's exit the interactive session

## Secure File Transfer (20 minutes)

The directory `lecture5-hpc` in my github repo contains multi-threaded code for evaluating bootstrap covariance estimates via Monte Carlo.
It's a computationally intensive task -- I presume you have looked through it, but I'll give a brief review now (5 min max)

- let's run this code on our computers
- julia --threads=auto bootstrap-plot.jl
- it should take about a minute, but it will produce a nice plot

We can increase n and let this run for even longer on the cluster.
But wait - how do we transfer these files over?

You can transfer a single file like this 

> scp <FILE> <UNI>@motion.rcs.columbia.edu:<LOCATION>

I will type in

> scp bootstrap-ols.jl crh2167@motion.rcs.columbia.edu:/burg-archive/home/crh2167

and let's check that this moves the file to my home directory in Ginsberg.

But we can actually copy a whole directory recursively by adding the `-r ` option to `scp`
For this purpose, I will run

> scp -r lecture5-hpc crh2167@motion.rcs.columbia.edu:/burg-archive/home/crh2167

And now I've gotten all my files transfered!

**Additional Items**

- You can use SCP clients to have an easier-to-use-GUI, e.g. Cyberduck [link](https://cyberduck.io/) for Mac OS and WinSCP [link](https://winscp.net/eng/index.php) for Windows 
- This is not the best way to send large files, e.g. actual large data. For this, you will want to use Globus 
- If you want to store large data files, you have to do it on your scratch space, which is somewhere else
- Do not assume that anything on the Columbia HPC is backed up -- it is not!
  
## Slurm Scripting (30 minutes)

When you want to set up a larger job (i.e. most jobs on the cluster) to run, you need to use a Slurm script.
Slurm is a popular open-source resource management and job scheduling application used on many HPC clusters and supercomputers, including the Columbia HPC clusters.

I've included a bash script `bootstrap.sh` in the `src` file of the `lecture5-hpc` directory.
Let's break down what it's doing

- `#!/bin/bash`: this is the "shebang" which is a convention to let Unix shell know what interpreter to run
- `#SBATCH`: these contain the configurations of the job you are requesting to submit
  - `account`: you will need to set this to your own account on the cluster (e.g. `edu`)
  - `job-name`: the name for your job - make it descriptive!
  - `-c`: the number of CPU cores that you are requesting
  - `time`: we set the time as `D-HH:MM` but there are many ways to do it
  - `mem-per-cpu`: the memory the job will use per CPU core (100 MB in our case)
- `echo` prints the message out
- `module load julia` we load the julia so that we can use it later
- `julia --threads=auto bootstrap-plot.jl`: this is our main bash command to run our program
- `date` will print the data

In order to run these jobs, we use the `sbatch` command, like this

> sbatch bootstrap.sh

And congratulations -- you've just submitted your first (non-interactive) job on the cluster!
Your job will not run immediately; instead, it sits in the queue based on its memory and compute requirements.
If you want to monitor your job, you can run the command

> squeue -u UNI

and you will be shown all of your jobs, their status, time running, etc.
Let's take a few moments to see if our jobs will begin running quickly.

**Exercise**: Run the bootstrap code for larger sample sizes, say `n=2000`

**Additional Items**

- You can set SBATCH job options to email you when a long job finishes, or if it crashes!
- You can set SBATCH job options to send the output to a specific folder / location (good organization practice)
- Take a look at all the SBATCH job options on the documentation

