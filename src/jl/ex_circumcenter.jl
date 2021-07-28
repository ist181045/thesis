using Khepri
import CGAL: Point2, circumcenter
include("utils.jl") # helpers

# conversion
circumcenter(p, q, r) =
    convert(Loc, circumcenter(convert.(Point2, (p, q, r))...))

begin
    backend(autocad); delete_all_shapes()

    A, B, C = u0(), xy(1, 3), x(4)
    O  = circumcenter(A, B, C)
    AB = intermediate_loc(A, B)
    AC = intermediate_loc(A, C)
    BC = intermediate_loc(B, C)
    line.((AB, AC, BC), O)
    foreach(right_angle, ((A,AB,O), (B,BC,O), (C,AC,O)))
    polygon(A, B, C)
    circle(O, distance(O, A))
    line(O, A)
    draw_point.((A, B, C, O))
    r = intermediate_loc(O, A)
    @label r vy(.1)
    @label A .2vxy(-1, -1)
    @label B .1vxy(-2,  1)
    @label C .1vxy( 1, -2)
    @label O .1vxy( 1, -2)
end
