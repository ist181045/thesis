module Voronoi

using CxxWrap
export Point2, Segment2, DelaunayTriangulation2, VoronoiDiagram2,
       x, y, point, source, target, segment, edges

@wrapmodule joinpath(@__DIR__, "libvoronoi")
__init__() = @initcxx

@cxxdereference Base.insert!(dt::DelaunayTriangulation2, ps::AbstractArray) =
    insert!(dt, StdVector(ps))

end # Voronoi
