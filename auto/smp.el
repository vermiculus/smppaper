(TeX-add-style-hook "smp"
 (lambda ()
    (LaTeX-add-bibliographies
     "refs")
    (TeX-run-style-hooks
     "markup"
     "pagesetup"
     "packages"
     "latex2e"
     "smcm-cosc-smp10"
     "smcm-cosc-smp"
     ""
     "todo=marginpar"
     "literate"
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

