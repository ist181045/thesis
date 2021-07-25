#include <sstream>
#include <vector>

#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Delaunay_triangulation_2.h>
#include <CGAL/Delaunay_triangulation_adaptation_traits_2.h>
#include <CGAL/Delaunay_triangulation_adaptation_policies_2.h>
#include <CGAL/Voronoi_diagram_2.h>
#include <CGAL/IO/io.h>

#include <jlcxx/jlcxx.hpp>
#include <jlcxx/stl.hpp>

using Kernel = CGAL::Epick;

using DT = CGAL::Delaunay_triangulation_2<Kernel>;
using AT = CGAL::Delaunay_triangulation_adaptation_traits_2<DT>;
using AP = CGAL::Delaunay_triangulation_caching_degeneracy_removal_policy_2<DT>;
using VD = CGAL::Voronoi_diagram_2<DT, AT, AP>;

using Point_2   = VD::Point_2;
using Segment_2 = DT::Segment;

JLCXX_MODULE define_julia_module(jlcxx::Module &m) {
  m.add_type<Point_2>("Point2")
   .constructor<double, double>()
   .method("x", &Point_2::x)
   .method("y", &Point_2::y);
  jlcxx::stl::apply_stl<Point_2>(m);

  m.add_type<Segment_2>("Segment2")
   .method("source", &Segment_2::source)
   .method("target", &Segment_2::target);

  // Delaunay Triangulation
  std::string t_name = "DelaunayTriangulation2";
  m.add_type<DT::Vertex>(t_name + "Vertex")
   .method("point", [](const DT::Vertex& v){ return v.point(); });

  m.add_type<DT::Edge>(t_name + "Edge");

  auto dt = m.add_type<DT>(t_name)
   .method(t_name, [](std::vector<Point_2> ps) {
     return jlcxx::create<DT>(ps.cbegin(), ps.cend());
   })
   .method("edges", [](const DT& dt) {
     std::vector<DT::Edge> res(dt.edges_begin(), dt.edges_end());
     return res;
   })
   .method("segment", [](const DT& dt, const DT::Edge& e) {
     return dt.segment(e);
   });
  m.set_override_module(jl_base_module);
  dt.method("insert!", [](DT& dt, std::vector<Point_2> ps) -> DT& {
    dt.insert(ps.begin(), ps.end());
    return dt;
  });
  m.unset_override_module();

  // Voronoi diagram
   std::string vd_name = "VoronoiDiagram2";
   m.add_type<VD::Vertex>(vd_name + "Vertex")
    .method("point", &VD::Vertex::point);

   m.add_type<VD::Halfedge>(vd_name + "Halfedge")
    .method("source", [](const VD::Halfedge& h) {
      return h.has_source()
        ? (jl_value_t*)jlcxx::box<VD::Vertex>(*(h.source()))
        : jl_nothing;
    })
    .method("target", [](const VD::Halfedge& h) {
      return h.has_target()
        ? (jl_value_t*)jlcxx::box<VD::Vertex>(*(h.target()))
        : jl_nothing;
    });

   m.add_type<VD>(vd_name)
    .constructor<const DT&>()
    .method(vd_name, [](std::vector<VD::Site_2> ps) {
      return jlcxx::create<VD>(ps.cbegin(), ps.cend());
    })
    .method("edges", [](const VD& vd) {
      std::vector<VD::Halfedge> res(vd.edges_begin(), vd.edges_end());
      return res;
    });
}
