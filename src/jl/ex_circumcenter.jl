using Khepri
import CGAL: Point2, circumcenter

# conversion
circumcenter(p, q, r) =
    convert(Loc
          , circumcenter(convert.(Point2, (p, q, r))...))

right_angle(p, q, r; scale=.2) =
    with(current_cs, cs_from_o_vx_vy(q, p - q, r - q)) do
        line(y(scale), xy(scale, scale), x(scale))
    end

begin
    backend(autocad)
    delete_all_shapes()

    A, B, C = u0(), xy(1, 3), x(4)
    O  = circumcenter(A, B, C)
    AB = intermediate_loc(A, B)
    AC = intermediate_loc(A, C)
    BC = intermediate_loc(B, C)
    line.((AB, AC, BC), O)
    foreach(t -> right_angle(t...)
         , ((A,AB,O), (B,BC,O), (C,AC,O)))
    polygon(A, B, C)
    circle(O, distance(O, A))
    line(O, A)
    surface_circle.((A, B, C, O), 3e-2)
    text("r", intermediate_loc(O, A) + vy(.1), .2)
    text("A", A + .2vxy(-1, -1), .2)
    text("B", B + .1vxy(-2,  1), .2)
    text("C", C + .1vxy( 1, -2), .2)
    text("O", O + .1vxy( 1, -2), .2)
end
