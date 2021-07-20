#include <CGAL/Exact_predicates_inexact_constructions_kernel.h> // Epick
#include <CGAL/enum.h> // Orientation, alias of Sign
#include <CGAL/IO/io.h> // set_pretty_mode

#include <jlcxx/jlcxx.hpp>

// helper for generating CGAL global function wrappers
#define WRAPPER(F) \
  template<typename ...TS> \
  inline auto F(const TS&... ts) { return CGAL::F(ts...); }

WRAPPER(midpoint)
WRAPPER(orientation)
WRAPPER(squared_distance)

template<typename T> // used in julia to pretty print types
std::string to_string(const T& t) {
  std::ostringstream oss("");
  CGAL::set_pretty_mode(oss);
  oss << t;
  return oss.str();
}

JLCXX_MODULE define_julia_module(jlcxx::Module& m) {
  typedef CGAL::Epick       Kernel;
  typedef Kernel::Point_2   Point_2;
  typedef Kernel::Segment_2 Segment_2;

  // types
  m.add_type<Point_2>("Point2")
   .constructor<double, double>()
   .method("x", &Point_2::x)
   .method("y", &Point_2::y)
   .method("_tostring", &to_string<Point_2>);

  m.add_type<Segment_2>("Segment2")
   .constructor<const Point_2&, const Point_2&>()
   .method("_tostring", &to_string<Segment_2>);

  m.add_bits<CGAL::Orientation>("Orientation", jlcxx::julia_type("CppEnum"));
  m.set_const("COLLINEAR",  CGAL::COLLINEAR);
  m.set_const("LEFT_TURN",  CGAL::LEFT_TURN);
  m.set_const("RIGHT_TURN", CGAL::RIGHT_TURN);

  // functions
  m.method("midpoint", &midpoint<Point_2,Point_2>);
  m.method("orientation", &orientation<Point_2,Point_2,Point_2>);
  m.method("squared_distance", &squared_distance<Point_2,Point_2>);
  m.method("squared_distance", &squared_distance<Segment_2,Point_2>);
}
