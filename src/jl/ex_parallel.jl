using Khepri
import CGAL: Point2, Segment2, to_vector
include("utils.jl") # helpers

# implementation
parallel(l::Segment2, p::Point2) = Segment2(p, p + to_vector(l))
# conversion
parallel(l, p) = convert(Line, parallel(convert(Segment2, l)
                                      , convert(Point2, p)))

begin
    backend(autocad); delete_all_shapes()

    rotate(20°) do 
        A, B, C = u0(), x(3), xy(1,1)
        v = .1(B - A) # small offset
        AB = line(A - v, B + v)
        parallel(AB, C - v)
        draw_point.((A, B, C))
        @labels A B C
    end
end
