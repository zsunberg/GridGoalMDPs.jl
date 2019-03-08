using GridGoalMDPs
using POMDPSimulators
using POMDPPolicies
using POMDPModelTools

m = TwoAgentMDP()
p = FunctionPolicy(s->(Pos(1,0),Pos(1,0)))
for step in stepthrough(m, p, max_steps=10)
    @show step.s
    render(m, step)
end
