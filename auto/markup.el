(TeX-add-style-hook "markup"
 (lambda ()
    (LaTeX-add-environments
     "task")
    (TeX-add-symbols
     "taskautorefname")
    (TeX-run-style-hooks
     "xparse"
     "")))

