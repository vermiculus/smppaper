(TeX-add-style-hook "cs-smp"
 (lambda ()
    (TeX-add-symbols
     "Dash"
     "Elide")
    (TeX-run-style-hooks
     "geometry"
     "margin=1in"
     "xparse"
     "log-declarations=false"
     "art10"
     "article"
     "l3keys2e"
     "expl3"
     "")))

