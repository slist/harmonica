\version "2.24.0"

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
    \on-the-fly #print-page-number-check-first-page #my-print-page-number
  }
  evenFooterMarkup = \oddFooterMarkup
}
%}

\paper {
  system-system-spacing.minimum-distance = #20
  indent = 0\mm
}



%{ Changed by slist
             \override TextScript.font-size = #-2
}
%}
