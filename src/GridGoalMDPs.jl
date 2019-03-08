module GridGoalMDPs

using POMDPs
using StaticArrays
using Parameters
using POMDPModelTools
using Base.Iterators
using Random
using Compose
import Cairo

export
    TwoAgentMDP,
    Pos

const Pos = SVector{2, Int}

const agent_acts = [Pos(1,0), Pos(-1,0), Pos(0,1), Pos(0,-1)]
const acts = collect(product(agent_acts, agent_acts))
const adict = Dict(a=>i for (i, a) in enumerate(acts))

const S = Tuple{Pos, Pos}
const A = Tuple{Pos, Pos}

@with_kw struct TwoAgentMDP <: MDP{S, A}
    size::Pos = Pos(10, 10)
    goals::NTuple{2, Pos} = (Pos(1,1), size)
    goal_reward::Float64 = 10.0
    step_reward::Float64 = -1.0
    adict::Dict{A, Int} = adict
end

POMDPs.actions(m::TwoAgentMDP) = keys(m.adict)

function POMDPs.states(m::TwoAgentMDP)
    return ((Pos(x1, y1), Pos(x2, y2)) for x1 in 1:m.size[1],
                                           y1 in 1:m.size[2],
                                           x2 in 1:m.size[1],
                                           y2 in 1:m.size[2]
                                          )
end
 
POMDPs.n_actions(m::TwoAgentMDP) = length(m.adict)

POMDPs.n_states(m::TwoAgentMDP) = length(states(m))

POMDPs.stateindex(m::TwoAgentMDP, s) = LinearIndices((m.size[1], m.size[2], m.size[1], m.size[2]))[s[1][1], s[1][2], s[2][1], s[2][2]]

POMDPs.actionindex(m::TwoAgentMDP, a) = m.adict[a]

function moveagent(agentstate, agentact, size, goal)
    if agentstate == goal
        return agentstate
    else
        return clamp.(agentstate + agentact, Pos(1, 1), size)
    end
end

function POMDPs.transition(m::TwoAgentMDP, s, a)
    return Deterministic((moveagent(s[1], a[1], m.size, m.goals[1]),
                          moveagent(s[2], a[2], m.size, m.goals[2])))
end

function POMDPs.isterminal(m::TwoAgentMDP, s)
    return s[1] == m.goals[1] && s[2] == m.goals[2]
end

function POMDPs.reward(m::TwoAgentMDP, s, a, sp)
    r = 0.0
    for i in 1:2
        if s[i] != m.goals[i]
            r += m.step_reward
            r += m.goal_reward * sp[i] == m.goals[i]
        end
    end
    return r
end

function POMDPs.initialstate(m::TwoAgentMDP, rng::Random.AbstractRNG)
    states = Pos[]
    for i in 1:2
        push!(states, Pos(rand(rng, 1:m.size[1]), rand(rng, 1:m.size[2])))
    end
    return tuple(states...)::S
end

POMDPs.discount(m::TwoAgentMDP) = 0.95

include("visualization.jl")

end # module
