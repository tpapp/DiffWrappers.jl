# DiffWrapper

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/tpapp/DiffWrapper.jl.svg?branch=master)](https://travis-ci.org/tpapp/DiffWrapper.jl)
[![Coverage Status](https://coveralls.io/repos/tpapp/DiffWrapper.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/tpapp/DiffWrapper.jl?branch=master)
[![codecov.io](http://codecov.io/github/tpapp/DiffWrapper.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/DiffWrapper.jl?branch=master)

Wrap so that they return `DiffResult`s with the requested derivatives.

Example:
```julia
using DiffWrapper
using DiffBase
f(x) = sum(x.*linspace(0,1,length(x)))
g = ForwardGradientWrapper(f, 4) # will use length 4 vectors
length(g)                        # 4
x = ones(4)
gx = g(x)
DiffBase.value(gx)               # 2.0
DiffBase.gradient(gx)            # [0, 1/3, 2/6, 1]
```

Note: returned `DiffResult`s may **share structure**, eg
```julia
gx2 = g(2*ones(4))
gx === gx2                       # true !
```
Use `copy` to avoid this.
