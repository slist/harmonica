\version "2.24.0"

\header {
  tagline = ##f
}

\layout {
  #(layout-set-staff-size 20)

  \context { \Score
             \override MetronomeMark.padding = #5
             \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/128)
             \override TextScript.font-size = #2
             \override TextScript.padding = #3 % Was 5, modified by slist
             %\omit "Page_number_engraver" % added by slist
             %\override paper.print-page-number = #
  }
  \context { \Staff
             \override TimeSignature.style = #'numbered
             \override StringNumber.transparent = ##t
             %      \remove "Page_number_engraver" % added by slist
  }
  \context { \TabStaff
             \override TimeSignature.style = #'numbered
             \override Stem.transparent = ##t
             \override Flag.transparent = ##t
             \override Beam.transparent = ##t
  }
  \context { \TabVoice
             \override Tie.stencil = ##f
  }
  \context { \StaffGroup
             \consists "Instrument_name_engraver"
  }
}


%{ test ChatGPT
#(define (my-print-page-number page-number total-pages)
  (markup
    #:column (
      #:center-column (
        (string-append "Page " (number->string page-number) " of " (number->string total-pages))
      )
    )
  )
)

\paper {
  print-page-number = ##t
  oddFooterMarkup = \markup \fill-line {
    \null
    \on-the-fly #header-not-first-page #my-print-page-number
  }
  evenFooterMarkup = \oddFooterMarkup
}
%}

#(define (header-not-first-page layout props arg)
   (if (= (chain-assoc-get 'page:page-number props -1) 1)
       empty-stencil
       (interpret-markup layout props arg)))

\paper {
  system-system-spacing.minimum-distance = #20
  indent = 0\mm
  % Pas d'instrument dans l'en-tête des pages 2 et suivantes (numéro de page seulement)
  oddHeaderMarkup = \markup \fill-line {
    " "
    \on-the-fly #header-not-first-page
    \fromproperty #'page:page-number-string
  }
  evenHeaderMarkup = \markup \fill-line {
    \on-the-fly #header-not-first-page
    \fromproperty #'page:page-number-string
    " "
  }
}



%{ Changed by slist
             \override TextScript.font-size = #-2
}
%}

% Fonction personnalisée pour les titres de sections
sectionTitle =
#(define-music-function (label) (string?)
   #{
     \textMark \markup {
       \column {
         " "
         " "
         \bold #label
         " "
         " "
       }
     }
   #})