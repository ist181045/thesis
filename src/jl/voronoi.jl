using VoronoiDelaunay
include("Voronoi.jl"); using .Voronoi

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

using Plots
let ps = randpoints(),
    cdt = DelaunayTriangulation2([Point2(p...) for p ∈ ps]),
    vdt = DelaunayTessellation()
    push!(vdt, [Point(p...) for p ∈ ps])

    plot(plotxy(cdt), lims=(1,2), lab = "CGAL", color = :red)
    dp = plot!(getplotxy(delaunayedges(vdt))
             , lab = "VoronoiDelaunay", color = :aqua)
    plot(plotxy(VoronoiDiagram2(cdt)), lims=(0,3), lab = "CGAL", color = :red)
    vp = plot!(getplotxy(voronoiedges(vdt))
             , lab = "VoronoiDelaunay", color = :aqua)
    plot(dp, vp)
end

using BenchmarkTools
import Statistics: std
printhead(io::IO, s, w = 80; delim = "=") =
    println(io,
            delim^(w÷2 - floor(Int, length(s) / 2) - 1)
          * " $s "
          * delim^(w÷2 - ceil(Int, length(s) / 2) - 1))
printhead(args...; kwargs...) = printhead(stdout, args...; kwargs...)
open(joinpath(@__DIR__, "voronoi-cgal.csv"), "w") do cio
    open(joinpath(@__DIR__, "voronoi-vdjl.csv"), "w") do vio
        for n ∈ Int.(exp10.(2:6))
            ps = randpoints(n)
            ct = @benchmark insert!(DelaunayTriangulation2()
                                  , $([Point2(p...) for p ∈ ps]))
            vt = @benchmark push!(DelaunayTessellation()
                                , $([Point(p...) for p ∈ ps]))
            printhead("$n points")
            printhead("CGAL.jl", delim="~")
            display(ct)
            println()
            printhead("VoronoiDelaunay.jl", delim="~")
            display(vt)
            println("\n")
            println(cio, "$n,$(time(mean(ct))),$(time(std(ct)))")
            println(vio, "$n,$(time(mean(vt))),$(time(std(vt)))")
        end
    end
end
