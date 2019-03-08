const agentcolors = ["orange", "blue"]

function POMDPModelTools.render(mdp::TwoAgentMDP, step::Union{NamedTuple,Dict};
                                color = xy->goalcolor(mdp, xy)
                               )

    nx, ny = mdp.size
    cells = []
    for x in 1:nx, y in 1:ny
        clr = tocolor(color(Pos(x,y)))
        ctx = cell_ctx((x,y), mdp.size)
        cell = compose(ctx, rectangle(), fill(clr))
        push!(cells, cell)
    end
    grid = compose(context(), linewidth(0.5mm), stroke("gray"), cells...)
    outline = compose(context(), linewidth(1mm), rectangle())

    agents = []
    if haskey(step, :s)
        s = step[:s]
        for i in 1:2
            agent_ctx = cell_ctx(s[i], mdp.size)
            push!(agents, compose(agent_ctx, circle(0.5, 0.5, 0.4), fill(agentcolors[i])))
        end
    end
    
    sz = min(w,h)
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), agents..., grid, outline)
end

function goalcolor(m::TwoAgentMDP, xy::Pos)
    for i in 1:2
        if xy == m.goals[i]
            return agentcolors[i]
        end
    end
end

function cell_ctx(xy, size)
    nx, ny = size
    x, y = xy
    return context((x-1)/nx, (ny-y)/ny, 1/nx, 1/ny)
end

tocolor(x) = x
function tocolor(r::Float64)
    minr = -10.0
    maxr = 10.0
    frac = (r-minr)/(maxr-minr)
    return get(ColorSchemes.redgreensplit, frac)
end
