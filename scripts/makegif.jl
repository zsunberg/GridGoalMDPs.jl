using Revise
using POMDPs
using GridGoalMDPs
using DiscreteValueIteration
using POMDPGifs

m = TwoAgentMDP(size=(25,25))
solver = SparseValueIterationSolver(verbose=true)
p = solve(solver, m)

gif = makegif(m, p, max_steps=100, show_progress=true)
fname = gif.filename
@info("Attempting to open $(fname) with google chrome.")
if Sys.iswindows()
    run(`cmd /C start chrome "$fname"`)
elseif Sys.isapple()
    run(`open -a "Google Chrome" $fname`)
else
    run(`google-chrome $fname`)
end
