const lib = joinpath(@__DIR__, "libsqdist") # path to the compiled library

# julia wrapper function around C function
squared_distance(x₁::Real, y₁::Real, z₁::Real,
                 x₂::Real, y₂::Real, z₂::Real) =
    ccall((:squared_distance, lib)    # qualified function name
        ,  Float64                    # return type
        , (Float64, Float64, Float64
         , Float64, Float64, Float64) # parameter types
        ,  x₁, y₁, z₁, x₂, y₂, z₂)    # arguments

# alternative syntax using `@ccall`
squared_distance(x₁::Real, y₁::Real, z₁::Real,
                 x₂::Real, y₂::Real, z₂::Real) =
    @ccall lib.squared_distance(
        x₁::Float64, y₁::Float64, z₁::Float64
      , x₂::Float64, y₂::Float64, z₂::Float64)::Float64

let p = (x=0, y=0, z=0),
    q = (x=3, y=4, z=0)
    @info("Squared distance"
        , p, q
        , squared_distance(p.x, p.y, p.z
                         , q.x, q.y, q.z)) # = 25.0
end
