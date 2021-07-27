#!/bin/julia
import BenchmarkTools: prettytime

cd(@__DIR__)

const cgm_maxima = parse.(Int, reshape([split.(readlines("cgm-maxima.csv"), ",")[2:end]...;], 3, :))
const cgm_gfl    = parse.(Int, reshape([split.(readlines("cgm-gfl.csv"),    ",")[2:end]...;], 3, :))
const jlcgal     = parse.(Int, reshape([split.(readlines("jlcgal.csv"),     ",")[2:end]...;], 3, :))

const lmax_cgmm = maximum(length.(prettytime.(cgm_maxima[2,:])))
const rmax_cgmm = maximum(length.(prettytime.(cgm_maxima[3,:])))
const lmax_cgmg = maximum(length.(prettytime.(cgm_gfl[2,:])))
const rmax_cgmg = maximum(length.(prettytime.(cgm_gfl[3,:])))
const lmax_jlcg = maximum(length.(prettytime.(jlcgal[2,:])))
const rmax_jlcg = maximum(length.(prettytime.(jlcgal[3,:])))

const maxlen = ndigits(maximum(cgm_maxima[1,:]))

prettify(m, s, lmax, rmax) =
    let (pm, ps) = prettytime.((m, s))
        string(lpad(pm, lmax), " ± ", lpad(ps, rmax))
    end

const out = IOBuffer()
print(out, raw"""
    \begin{tabular*}{\linewidth}{r*{3}{l}l}
      \toprule
      \multirow{2}{*}{\textbf{Scenario}}
      & \multicolumn{3}{c}{\textbf{Execution time ($\mathrm{mean}\pm\sigma$)}}
      & \multirow{2}{*}{\textbf{GC problem}} \\
      & \multicolumn{1}{c}{\textbf{Maxima}}
      & \multicolumn{1}{c}{\textbf{GFL}}
      & \multicolumn{1}{c}{\textbf{Our solution}} & \\
      \midrule
    """)
for i in cgm_maxima[1,:]
    pcgmm = prettify(cgm_maxima[2,i], cgm_maxima[3,i], lmax_cgmm, rmax_cgmm)
    pcgmg = prettify(cgm_gfl[2,i], cgm_gfl[3,i], lmax_cgmg, rmax_cgmg)
    pjlcg = prettify(jlcgal[2,i], jlcgal[3,i], lmax_jlcg, rmax_jlcg)
    print(out, """
      $(lpad(i, maxlen)) & \\verb|$(pcgmm)|
      $(" " ^ maxlen) & \\verb|$(pcgmg)|
      $(" " ^ maxlen) & \\verb|$(pjlcg)| & \\\\
    """)
end
print(out, raw"""
      \bottomrule
    \end{tabular*}
    """)

print(stdout, String(take!(out)))
