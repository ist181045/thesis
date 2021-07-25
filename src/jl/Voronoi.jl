module Voronoi

using CxxWrap
export Point2, Segment2, DelaunayTriangulation2, VoronoiDiagram2,
       x, y, point, source, target, segment, edges

@wrapmodule joinpath(@__DIR__, "libvoronoi")
__init__() = @initcxx

for T ∈ (:DelaunayTriangulation2, :VoronoiDiagram2)
    @eval begin
        $T(ps::AbstractArray) = $T(StdVector(ps))
        $T(p, ps...) = $T([p, ps...])
    end
end

@cxxdereference Base.insert!(dt::DelaunayTriangulation2, ps::AbstractArray) =
    insert!(dt, StdVector(ps))

end # Voronoi
