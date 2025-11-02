\version "2.24.3"

\header {
  title = "Western JuJu"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \tempo 4=120
  r2 g'4 c 
  e2 e4 e8 e~ e2 d4 e d8 c~ c2.
  \break
  r2 g4 c e2 c4 e8 g~ g2. c,8 d~ d2 r2 r2
  \break
  g4 f e2 e4 d8 c~ c2 d4 e d8 c~ c2. r2 
  \break
  g4 c e2 c4 e8 d~ d2 e4 d8 c~ c2 r2
  \bar "|."
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c' {
        \melodie
      }
    }
  >>
  \layout { }
}

% ============================
% SCORE CHROMATIQUE
% ============================

chromatiqueScore = 
\score {
  <<
    \new Staff { 
      \chromaticHarmonicaTab \relative c' {
        \melodie
      }
    }
  >>
  \layout { }
}

% ============================
% SCORE MIDI
% ============================

midiScore =
\score {
  \new Staff {
    \set Staff.midiInstrument = #"harmonica"
    \relative c' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 120
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

