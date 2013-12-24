(TeX-add-style-hook "smp"
 (lambda ()
    (LaTeX-add-bibliographies
     "refs")
    (TeX-run-style-hooks
     "mwe"
     "hyperref"
     "biblatex"
     "autocite=footnote"
     "latex2e"
     "cs-smp10"
     "cs-smp"
     ""
     "abstract"
     "sections/introduction")))

