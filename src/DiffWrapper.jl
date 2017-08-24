module DiffWrapper

import DiffBase
import ForwardDiff
using Parameters

export ForwardGradientWrapper

struct ForwardGradientWrapper{Tf, Tc, Tg}
    f::Tf
    config::Tc
    gr::Tg
end

"""
    ForwardGradientWrapper(f, x, [chunk])

Create a wrapper for ``f: ℝⁿ→ℝ`` that returns the value `f(z)` and the gradient `∇f(z)` when called with vector `z`, using `ForwardDiff`. `x` is used only for ascertaining the size for the buffer, its value is ignored.

**Returned values share structure**, use `copy` when necessary.

`chunk` can be supplied optionally, and is passed to `ForwardDiff.GradientConfig`.
"""
function ForwardGradientWrapper(f, x, chunk::ForwardDiff.Chunk = ForwardDiff.Chunk(x))
    config = ForwardDiff.GradientConfig(f, x, chunk)
    gr = DiffBase.GradientResult(x)
    ForwardGradientWrapper(f, config, gr)
end

"""
    ForwardGradientWrapper(f, n::Int, args...)

Same as `ForwardGradientWrapper(f, x, args...)`, but specify dimension directly with `n`.
"""
ForwardGradientWrapper(f, n::Int, args...) = ForwardGradientWrapper(f, ones(n), args...)

function (fgw::ForwardGradientWrapper)(x)
    @unpack f, config, gr = fgw
    ForwardDiff.gradient!(gr, f, x, config)
    gr
end

Base.length(fgw::ForwardGradientWrapper) = length(fgw.gr.derivs[1])

end # module
