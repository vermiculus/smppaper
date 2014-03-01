(TeX-add-style-hook "smp"
 (lambda ()
    (LaTeX-add-bibliographies
     "refs")
    (TeX-run-style-hooks
     "menukeys"
     "gitinfo"
     "hyperref"
     "hidelinks"
     "tikz"
     "biblatex"
     "backend=biber"
     "microtype"
     "todo"
     "marginpar"
     "fancyhdr"
     "listings"
     "verbatim"
     "csquotes"
     "markup"
     "smcm-cosc-graphs"
     "smcm-math"
     "amsthm"
     "amssymb"
     "amsmath"
     "latex2e"
     "smcm-cosc-smp10"
     "smcm-cosc-smp"
     ""
     "letterpaper"
     "maxp=30"
     "minp=25"
     "abstract"
     "sections/introduction"
     "sections/mathematical-representation"
     "sections/logical-representation"
     "sections/interface-ssa"
     "sections/interface-test"
     "sections/interface-interop"
     "sections/reflection")))

