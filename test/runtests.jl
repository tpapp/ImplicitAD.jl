using ImplicitAD, Test, ChainRulesTestUtils, FiniteDifferences

"test tolerance, didn't think too hard about it"
const ϵ = eps()^0.25

@testset "ℝ → ℝ" begin
    for _ in 1:100
        α = abs(randn()) + eps()
        β = @inferred one_one(α)
        @test one_one_core(α, β) ≈ 0 atol = √eps()
        test_rrule(one_one, α;
                   check_inferred = false,
                   fdm = forward_fdm(5, 1),
                   atol = ϵ, rtol = ϵ)
    end
end

# @inferred rrule(ChainRulesTestUtils.TestConfig(), one_one, 1.0)
