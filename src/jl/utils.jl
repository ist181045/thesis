struct AngleDegree end
const ° = AngleDegree()
Base.:*(x::Real, ::AngleDegree) = deg2rad(x)

draw_point(p) = surface_circle(p, 3e-2)

rotate(f, θ) = with(f, current_cs, cs_from_o_phi(u0(), θ))

right_angle(p, q, r; scale=.2) =
    with(current_cs, cs_from_o_vx_vy(q, p - q, r - q)) do
        line(y(scale), xy(scale, scale), x(scale))
    end
right_angle(ps; kws...) = right_angle(ps...; kws...)

macro label(p, v = :(vpol(.3, -π/3)), s = .2)
    esc(:(text($(string(p)), add_xy(in_world($p), cx($v), cy($v)), $s)))
end

macro labels(xs...)
    local ps = filter(x -> !Meta.isexpr(x, :(=)), xs)
    local i = findlast(x -> Meta.isexpr(x, :(=)) && x.args[1] === :pos, xs)
    local λ = isnothing(i) ?
                  x -> esc(:(@label $x)) :
                  x -> esc(:(@label $x $(x.args[2])))
    quote
        $(map(λ, ps)...)
    end
end
