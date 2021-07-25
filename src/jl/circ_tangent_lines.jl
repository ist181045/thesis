# implementation
@cxxdereference tangent_lines(p::Point2, c::Circle2) =
    let o  = center(c), 
        r² = squared_radius(c),
        dₚ² = squared_distance(p, o)

        if p == o || dₚ² ≤ r²
            []
        elseif r² == 0
            [Segment2(o, p)]
        else
            ps = intersection(c, Circle2(midpoint(p, o), dₚ² / 4))
            y(o) ≤ y(p) && reverse!(ps)
            Segment2.(ps, Ref(p))
        end
    end

@cxxdereference function tangent_lines(c₁::Circle2, c₂::Circle2)
    r₁², r₂² = squared_radius.((c₁, c₂))

    if r₂² > r₁² # swap arguments
        ss = tangent_lines(c₂, c₁)
        isempty(ss) && return ss
        ss[1], ss[end] = ss[end], ss[1]
        return opposite.(ss)
    end

    o₁, r₁  = center(c₁), √r₁²
    o₂, r₂  = center(c₂), √r₂²

    # Auxiliary
    translation(v) = AffTransformation2(TRANSLATION, v)
    translate(s, v) = transform(s, translation(v))
    vec(s, r) = (source(s) - o₁) * r₂ / r

    # External Tangents
    rₑ = r₁ - r₂
    ssₑ = map(tangent_lines(o₂, Circle2(o₁, rₑ^2))) do s
        iszero(rₑ) && return s
        translate(s, vec(s, rₑ))
    end

    isempty(ssₑ) && return ssₑ # no external tangents ⟹ no tangents
    if length(ssₑ) == 1 # r₁ == r₂
        s   = first(ssₑ)
        vₛ  = vector(direction(s))
        lₛ² = squared_length(s)
        vᵧ  = √(r₂² / lₛ²) * perpendicular(vₛ, orientation(c₁))
        ssₑ  = translate.(Ref(s), (vᵧ, -vᵧ))
    end

    # Internal Tangents
    rᵢ = r₁ + r₂
    ssᵢ = map(s -> translate(s, -vec(s, rᵢ)),
              tangent_lines(o₂, Circle2(o₁, rᵢ^2)))

    # Result
    [ssₑ[1], ssᵢ..., ssₑ[end]]
end

# conversion
tangent_lines(p::Loc, c) =
    let ss = tangent_lines(convert(Point2, p), convert(Circle2, c))
        convert.(Path, ss)
    end
tangent_lines(c1, c2) =
    let ss = tangent_lines(convert(Circle2, c1), convert(Circle2, c2))
        convert.(Path, ss)
    end
