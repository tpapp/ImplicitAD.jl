using ImplicitAD, Test, ChainRulesTestUtils, FiniteDifferences

"test tolerance, didn't think too hard about it"
const ϵ = eps()^0.25

@testset "ℝ → ℝ" begin
    for _ in 1:100
        α = abs(randn()) + eps()
        β = @inferred one_one(α)
        @test one_one_core(α, β) ≈ 0 atol = √eps()
        test_rrule(one_one, α;
                   # when https://github.com/JuliaDiff/ChainRulesTestUtils.jl/issues/246
                   # is fixed, remove:
                   check_inferred = false,
                   fdm = forward_fdm(5, 1),
                   atol = ϵ, rtol = ϵ)
    end
end

# v, pb = @inferred rrule(ChainRulesTestUtils.TestConfig(), one_one, 1.0)
# @code_warntype pb(1)
# using ChainRulesCore
# g, pbg = @inferred rrule_via_ad(ChainRulesTestUtils.TestConfig(), one_one_core, 1.0, 2.0)
# @code_warntype pbg(1.0)
