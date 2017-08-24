using DiffWrappers
using Base.Test

struct QuadForm{TΣ}
    Σ::TΣ
end

(q::QuadForm)(x) = x' * q.Σ * x

@testset "quadratic form gradient" begin
    for _ in 1:100
        N = rand(3:10)
        A = randn(N, N)
        q = QuadForm(Symmetric(A+A'))
        x = randn(N)
        qq = ForwardGradientWrapper(q, x)
        qqx = qq(x)
        @test q(x) == DiffBase.value(qqx)
        @test ForwardDiff.gradient(q, x) == DiffBase.gradient(qqx)
        @test length(qq) == N
    end
end
