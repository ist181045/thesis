#include <CGAL/Simple_cartesian.h>
#include <CGAL/squared_distance_3.h> // squared_distance

extern "C" // C function to be invoked in Julia using `ccall`
double squared_distance(double x1, double y1, double z1,
                        double x2, double y2, double z2) {
  typedef CGAL::Simple_cartesian<double>::Point_3 Point_3; 
  Point_3 p(x1, y1, z1), q(x2, y2, z2);
  return CGAL::squared_distance(p, q);
}
