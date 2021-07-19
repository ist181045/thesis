#include <CGAL/Simple_cartesian.h>
#include <CGAL/Kernel/global_functions.h> // circumcenter

// C struct opaquely wrapping CGAL::Point_3<Kernel>
struct Point { double x, y, z; };

// C function to be invoked in Julia using `ccall`
extern "C"
Point circumcenter(Point p, Point q, Point r) {
  typedef CGAL::Simple_cartesian<double>::Point_3 Point_3;
  Point_3 _p(p.x, p.y, p.z)
        , _q(q.x, q.y, q.z)
        , _r(r.x, r.y, r.z)
        , _s = CGAL::circumcenter(_p, _q, _r);
  return Point{_s.x(), _s.y(), _s.z()};
}
