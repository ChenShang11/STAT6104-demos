# Lecture 1 Tutorials

About 45 minutes of the first lecture should consist of these tutorials.

## Tutorial 1 -- Julia REPL

First, I will show you how to use the Julia interactive command-line REPL (read-eval-print-loop).
My goal will be to run a simple 1-dimensional linear regression.
But, we'll see that this is not a sustainable programming environment for more complex programs.

## Tutorial 2 -- Julia with Jupyter Notebook

I will show you how to launch a Jupyter Notebook with a Julia kernel.
I will show us 
You will see

- how to import code using `Revise.jl`
- see the output of your code, and write in markdown
- avoid certain pitfalls (locally defined variables)
- use basic plotting packages

Next, I will show you that OLS does not perform well when $X^\top X$ is singular.
We will fix that error by using a ridge regression.

## Tutorial 3 -- GitHub

I will need to update the GitHub repository with this new and improved code.
We'll first take a look at the repository, then we'll commit and push.
I will ask Ting to make a change in this file.
We will see the change in the GitHub (but not my local repo).
Then I will pull his changes and we'll see them on my laptop.

Oh wait but it wouldn't be a complete tutorial unless we force a merge error.
Let's both edit this next line to say something different, and push:

The quick brown fox jumps over the lazy dog.

And for our last trick, I will cause a merge conflict !