#!/bin/julia
import BenchmarkTools: prettytime

cd(@__DIR__)

const vdcgal = parse.(Float64, reshape([split.(readlines("voronoi-cgal.csv"), ",")...;], 3, :))
const vdjl   = parse.(Float64, reshape([split.(readlines("voronoi-vdjl.csv"), ",")...;], 3, :))

const lmax_vdcgal = maximum(length.(prettytime.(vdcgal[2,:])))
const rmax_vdcgal = maximum(length.(prettytime.(vdcgal[3,:])))
const lmax_vdjl = maximum(length.(prettytime.(vdjl[2,:])))
const rmax_vdjl = maximum(length.(prettytime.(vdjl[3,:])))

prettify(m, s, lmax, rmax) =
    string(lpad(prettytime(m), lmax), " ± ", lpad(prettytime(s), rmax))

const out = IOBuffer()
print(out, raw"""
    \begin{tabular}{r*{2}{l}}
      \toprule
      \multirow{2}{*}{\textbf{\# Points}}
      & \multicolumn{2}{c}{\textbf{Execution time (mean ± σ)}} \\
      & \multicolumn{1}{c}{\texttt{CGAL.jl}}
      & \multicolumn{1}{c}{\texttt{VoronoiDelaunay.jl}} \\
      \midrule
    """)
for i in 1:length(vdcgal[1,:])
    pvdcgal = prettify(vdcgal[2,i], vdcgal[3,i], lmax_vdcgal, rmax_vdcgal)
    pvdjl = prettify(vdjl[2,i], vdjl[3,i], lmax_vdjl, rmax_vdjl)
    print(out, """
      10\\textsuperscript{$(Int(log10(vdcgal[1,i])))} & \\verb|$(pvdcgal)|
                            & \\verb|$(pvdjl)| \\\\
    """)
end
print(out, raw"""
      \bottomrule
    \end{tabular}
    """)

print(stdout, String(take!(out)))
