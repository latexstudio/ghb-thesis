% Copyright (c) 2017, Gabriel Hjort Blindell <ghb@kth.se>
%
% This work is licensed under a Creative Commons 4.0 International License (see
% LICENSE file or visit <http://creativecommons.org/licenses/by/4.0/> for a copy
% of the license).
%
% Based on the 'kthesis' class by Lars Engebretsen.

\NeedsTeXFormat{LaTeX2e}[2001/01/01]
\ProvidesClass{kthdiss}%
              [2017/10/10 v0.1 Document class for KTH ICT dissertations]

%=========
% OPTIONS
%=========

% Declare options
\newif\if@kthdiff@electronic \@kthdiff@electronicfalse
\DeclareOption{electronic}{\@kthdiff@electronictrue}
\DeclareOption{g5paper}{\def\kthdiff@trimmedsize{gfive}}
\DeclareOption{a3paper}{\ClassError{kthdiff}{'a3paper' format not supported}}
\DeclareOption{a4paper}{\def\kthdiff@trimmedsize{afour}}
\DeclareOption{a5paper}{\ClassError{kthdiff}{'a5paper' format not supported}}
\DeclareOption{a6paper}{\ClassError{kthdiff}{'a6paper' format not supported}}
\DeclareOption{b3paper}{\ClassError{kthdiff}{'b3paper' format not supported}}
\DeclareOption{b4paper}{\ClassError{kthdiff}{'b4paper' format not supported}}
\DeclareOption{b5paper}{\ClassError{kthdiff}{'b5paper' format not supported}}
\DeclareOption{b6paper}{\ClassError{kthdiff}{'b6paper' format not supported}}
\DeclareOption{letterpaper}{%
  \ClassError{kthdiff}{'letterpaper' format not supported}%
}
\DeclareOption{legalpaper}{%
  \ClassError{kthdiff}{'legalpaper' format not supported}%
}
\DeclareOption{executivepaper}{%
  \ClassError{kthdiff}{'executivepaper' format not supported}%
}
\DeclareOption{ebook}{\ClassError{kthdiff}{'ebook' format not supported}}
\DeclareOption{landscape}{%
  \ClassError{kthdiff}{'landscape' format not supported}%
}
\newif\if@kthdiff@phd \@kthdiff@phdfalse
\newif\if@kthdiff@lic \@kthdiff@licfalse
\DeclareOption{phd}{\@kthdiff@phdtrue}
\DeclareOption{lic}{\@kthdiff@lictrue}

% Pass on undeclared options to memoir class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}

% Default options
\ExecuteOptions{g5paper}

\ProcessOptions\relax

\LoadClass{memoir}

% Set margins
\def\@kthdiff@setpapersize@afour{%
  \setstocksize{297mm}{210mm}
  \settrimmedsize{297mm}{210mm}{*}
  \settypeblocksize{49pc}{33pc}{*}
}
\def\@kthdiff@setpapersize@gfive{%
  \if@kthdiff@electronic
    \setstocksize{239mm}{169mm}
  \else
    % Set stock size to A4 format
    \setstocksize{297mm}{210mm}
  \fi
  \settrimmedsize{239mm}{169mm}{*}
  \if@kthdiff@electronic
  \else
    \setlength{\trimtop}{\stockheight}
    \addtolength{\trimtop}{-\paperheight}
    \setlength{\trimtop}{0.5\trimtop}
    \setlength{\trimedge}{\stockwidth}
    \addtolength{\trimedge}{-\paperwidth}
  \fi
  \settypeblocksize{43pc}{30pc}{*}
}
\@nameuse{@kthdiff@setpapersize@\kthdiff@trimmedsize}
\setlrmargins{*}{*}{*}
\setulmargins{*}{*}{*}
\checkandfixthelayout



%===============
% LOAD PACKAGES
%===============

\RequirePackage{adjustbox}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage[english,swedish,calc]{datetime2}
\RequirePackage{mfirstuc}
\RequirePackage{textcomp}
\RequirePackage{xparse}



%===========================
% DOCUMENT STRUCTURE MACROS
%===========================

\makepagestyle{frontMatterChapPage}
\makeevenhead{frontMatterChapPage}{\thepage}{}{}
\makeoddhead{frontMatterChapPage}{}{}{\thepage}
\newcommand{\@frontMatterChapFont}{%
  \large\bfseries%
}
\NewDocumentEnvironment{frontMatterChap}{m}{%
  \clearpage%
  \markboth{#1}{#1}%
  \thispagestyle{frontMatterChapPage}%
  \begin{center}%
    \@frontMatterChapFont{#1}%
  \end{center}%
}{}

\NewDocumentCommand{\@mkFieldCommand}{m}{%
  \expandafter\NewDocumentCommand\csname #1\endcsname{m}{%
    \expandafter\def\csname @#1\endcsname{##1}%
  }
}
\undef{\@title}
\undef{\@author}
\NewDocumentCommand{\kthLogo}{m}{%
  \def\@kthLogo{%
    \adjustbox{max width=2.2cm, max height=2.2cm}{#1}%
  }%
}
\@mkFieldCommand{subtitle}
\@mkFieldCommand{degreeEng}
\@mkFieldCommand{degreeSwe}
\@mkFieldCommand{tritaYear}
\@mkFieldCommand{tritaNumber}
\@mkFieldCommand{issn}
\@mkFieldCommand{isrn}
\@mkFieldCommand{isbn}
\@mkFieldCommand{monthSubmitted}
\NewDocumentCommand{\defenseDate}{m}{%
  \def\@defenseDate{#1}%
  \DTMsavedate{defensedate}{#1}%
}
\@mkFieldCommand{defenseTime}
\@mkFieldCommand{defenseHallEng}
\@mkFieldCommand{defenseHallSwe}

% Gets a field if set, otherwise prints an error message
\NewDocumentCommand{\@getField}{m}{%
  \expandafter\ifcsdef{@#1}{%
    \csname @#1\endcsname%
  }{%
    \textbackslash #1 NOT SET!%
  }%
}

% Checks if a field is set
\NewDocumentCommand{\@ifHasField}{mmm}{%
  \expandafter\ifcsdef{@#1}{#2}{#3}%
}

% Get field and capitalizes the first letter
\NewDocumentCommand{\@getFieldCap}{m}{%
  \@ifHasField{#1}{%
    \MFUnocap{of}%
    \ecapitalisewords{\csname @#1\endcsname}%
  }{%
    % Print appropriate error message
    \@getField{#1}%
  }%
}
% Convert to lower case
\NewDocumentCommand{\@getFieldLC}{m}{%
  \@ifHasField{#1}{%
    \MakeLowercase{\csname @#1\endcsname}%
  }{%
    % Print appropriate error message
    \@getField{#1}%
  }%
}
% Convert to upper case
\NewDocumentCommand{\@getFieldUC}{m}{%
  \@ifHasField{#1}{%
    \MakeUppercase{\csname @#1\endcsname}%
  }{%
    % Print appropriate error message
    \@getField{#1}%
  }%
}

% Prints the month of submission in the specific language.
\NewDocumentCommand{\@printMonthSubmitted}{m}{%
  \@ifHasField{monthSubmitted}{%
    \protected@edef\@tmonth{%
      \csname DTM#1monthname\endcsname{\@monthSubmitted}%
    }%
    \@tmonth%
  }{%
    % Print appropriate error message
    \@getField{defenseDate}%
  }%
}

% Prints the defense date in English to be used in the copyright page.
\NewDocumentCommand{\@printDefenseDateEng}{}{%
  \@ifHasField{defenseDate}{%
    \DTMcomputedayofweekindex{\@defenseDate}{\dowindex}%
    \protected@edef\@tweekday{\DTMenglishweekdayname{\dowindex}}%
    \protected@edef\@tday{\DTMfetchday{defensedate}}%
    \protected@edef\@tmonthnum{\DTMfetchmonth{defensedate}}%
    \protected@edef\@tmonthalp{\DTMenglishmonthname{\@tmonthnum}}%
    \protected@edef\@tyear{\DTMfetchyear{defensedate}}%
    \@tweekday\ \@tday\ \@tmonthalp\ \@tyear%
  }{%
    % Print appropriate error message
    \@getField{defenseDate}%
  }%
}

% Prints the defense date in Swedish to be used in the copyright page.
\NewDocumentCommand{\@printDefenseDateSwe}{}{%
  \@ifHasField{defenseDate}{%
    \DTMcomputedayofweekindex{\@defenseDate}{\dowindex}%
    \protected@edef\@tweekday{\DTMswedishweekdayname{\dowindex}}%
    \protected@edef\@tday{\DTMfetchday{defensedate}}%
    \protected@edef\@tmonthnum{\DTMfetchmonth{defensedate}}%
    \protected@edef\@tmonthalp{\DTMswedishmonthname{\@tmonthnum}}%
    \protected@edef\@tyear{\DTMfetchyear{defensedate}}%
    \@tweekday{}en den \@tday\ \@tmonthalp\ \@tyear%
  }{%
    % Print appropriate error message
    \@getField{defenseDate}%
  }%
}

% Set degree fields
\if@kthdiff@phd
\else
  \if@kthdiff@lic
  \else
    \ClassError{kthdiss}{Either 'phd' or 'lic' must be provided}
  \fi
\fi

\if@kthdiff@phd
  \degreeEng{doctor of philosophy}
  \degreeSwe{teknologie doktorsexamen}
\fi
\if@kthdiff@lic
  \degreeEng{licentiate of engineering}
  \degreeSwe{teknologie licentiatexamen}
\fi

\newcommand{\@titleFont}{%
  \Huge\bfseries%
}
\newcommand{\@subtitleFont}{%
  \Large%
}
\RenewDocumentCommand{\maketitle}{}{%
  \newpage
  \thispagestyle{empty}
  \begin{center}%
    \mbox{}
    \vfill\vfill
    {\@titleFont\@getField{title}\par}
    \@ifHasField{subtitle}{%
      \vskip .75em
      {\@subtitleFont\@getField{subtitle}}
    }{}
    \vskip 2em
    {\Large\scshape\@getFieldLC{author}\par}
    \vskip 2em
    {%
      \itshape%
      \begin{tabular}{c}
        Submitted in Partial Fulfillment of the Requirements\\
        for the Degree of \@getFieldCap{degreeEng}
      \end{tabular}
    }\par
    \vskip 1em
    \@printMonthSubmitted{english} \@getField{tritaYear}\par
    \vfill\vfill\vfill
    \@getField{kthLogo}\par
    \vskip 2em
    \begin{tabular}{c}
      School of Information and Communication Technology\\
      KTH Royal Institute of Technology\\
      Stockholm, Sweden
    \end{tabular}\par
  \end{center}
}

\NewDocumentCommand{\makecopyright}{}{%
  \newpage
  \thispagestyle{empty}
  \mbox{}
  \vfill
  \begingroup%
  \setlength{\parindent}{0pt}%
  \begin{minipage}{\textwidth}%
    \begin{tabular}[b]{@{}l@{}}
      TRITA-ICT \@getField{tritaYear}:\@getField{tritaNumber}\\
      \@ifHasField{issn}{%
        ISSN: \@getField{issn}\\
      }{}%
      \@ifHasField{isrn}{%
        ISRN: \@getField{isrn}\\
      }{}%
      ISBN: \@getField{isbn}\\
    \end{tabular}%
    \hfill%
    \begin{tabular}[b]{@{}r@{}}
      School of ICT\\
      KTH Royal Institute of Technology\\
      SE-164 40 Kista\\
      SWEDEN
    \end{tabular}%
  \end{minipage}
  \vskip 1em
  Academic dissertation that with permission from KTH is presented for public
  examination for completion of degree of \@getFieldLC{degreeEng} on
  \@printDefenseDateEng\ at \@getField{defenseTime} in
  \@getField{defenseHallEng}, Electrum, KTH, Kistag{\aa}ngen 16, Kista,
  Sweden.\par
  \vskip 1em
  Akademisk avhandling som med tillst{\aa}nd av KTH i Stockholm framl\"agges
  till offentlig granskning f\"or avl\"aggande av \@getFieldLC{degreeSwe}
  p{\aa} \@printDefenseDateSwe\ kl.\ \@getField{defenseTime} i
  \@getField{defenseHallSwe}, KTH, Electrum, Kistag{\aa}ngen 16, Kista.\par
  \vskip 1em
  \textcopyright\hspace{4pt}\@getField{author},
  \@printMonthSubmitted{english} \@getField{tritaYear}\par
  \vskip 1em
  Printed by Universitetsservice US-AB
  \endgroup%
}

\RenewDocumentEnvironment{abstract}{}{%
  \begin{frontMatterChap}{Abstract}%
}{
  \end{frontMatterChap}
}

\NewDocumentEnvironment{sammanfattning}{}{%
  \begin{frontMatterChap}{Sammanfattning}%
}{
  \end{frontMatterChap}
}

\NewDocumentEnvironment{acknowledgements}{}{%
  \begin{frontMatterChap}{Acknowledgements}%
}{
  \end{frontMatterChap}
}

\NewDocumentCommand{\makeListOfCommand}{mmmm}{%
  \DeclareDocumentCommand{#1}{s}{%
    \begingroup%
    \renewcommand{\cleardoublepage}{\clearpage}%
    \chapter*{#2}%
    \markboth{#2}{#2}%
    \endgroup%
    \@mkboth{#2}{#2}%
    \IfBooleanF{##1}{%
      \addcontentsline{toc}{#4}{#2}%
    }%
    \@starttoc{#3}%
  }%
}

\makeListOfCommand{\tableofcontents}{\contentsname}{toc}{chapter}
\makeListOfCommand{\listoffigures}{\listfigurename}{lof}{chapter}
\makeListOfCommand{\listoftables}{\listtablename}{lot}{chapter}