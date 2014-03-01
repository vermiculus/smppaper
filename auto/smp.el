(TeX-add-style-hook "smp"
 (lambda ()
    (LaTeX-add-bibliographies
     "refs")
    (TeX-add-symbols
     '("inputsection" 1))
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
     "abstract")))

