using Khepri
import CGAL: Point2, Segment2, to_vector

# implementation
parallel(l::Segment2, p::Point2) = Segment2(p, p + to_vector(l))

# conversion
parallel(l, p) = convert(Line, parallel(convert(Segment2, l)
                                      , convert(Point2, p)))

begin
    backend(autocad)
    delete_all_shapes()

    with(current_cs, cs_from_o_phi(u0(), deg2rad(20))) do 
        A, B, C = u0(), x(3), xy(1,1)
        v = .1(B - A) # small offset
        AB = line(A - v, B + v)
        parallel(AB, C - v)
        surface_circle.((A, B, C), 3e-2)
        text("A", add_pol(in_world(A), .3, -π/3), .2)
        text("B", add_pol(in_world(B), .3, -π/3), .2)
        text("C", add_pol(in_world(C), .3, -π/3), .2)
    end
end
