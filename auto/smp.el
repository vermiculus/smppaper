(TeX-add-style-hook "smp"
 (lambda ()
    (LaTeX-add-bibliographies
     "refs")
    (TeX-run-style-hooks
     "glossaries"
     "xindy"
     "makeidx"
     ""
     "hyperref"
     "hidelinks"
     "latex2e"
     "cs-smp10"
     "cs-smp"
     "maxp=30"
     "minp=25"
     "glossary"
     "abstract"
     "sections/introduction"
     "sections/mathematical-representation"
     "sections/logical-representation"
     "sections/interface-ssa"
     "sections/interface-graph-builder"
     "sections/interface-test")))

