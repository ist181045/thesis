module CGAL

using CxxWrap
export Point2, Segment2,
       COLLINEAR, LEFT_TURN, RIGHT_TURN,
       x, y, midpoint, orientation, squared_distance

@wrapmodule "$(@__DIR__)/libcgal_julia" # path to shared library

__init__() = @initcxx # initialize CxxWrap

# `x` and `y` return references, this pretty prints them
Base.show(io::IO, x::CxxWrap.CxxBaseRef{<:Real}) = print(io, x[])

for m ∈ methods(CGAL._tostring) # for pretty printing
    T = m.sig.parameters[2]
    @eval Base.show(io::IO, x::$T) = print(io, _tostring(x))
end

end # CGAL
