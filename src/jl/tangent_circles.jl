intersection(c::Circle2, r::Ray2) =
    let res = intersection(c, supporting_line(r))
        isnothing(res) && return res
        isa(res, Vector) ? let res2 = filter(p->collinear_has_on(r, p), res)
            isempty(res2) ? nothing :
            length(res2) == 1 ? res2[1] :
            res
        end : res
    end

tangent_circle(c₁::Circle2, c₂::Circle2, v::Vector2; inclusive=true) =
    let r₁² = squared_radius(c₁),
        r₂² = squared_radius(c₂),
        r   = Ray2(center(c₁), v),
        l   = supporting_line(r),
        p   = intersection(c₁, r),
        r′  = Ray2(p, inclusive ? -v : v),
        f   = intersection(Circle2(p, r₂²), r′),
        b   = bisector(center(c₂), f)

        @assert !parallel(b, l) "infinite circle (tangent line)"

        o = intersection(b, l)
        Circle2(o, squared_distance(o, p))
    end
