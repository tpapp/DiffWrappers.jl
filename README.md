# DiffWrappers

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/tpapp/DiffWrappers.jl.svg?branch=master)](https://travis-ci.org/tpapp/DiffWrappers.jl)
[![Coverage Status](https://coveralls.io/repos/tpapp/DiffWrappers.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/tpapp/DiffWrappers.jl?branch=master)
[![codecov.io](http://codecov.io/github/tpapp/DiffWrappers.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/DiffWrappers.jl?branch=master)

Wrap functions so that they return `DiffResult`s with the requested derivatives. Copy values when necessary, so that structure is not shared between evaluations.

## Example:

<!--- pasted from output of test/example.jl -->
```julia
julia> using DiffWrappers

julia> using DiffResults

julia> f(x) = sum(x .* linspace(0, 1, length(x)));

julia> g = ForwardGradientWrapper(f, 4); # will use length 4 vectors

julia> length(g)
4

julia> x = ones(4);

julia> gx = g(x);

julia> DiffResults.value(gx)
2.0

julia> DiffResults.gradient(gx)
4-element Array{Float64,1}:
 0.0     
 0.333333
 0.666667
 1.0     
```
