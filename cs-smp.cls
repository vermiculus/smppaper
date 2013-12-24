\ProvidesClass{cs-smp}

\LoadClass{article}

\RequirePackage{expl3}
\RequirePackage[log-declarations=false]{xparse}

\ExplSyntaxOn

\RenewDocumentCommand \title { m o } {
  \def\@title{#1}
  \IfValueT { #2 } { \def\@subtitle{#2} }
}

\RenewDocumentCommand \maketitle { } {
  \newpage
  \null
  \vskip 2em
  \begin{center}
    \let \footnote \thanks
    {
      \LARGE \@title
      \cs_if_exist:NT \@subtitle {
        \\[1ex] \large \@subtitle
      }
      \par
    }
    \vskip 1.5em
    {
      \large \lineskip .5em
      \begin{tabular}[t]{c}
        \@author
      \end{tabular}
      \par
    }
    \vskip 1em
    {
      \large \@date
    }
  \end{center}
  \par
  \vskip 1.5em
}
\ExplSyntaxOff

% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "smp.tex"
% End:
