\version "2.24.3"

\header {
  title = "Frère Jacques"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))



% ============================
% MÉLODIE DE LA COMPTINE
% ============================

melodie = {
  \time 4/4
  c4 d e c | c d e c |
  \break
  e f g2 | e4 f g2 |
  \break
  g8. a16 g8 f e4 c | g'8. a16 g8 f e4 c |
  \break
  c g c2 | c4 g c2
  \bar ":|."
}
\addlyrics {
  Frè -- re Jac -- ques, Frè -- re Jac -- ques,
  dor -- mez -- vous, dor -- mez -- "vous ?"
  Son -- nez les ma -- ti -- nes, son -- nez les ma -- ti -- "nes !"
  Ding, daing, "dong !" Ding, daing, "dong !" 
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      %\set Staff.instrumentName = "Harmonica diatonique (Do)"
      %\clef treble
      \diatonicHarmonicaTab \relative c'' {
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
      %\set Staff.instrumentName = "Harmonica chromatique (Do)"
      %\clef treble
      \chromaticHarmonicaTab \relative c'' {
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
    \chromaticHarmonicaTab \relative c'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 90
  }
}

% ============================
% COMPILATION SÉPARÉE
% ============================

% Pour générer la version diatonique :
% lilypond -dcompile-diatonique comptine.ly

% Pour générer la version chromatique :
% lilypond -dcompile-chromatique comptine.ly

% Inclusion conditionnelle des scores

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

