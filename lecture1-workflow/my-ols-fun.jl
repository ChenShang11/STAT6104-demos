# my-ols-fun.jl
# Chris Harshaw, January 2026
# Columbia University
# 
# Functions for running OLS

using LinearAlgebra # lets me use inv() and backslash solver \
using Revise # lets me revise in Jupyter

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
    beta_ols = inv(X'*X)*X'*Y
    return beta_ols
end