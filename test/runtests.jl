using DiffWrappers
using Base.Test

using ContinuousTransformations
import DiffResults
import ForwardDiff
using StaticArrays

struct QuadForm{TΣ}
    Σ::TΣ
end

(q::QuadForm)(x) = x' * q.Σ * x

@testset "quadratic form gradient" begin
    for _ in 1:100
        N = rand(3:10)
        static = rand() < 0.5
        A = randn(N, N)
        q = QuadForm(Symmetric(static ? SMatrix{N, N}(A + A') : (A + A')))
        x = static ? SVector{N}(randn(N)) : randn(N)
        qq = ForwardGradientWrapper(q, x)
        qqx = qq(x)
        qq(randn(N))           # another call to test that structure is unshared
        @inferred qq(x)
        @test q(x) == DiffResults.value(qqx)
        @test ForwardDiff.gradient(q, x) == DiffResults.gradient(qqx)
        @test length(qq) == N
    end
end

@testset "TransformLogLikelihood constructor" begin
    ℓ(x) = x[1] + log(x[2])
    t = TransformationTuple((IDENTITY, bridge(ℝ, ℝ⁺)))
    ℓt = TransformLogLikelihood(ℓ, t)
    q = ForwardGradientWrapper(ℓt)
    x = randn(2)
    qx = q(x)
    @test DiffResults.value(qx) == ℓt(x)
    @test DiffResults.gradient(qx) == ForwardDiff.gradient(ℓt, x)
end
