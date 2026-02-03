# max-subsequence-sum.jl
# Chris Harshaw, January 2026
# Columbia University
#
# This is a file that contains code for computing
# the maximum sum over all subsequence

"""
    max_subsequence_sum(a)

Compute the maximum sum over all subsequences

# Arguments
- `a`: `n`-dimensional array 

# Output
- `max_sum`: the maximum sum over subsequences
"""
function max_subsequence_sum(a::Array)

    n = length(a)

    # initialize maximum sum 
    max_sum = 0

    # looping over all subsequences a[i:j]
    for i=1:n 
        for j=i:n

            # evaluate the sum
            sum_val = sum(a[i:j])

            # update if it's the largest we've seen
            if sum_val >= max_sum
                max_sum = sum_val
            end
        end
    end

    return max_sum
end