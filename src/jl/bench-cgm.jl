import Base.Iterators: flatten

using BenchmarkTools
using CGAL

const ss = [
    # (7, 10)---(7, -10) , (0, 5)---(15, 5)
    Segment2.((Point2.((7, 0), (10, 5)), Point2.((7, 15), (-10, 5)))...),
    # (1,  0)---(3,   0) , (1, 1)---( 3, 1)
    Segment2.((Point2.((1, 1), ( 0, 1)), Point2.((3,  3), (  0, 1)))...),
]
const cs = [
    # x² + y² = 1², (-5, 0)---(5, 0)
    (Circle2(Point2(0, 0), 1    ), Segment2(Point2.((-5, 5), (0, 0))...)),
    # x² + y² = 1², (-5, 1)---(5, 1)
    (Circle2(Point2(0, 0), 1    ), Segment2(Point2.((-5, 5), (1, 1))...)),
    # x² + y² = 0.5², (-5, 1)---(5, 1)
    (Circle2(Point2(0, 0), 0.5^2), Segment2(Point2.((-5, 5), (1, 1))...)),
]
const cc = [
    # x² + y² = 1², x² + y² = 2²
    Circle2.(Point2.((  0,  0), ( 0,  0)), (  1    , 2^2  )),
    # x² + y² = 10², (x - 1)² + y² = 1.5²
    Circle2.(Point2.((  0,  1), ( 0,  0)), (100    , 1.5^2)),
    # (x - 100)² + y² = 1², (x - 10)² + y² = 2²
    Circle2.(Point2.((100, 10), ( 0,  0)), (  1    , 2^2  )),
    # (x - 1)² + (y + 2)² = 3², (x - 1)² + (y + 2)² = 3²
    Circle2.(Point2.((  1,  1), (-2, -2)), (  3^2  , 3^2  )),
    # x² + y² = 1², x² + (y - 2)² = 1²
    Circle2.(Point2.((  0,  0), ( 0,  2)), (  1    , 1    )),
    # x² + y² = 1.5², (x - 1)² + y² = 1.5²
    Circle2.(Point2.((  0,  1), ( 0,  0)), (  1.5^2, 1.5^2)),
    # x² + y² = 1.5², (x - 1)² + y² = 1²
    Circle2.(Point2.((  0,  1), ( 0,  0)), (  1.5^2, 1    )),
    # x² + y² = 1.5², (x - 1)² + (y - 1)² = 1²
    Circle2.(Point2.((  0,  1), ( 0,  1)), (  1.5^2, 1    )),
]

const scenarios = flatten([ss, cs, cc])

sample(a, b; times = 1000) = for i ∈ 1:times intersection(a, b) end

begin
    @info "======================= STARTING BENCHMARKS ======================="
    for (i, (a, b)) ∈ enumerate(scenarios)
        @info "Scenario $i" a b intersection(a, b)
        display(@benchmark sample($a, $b))
    end
end
