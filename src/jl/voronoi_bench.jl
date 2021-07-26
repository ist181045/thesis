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

using BenchmarkTools
import Statistics: std
printhead(io::IO, s, w = 80; delim = "=") =
    println(io,
            delim^(w÷2 - floor(Int, length(s) / 2) - 1)
          * " $s "
          * delim^(w÷2 - ceil(Int, length(s) / 2) - 1))
printhead(args...; kwargs...) = printhead(stdout, args...; kwargs...)

cd(joinpath(dirname(@__DIR__)), "data")
open("voronoi-cgal.csv", "w") do cio
    open("voronoi-vdjl.csv", "w") do vio
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
