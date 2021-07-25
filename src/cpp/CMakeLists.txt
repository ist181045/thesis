project(JLCGAL)

cmake_minimum_required(VERSION 3.1)
set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

find_package(CGAL 5.3 CONFIG REQUIRED)

find_package(JlCxx 0.8 REQUIRED)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")

add_library(cgal_julia SHARED cgal_julia.cpp)
add_library(voronoi    SHARED voronoi.cpp)

target_link_libraries(cgal_julia CGAL::CGAL
                                 JlCxx::cxxwrap_julia
                                 JlCxx::cxxwrap_julia_stl)
target_link_libraries(voronoi    CGAL::CGAL
                                 JlCxx::cxxwrap_julia
                                 JlCxx::cxxwrap_julia_stl)

install(TARGETS
  cgal_julia
  voronoi
LIBRARY DESTINATION lib
ARCHIVE DESTINATION lib
RUNTIME DESTINATION bin)
