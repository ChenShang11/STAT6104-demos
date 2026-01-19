# terminal-ols.jl
# Chris Harshaw, January 2026
# Columbia University
#
# This is a Julia file that we can run from the terminal.

using LinearAlgebra

# set dimension, noise param
n = 20
d = 2
sigma = 0.1

# create the linear parameter
beta = ones(d)

# create covariates and outcomes
X = randn(n,d)
noise = randn(n) * sigma
Y = X * beta + noise

# run OLS and measure error
beta_ols = inv(X'*X) * X' * Y
l2_error = norm(beta - beta_ols)

# print the results
println("\n\nProblem Description")
println("========================")
println("n=$n")
println("d=$d")
println("sigma=$sigma")

println("\nOLS Results")
println("========================")
println("True Beta: $beta")
println("OLS Estimate: $beta_ols")
println("L2 Error: $l2_error")
println("\n\n")