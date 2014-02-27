\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\RequirePackage{expl3,l3keys2e}
\ProvidesExplClass
{cs-smp}
{2013/12/23}
{1.0}
{A class for St. Mary's Projects in Computer Science}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Key-Value Interface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\keys_define:nn { cs-smp }
  {
    minp .int_set:N = \g_cssmp_page_min_int,
    minp .default:n = 0,
    maxp .int_set:N = \g_cssmp_page_max_int,
    maxp .default:n = 9999,
    default .code:n = \msg_info:nnnn { cs-smp } { unknown-option }
                                                { \l_keys_key_tl }
                                                { #1 }
                      \PassOptionToClass{\l_keys_key_tl}{article}
  }

\ProcessKeysOptions{ cs-smp }

\PassOptionsToClass{letterpaper}{article}
\LoadClassWithOptions{article}

\RequirePackage[log-declarations=false]{xparse}

\RequirePackage[margin=1in]{geometry}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Messages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\msg_new:nnnn { cs-smp } { page-length } {
  Your ~ paper ~ doesn't ~ meet ~ the ~ given ~ page ~ limits.
} {
  This ~ paper ~ was ~ set ~ with ~ the ~ following ~ bounds:
   ~ ~ Minimum: ~ #1
   ~ ~ Maximum: ~ #2
  Your ~ paper ~ only ~ has ~ #3 ~ pages.
}

\msg_new:nnnn { cs-smp } { unknown-option } {
  I ~ don't ~ know ~ the ~ option ~ `#1=#2`.
} {
  I'm ~ passing ~ it ~ along ~ to ~ the ~ document ~ class.
}

\msg_new:nnnn { cs-smp} { invalid-bounds } {
  Invalid ~ page ~ bounds.
} {
  The ~ minimum ~ cannot ~ be ~ greater ~ than ~ the ~ maximum.
   ~ ~ Minimum: ~ #1
   ~ ~ Maximum: ~ #2
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Private Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ensure that min <= max
\cs_new:Nn \cssmp_validate_bounds: {
  \int_compare:nNnT { \g_cssmp_page_min_int } > { \g_cssmp_page_max_int }
    {
      \msg_error:nnnn { cs-smp } { invalid-bounds }
        { \g_cssmp_page_min_int }
        { \g_cssmp_page_max_int }
    }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Redefine Structural Commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% todo make pdf string @title: @subtitle
\RenewDocumentCommand \title { m o } {
  \def\@title{#1}
  \IfValueT { #2 } { \def\@subtitle{#2} }
}
\RenewDocumentCommand \author { m o } {
  \def\@author{#1}
  \IfValueT { #2 } { \def\@advisor{#2} }
}

\RenewDocumentCommand \@maketitle { } {
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
      \cs_if_exist:NT \@advisor {
        \thanks{
          Advised ~ by ~ \@advisor
        }
      }
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

% Check page bounds for min/max
% todo have macros \startpagecount and \stoppagecount
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

\NewDocumentCommand \CSSMPSetup { m } {
  \keys_set:nn { cs-smp } { #1 }
  \cssmp_validate_bounds:
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Miscellaneous Definitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\Dash{\unskip\thinspace\textemdash\thinspace\ignorespaces\allowbreak}
\def\Elide{\unskip\nobreakspace\textup{[\,\dots]}~\ignorespaces\allowbreak}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Parameter Customizations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NewDocumentEnvironment { warning } { } {
  \par
  \textbf{Warning: }
}{
  \par
}

\NewDocumentEnvironment { draftvspace } { m } {
  \begin{center}
    \rule{1pt}{\dimexpr #1 / 2 \relax}
    \par
}{
    \par
    \rule{1pt}{\dimexpr #1 / 2 \relax}
  \end{center}
}

\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{2}

% Local Variables:
% TeX-PDF-mode: t
% TeX-master: "smp.tex"
% End:
