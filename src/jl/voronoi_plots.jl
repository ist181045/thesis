using VoronoiDelaunay
using CGAL

import RandomNumbers.MersenneTwisters: MT19937

randpoints(n=21, lo=nextfloat(1.), hi=prevfloat(2., 2); seed=0xdeadbeef) =
    let rng = MT19937(seed)
        map(1:n) do _
            x = (rand(rng); rand(rng))
            y = (rand(rng); rand(rng))
            lo .+ (hi - lo) .* (x, y)
        end
    end

plotxy(dt::DelaunayTriangulation2) =
    let xs = Float64[], ys = Float64[]
        foreach(segment.(Ref(dt), edges(dt))) do seg
            s, t = source(seg), target(seg)
            push!(xs, x(s)[], x(t)[], NaN)
            push!(ys, y(s)[], y(t)[], NaN)
        end
        xs, ys
    end

plotxy(vd::VoronoiDiagram2) =
    let xs = Float64[], ys = Float64[],
        isbounded(hf) = all(!isnothing, (source(hf), target(hf)))
        for hf ∈ filter(isbounded, edges(vd))
            s, t = point.((source(hf), target(hf)))
            push!(xs, x(s)[], x(t)[], NaN)
            push!(ys, y(s)[], y(t)[], NaN)
        end
        xs, ys
    end

using Plots; pgfplotsx()
let ps  = randpoints(),
    cdt = DelaunayTriangulation2(),
    vdt = DelaunayTessellation()
    insert!(cdt, [Point2(p...) for p ∈ ps])
    push!(vdt,   [Point(p...)  for p ∈ ps])

    plot(plotxy(cdt)
       , lab = "CGAL.jl"
       , lims = (.9, 2.1)
       , titlefontsize = 10
       , tickfontfamily = "monospace"
       , color = :red)
    plot!(getplotxy(delaunayedges(vdt))
        , lab = "VoronoiDelaunay.jl"
        , color = :springgreen
        , seriesalpha = .8
        , extra_kwargs = :subplot, legend_columns = -1)
    title!("Delaunay Triangulation")
    pl1 = current()

    plot(plotxy(VoronoiDiagram2{DelaunayTriangulation2}(cdt))
       , lab = "CGAL.jl"
       , lims = (.9, 2.1)
       , titlefontsize = 10
       , color = :red)
    plot!(getplotxy(voronoiedges(vdt))
        , lab = "VoronoiDelaunay.jl"
        , color = :springgreen
        , seriesalpha = .8
        , extra_kwargs = :subplot, legend_columns = -1)
    title!("Voronoi Diagram")
    pl2 = current()

    plot(pl1, pl2
       , xlabel = raw"$x$"
       , ylabel = raw"$y$"
       , size = (700,350)
       , legend = :topright
       , legendfonthalign = :left)
    savefig(joinpath(dirname(@__DIR__), "tikz", "voronoi-plots.tikz"))
    current()
end
