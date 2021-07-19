const lib = joinpath(@__DIR__, "libcirc") # path to the compiled library

struct Point # julia equivalent struct
    x::Float64
    y::Float64
    z::Float64
end

# julia wrapper function around C function
circumcenter(p₁::Point, p₂::Point, p₃::Point) =
    ccall((:circumcenter, lib)  # qualified function name
        ,  Point                # return type
        , (Point, Point, Point) # parameter types
        ,  p₁, p₂, p₃)          # argument types
    
# alternative syntax using `@ccall`
circumcenter(p₁::Point, p₂::Point, p₃::Point) =
    @ccall lib.circumcenter(p₁::Point, p₂::Point, p₃::Point)::Point

let p = Point(1,2,3),
    q = Point(1,1,1),
    r = Point(0,1,2)
    @info("Circumcenter"
        , p, q, r
        , circumcenter(p,q,r)) # = Point(1.0, 1.5, 2.0)
end
