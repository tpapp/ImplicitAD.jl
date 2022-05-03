module ImplicitAD

using AbstractDifferentiation, ChainRulesCore, Roots, ArgCheck

export one_one_core, one_one

"Default tolerance."
const ATOL = √eps()

####
#### α ↦ β, defined implicitly by exp(β) + exp(6β) = α
####

one_one_core(α, β) = exp(β) + exp(6*β) - α

function one_one(α)
    @argcheck α > 0
    β0 = log(α/2)
    find_zero(β -> one_one_core(α, β), (β0 / 6, β0); atol = ATOL)
end

function ChainRulesCore.rrule(config::RuleConfig{>:HasReverseMode}, ::typeof(one_one), α)
    β = one_one(α)
    function one_one_pullback(β̄)
        g, ḡ_pullback = rrule_via_ad(config, one_one_core, α, β)
        abs(g) ≥ ATOL && @info "not sure that the implicit solution is OK" g, α, β
        f̄ = NoTangent()
        _, ∂g∂α, ∂g∂β = ḡ_pullback(1)
        ∂β∂α = - ∂g∂β / ∂g∂α
        return f̄, ∂β∂α \ β̄
    end
    β, one_one_pullback
end

end
