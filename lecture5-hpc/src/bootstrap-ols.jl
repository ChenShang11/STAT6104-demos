# bootstrap-ols.jl
# Chris Harshaw, February 2026
# Columbia University
#
# Contains code for bootstrap procedure
# using OLS

using Revise
using StatsBase
using Statistics
using LinearAlgebra

"""
    my_ols(Y, X)

Compute OLS estimator given response `Y` and covariates `X`

# Arguments
- `Y`: responses, `n`-dimensional array 
- `X`: covariates, `n`-by-`d` dimensional matrix

# Output
- `beta_ols`: linear parameter estimate, `d` dimensional array
"""
function my_ols(Y, X)
    beta_ols = (X'*X) \ (X'*Y)
    return beta_ols
end

"""
    bootstrap_cov_est(Y, X, num_bs)

Bootstrap estimate of the OLS estimator covariance

# Arguments
- `Y`: responses, `n`-dimensional array 
- `X`: covariates, `n`-by-`d` dimensional matrix
- `num_bs`: the number of bootstrap samples

# Output
- `cov_est`: bootstrap covariance estimate, `d`-by-`d` array
"""
function bootstrap_cov_est(Y, X, num_bs)

    # get dimensions
    n,d = size(X)
    @assert length(Y) == n

    # initialize array of bootstrap estimates
    beta_bs = zeros(num_bs, d)

    # for each bootstrap iteration
    Threads.@threads for t=1:num_bs

        # draw bootstrap sample 
        bs_idx = sample(1:n, n, replace=true)

        # get OLS estimate
        beta = my_ols(Y[bs_idx], X[bs_idx,:])

        # save in the array
        beta_bs[t, :] = beta
    end

    # compute empirical covariance of bootstrap estimates
    cov_est = cov(beta_bs)
    return cov_est
end

"""
    mc_cov_error(X, sigma, num_bs, num_mc)

Monte Carlo estimate of the error of the OLS bootstrap covariance estimator

# Arguments
- `X`: covariates, `n`-by-`d` dimensional matrix
- `beta`: the true OLS parameter
- `sigma`: std of the error term
- `num_bs`: the number of bootstrap samples
- `num_mc`: the number of Monte Carlo samples

# Output
- `cov_err`: monte carlo estimate of E[ || cov_ols - cov_bs || ]
"""
function mc_cov_error(X, beta, sigma, num_bs, num_mc)

    # get dimensions
    n,d = size(X)
    @assert length(beta) == d
    
    # compute the covariance matrix exactly
    cov_exact = sigma^2 * inv(X' * X)

    # initialize array of mc error estimates
    error_est = zeros(num_mc)

    # for each bootstrap iteration
    Threads.@threads for t=1:num_mc

        # generate Y
        noise = sigma * randn(n)
        Y = X * beta + noise

        # create the covariance estimate
        cov_est = bootstrap_cov_est(Y, X, num_bs)
        
        # calculate the error of covariance estimate
        error_est[t] = norm(cov_est - cov_exact)
    end

    # monte carlo: average the errors
    cov_err = mean(error_est)
    return cov_err
end

function create_data(n,d)

    # create whitened covariates, i.e. (1/n) X' X ≈ I_d
    H = randn(n,d)
    F = eigen((1/n) * H' * H)
    W = F.vectors * diagm(1 ./ sqrt.(F.values)) * F.vectors'
    X = H * W
     
    # create linear parameter
    beta = ones(d)

    return X, beta
end