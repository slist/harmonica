\version "2.24.3"

\header {
  title = "When the Saints go marching in"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \tempo 4 = 144
  r4 c, e f g1
  \break
  r4 c, e f g1
  \break
  r4 c, e f g2 e c e d1
  \break
  r4 e e d c2. c4 e2 g g4 f2.
  \break
  r4 c e f g2 e c d c1
  \bar "|."
  
  \set Staff.midiInstrument = "harmonica"
}
\addlyrics {
  Oh, when the saints  %  (when the saints)
  Oh, when the saints  %  (when the saints)
  Oh, when the saints  %  (when the saints)
  Go mar -- ching in % (marching in)
  Now, when the saints go mar -- ching in %  (marching in)
  Yes, I want to be in that num -- ber
}


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c''' {
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
      \chromaticHarmonicaTab \relative c''' {
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
    \tempo 4 = 100
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

