using CGAL

p, q = Point2(1,1), Point2(10,10)

println("p = $p")
println("q = $(x(q)) $(y(q))")

println("sqdist(p,q) = $(squared_distance(p,q))")

s = Segment2(p,q)
m = Point2(5, 9)

println("m = $m")
println("sqdist(Segment2(p,q), m) = $(squared_distance(s, m))")

print("p, q, and m ")
let o = orientation(p,q,m)
    if     o == COLLINEAR  println("are collinear")
    elseif o == LEFT_TURN  println("make a left turn")
    elseif o == RIGHT_TURN println("make a right turn")
    end
end

println(" midpoint(p,q) = $(midpoint(p,q))")
