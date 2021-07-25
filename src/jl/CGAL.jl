module CGAL

using CxxWrap
export Point2, Segment2,
       COLLINEAR, LEFT_TURN, RIGHT_TURN,
       x, y, midpoint, orientation, squared_distance

@wrapmodule joinpath(@__DIR__, "libcgal_julia") # path to shared library
__init__() = @initcxx # initialize CxxWrap

Base.show(io::IO, x::CxxWrap.CxxBaseRef{<:Real}) = print(io, x[])
for m ∈ methods(CGAL._tostring) # for pretty printing
    @eval Base.show(io::IO, x::$(m.sig.parameters[2])) = print(io, _tostring(x))
end

end # CGAL
