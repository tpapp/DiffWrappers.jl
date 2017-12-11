__precompile__()
module DiffWrappers

using DiffResults: GradientResult, DiffResult, ImmutableDiffResult
using DocStringExtensions: SIGNATURES
using ForwardDiff: gradient!, GradientConfig
using Parameters: @unpack
import Base: length

export ForwardGradientWrapper


# forward

struct ForwardGradientWrapper{Tf, Tc, Tg}
    f::Tf
    config::Tc
    gr::Tg
end

"""
    $SIGNATURES

Create a wrapper for ``f: ℝⁿ→ℝ`` that returns the value `f(z)` and the gradient
``∇f(z)`` when called with vector `z`, using `ForwardDiff`. `x` is used only for
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
    $SIGNATURES

Helper function to copy shared structure if necessary.
"""
_ensure_unshared(gr::ImmutableDiffResult) = gr

# FIXME: revisit once https://github.com/JuliaDiff/DiffResults.jl/issues/4
# is fixed
_ensure_unshared(gr::DiffResult) = deepcopy(gr)

function (fgw::ForwardGradientWrapper)(x)
    @unpack f, config, gr = fgw
    _ensure_unshared(gradient!(gr, f, x, config))
end

length(fgw::ForwardGradientWrapper) = length(fgw.gr.derivs[1])

end # module
