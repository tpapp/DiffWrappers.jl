module DiffWrappers

import DiffResults: GradientResult
import ForwardDiff: gradient!, GradientConfig
using Parameters
import Base: length

export ForwardGradientWrapper

######################################################################
# forward
######################################################################

struct ForwardGradientWrapper{Tf, Tc, Tg}
    f::Tf
    config::Tc
    gr::Tg
end

"""
    ForwardGradientWrapper(f, x, [args...])

Create a wrapper for ``f: ℝⁿ→ℝ`` that returns the value `f(z)` and the gradient
`∇f(z)` when called with vector `z`, using `ForwardDiff`. `x` is used only for
ascertaining the size for the buffer, its value is ignored.

Additional arguments are passed to `ForwardDiff.GradientConfig`.

Values returned by the wrapper don't share structure.
"""
function ForwardGradientWrapper(f, x, args...)
    config = GradientConfig(f, x, args...)
    gr = GradientResult(x)
    ForwardGradientWrapper(f, config, gr)
end

"""
    ForwardGradientWrapper(f, n::Int, args...)

Same as `ForwardGradientWrapper(f, x, args...)`, but specify dimension directly with `n`.
"""
ForwardGradientWrapper(f, n::Int, args...) = ForwardGradientWrapper(f, ones(n), args...)

function (fgw::ForwardGradientWrapper)(x)
    @unpack f, config, gr = fgw
    gradient!(gr, f, x, config)
    deepcopy(gr)
end

length(fgw::ForwardGradientWrapper) = length(fgw.gr.derivs[1])

end # module
