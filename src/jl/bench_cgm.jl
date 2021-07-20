import Base.Iterators: flatten

using BenchmarkTools
using CGAL

const ss = [
    Segment2(Point2(7, 10), Point2( 7, -10)) =>
    Segment2(Point2(0,  5), Point2(15,   5)),
    Segment2(Point2(1,  0), Point2( 3,   0)) =>
    Segment2(Point2(1,  1), Point2( 3,   1)),
]
const cs = [
    Circle2(Point2(0, 0), 1)     => Segment2(Point2(-5, 0), Point2(5, 0)),
    Circle2(Point2(0, 0), 1)     => Segment2(Point2(-5, 1), Point2(5, 1)),
    Circle2(Point2(0, 0), 0.5^2) => Segment2(Point2(-5, 1), Point2(5, 1)),
]
const cc = [
    Circle2(Point2(  0,  0),  1)     => Circle2(Point2( 0,  0), 2^2),
    Circle2(Point2(  0,  0), 10^2)   => Circle2(Point2( 1,  0), 1.5^2),
    Circle2(Point2(100,  0),  1)     => Circle2(Point2(10,  0), 2^2),
    Circle2(Point2(  1, -2),  3^2)   => Circle2(Point2( 1, -2), 3^2),
    Circle2(Point2(  0,  0),  1)     => Circle2(Point2( 0,  2), 1),
    Circle2(Point2(  0,  0),  1.5^2) => Circle2(Point2( 1,  0), 1.5^2),
    Circle2(Point2(  0,  0),  1.5^2) => Circle2(Point2( 1,  0), 1),
    Circle2(Point2(  0,  0),  1.5^2) => Circle2(Point2( 1,  1), 1),
]

const scenarios = flatten([ss, cs, cc])

sample(a, b; times = 1000) = for i ∈ 1:times intersection(a, b) end

@info "========================= STARTING  BENCHMARKS ========================="
for (i, (a, b)) ∈ enumerate(scenarios)
    @info "Scenario $i" a b intersection(a, b)
    display(@benchmark sample($a, $b))
    println("\n")
end
@info "=========================== BENCHMARKS  OVER ==========================="
