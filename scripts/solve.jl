using Revise
using POMDPs
using GridGoalMDPs
using DiscreteValueIteration

m = TwoAgentMDP(size=(25,25))
@show n_states(m)
@show n_actions(m)

solver = SparseValueIterationSolver(verbose=true)

p = solve(solver, m)

@show sizeof(p.qmat)
