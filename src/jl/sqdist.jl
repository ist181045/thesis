const lib = joinpath(@__DIR__, "libsqdist") # path to the compiled library

squared_distance(x₁::Real, y₂::Real, z₁::Real
               , x₂::Real, y₂::Real, z₂::Real) =
    ccall((:squared_distance, lib)    # qualified function name
        ,  Float64                    # return type
        , (Float64, Float64, Float64
        ,  Float64, Float64, Float64) # parameter types
        ,  x₁, y₁, z₁, x₂, y₂, z₂)    # arguments

let p = (0, 0, 0), q = (3, 4, 0)
    @info "Squared distance" p q squared_distance(p..., q...) # = 25.0
end
