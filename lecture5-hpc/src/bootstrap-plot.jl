# bootstrap-ols.jl
# Chris Harshaw, February 2026
# Columbia University
#
# Create a plot of bootstrap estimate error

using Revise
using StatsBase
using Statistics
using LinearAlgebra
using Plots

includet("bootstrap-ols.jl")

# set experiment parameters
n_max = 500
n_min = 100
n_num = 10
d = 20
sigma = 1
num_mc = 500

fig_folder = joinpath(abspath(joinpath(pwd(), "..", "figs")))
if !isdir(fig_folder) # make the 
    mkdir(fig_folder)
end
file_name = joinpath(fig_folder, "bootstrap_err_n_$n_max.pdf")

# determine the values of n 
n_vals = [round(Int, n) for n in range(start=n_min, stop=n_max, length=n_num)]

# initialize array
cov_err_vals = zeros(n_num)
time_vals = zeros(n_num)

# print information
println("\nTesting Bootstrap Covariance Estimators")
println("===========================")
nthreads = Threads.nthreads()
println("Using $nthreads threads")

println("\n\nExperiment Parameters")
println("===========================")
println("Sample Sizes: min=$n_min, max=$n_max, number=$n_num")
println("Dimension: d=$d")
println("Noise: sigma=$sigma")
println("Num Bootstrap = n")
println("Num Monte Carlo = $num_mc")

println("\n\nCovariance Error Estimates")
println("===========================")

# print information
for (i,n) in enumerate(n_vals)

    # create the data 
    X, beta = create_data(n,d)

    # burn run
    if i == 1
        mc_cov_error(X, beta, sigma, n, 1);
    end

    # run the monte carlo estimation procedure
    elap_time = @elapsed cov_err = mc_cov_error(X, beta, sigma, n, num_mc)

    # save values
    cov_err_vals[i] = cov_err
    time_vals[i] = elap_time

    # print results
    println("n=$n \t Error=$cov_err \t Time=$elap_time")
end

# print total time 
total_time = sum(time_vals) / 60
println("\n\nTotal time: $total_time minutes")

# create a plot
println("\nCreating and saving the plot...")
plot(n_vals, cov_err_vals)
xlabel!("Sample Size (n)")
ylabel!("Cov Estimator Error")
title!("Evaluating Bootstrap Covariance Estimator")
savefig(file_name)

println("\nAll done!")