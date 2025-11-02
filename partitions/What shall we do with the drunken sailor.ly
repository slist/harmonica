\version "2.24.3"

\header {
  title = "What shall we do with the drunken sailor"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  %\tempo 4 = 120

  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  \key sib \major  % Si♭ (Si♭, Mi♭)
  
  sol4 sol8 sol sol4 sol8 sol sol4 do, mib sol 
  \break
  fa fa8 fa fa4 fa8 fa fa4 sib, re fa
  \break
  sol4 sol8 sol sol4 sol8 sol sol4 la sib do
  \break
  sib sol fa re do2 do 
  \break
  sol' sol4. sol8 sol4 do, mib sol
  \break
  fa2 fa4. fa8 fa4 sib, re fa
  \break
  sol2 sol4. sol8 sol4 la sib do
  \break
  sib sol fa re do2 do
  \bar "|."
}
\addlyrics {
  What shall we do with the drun -- ken sai -- lor,
  what shall we do with the drun -- ken sai -- lor, 
  what shall we do with the drun -- ken sai -- lor ear -- ly in the mor -- ning,
  Hoo -- ray and up she ri -- ses, hoo -- ray and up she ri -- ses, hoo -- ray and up she ri -- ses ear -- ly in the mor -- ning.
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative do''' {
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
      \chromaticHarmonicaTab \relative do''' {
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
    \relative do''' {
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
