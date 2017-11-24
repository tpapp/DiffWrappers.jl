using DiffWrappers
using Base.Test
import DiffResults
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
