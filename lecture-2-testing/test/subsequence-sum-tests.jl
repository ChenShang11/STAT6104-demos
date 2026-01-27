# subsequence-sum-tests.jl
# Chris Harshaw, January 2026
# Columbia University
#
# Unit tests for max-subsequence-sum.jl

using Test

# this will hide stacktraces
# see https://discourse.julialang.org/t/suppress-stacktrace-when-a-test-fails/19834/7
Test.eval(quote
    function record(ts::DefaultTestSet, t::Union{Fail, Error})
        push!(ts.results, t)
    end
end)

# load the file containing the functions we want to test
include("../src/max-subsequence-sum.jl")

@test max_subsequence_sum([1,2,3,4]) == 10

@test max_subsequence_sum([1,2,-2,-3]) == 1

# TODO
# 0. so what's up?
# 1. How would we see better output in our tests?
# 2. Generalize our first test via a @testset loop 
# 3. Have we considered relevant corner cases?
# 4. What if we speed up our code?