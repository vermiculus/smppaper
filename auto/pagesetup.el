(TeX-add-style-hook "pagesetup"
 (lambda ()
    (TeX-run-style-hooks
     "fontspec"
     "microtype"
     "fancyhdr"
     "gitinfo"
     "packages"
     "")))

