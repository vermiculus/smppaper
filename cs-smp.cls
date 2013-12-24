\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\RequirePackage{expl3}
\ProvidesExplClass
{cs-smp}
{2013/12/23}
{1.0}
{A class for St. Mary's Projects in Computer Science}


\ExplSyntaxOn

% They're going to regret this
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{article}
}

\PassOptionsToClass{letterpaper}{article}

\ProcessOptions\relax
\LoadClassWithOptions{article}

\RequirePackage[margin=1in]{geometry}
\RequirePackage[log-declarations=false]{xparse}


\msg_new:nnnn { cs-smp } { page-length } {
  Your~ paper~ doesn't~ meet~ the~ given~ page~ limits.
}{
  This~ paper~ was~ set~ with~ the~ following~ bounds:
  ~ ~ Minimum:~ #1
  ~ ~ Maximum:~ #2
  Your~ paper~ only~ has~ #3~ pages.
}

\int_zero_new:N \g_cssmp_page_min_int
\int_new:N  \g_cssmp_page_max_int
\int_set:Nn \g_cssmp_page_max_int { 9999 }

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

\NewDocumentCommand \SetPageLengthMinimum { m } {
  \int_gset:Nn \g_cssmp_page_min_int { #1 }
}

\NewDocumentCommand \SetPageLengthMaximum { m } {
  \int_gset:Nn \g_cssmp_page_max_int { #1 }
}

\AtEndDocument{
  \bool_if:nT
  {
    % If we are under the minimum
    \int_compare_p:nNn { \thepage } < { \g_cssmp_page_min_int }
    ||                          % or over the maximum
    \int_compare_p:nNn { \g_cssmp_page_max_int } < { \thepage }
  } {                           % issue a warning
    \msg_warning:nnnnn { cs-smp } { page-length } { \g_cssmp_page_min_int }
                                                  { \g_cssmp_page_max_int }
                                                  { \thepage }
  }
}

\ExplSyntaxOff

% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "smp.tex"
% End:
