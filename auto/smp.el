(TeX-add-style-hook "smp"
 (lambda ()
    (LaTeX-add-bibliographies
     "refs")
    (TeX-run-style-hooks
     "glossaries"
     "xindy"
     "makeidx"
     "hyperref"
     "hidelinks"
     "latex2e"
     "cs-smp10"
     "cs-smp"
     ""
     "glossary"
     "abstract"
     "sections/introduction"
     "sections/mathematical-representation")))

