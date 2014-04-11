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
     "literate"
     "maxp=35"
     "minp=25"
     "abstract"
     "sections/introduction"
     "sections/mathematical-representation"
     "sections/logical-representation"
     "sections/interface-test"
     "sections/interface-ssa"
     "sections/further-work"
     "sections/reflection"
     "appendices/bundle-format"
     "appendices/gui-organization")))

