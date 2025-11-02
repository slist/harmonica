\version "2.24.3"

\header {
  title = "Auld Lang Syne - Ce n'est qu'un \"Au Revoir\""
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
  \tempo 4 = 50

  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  %\key sib \major  % Si♭ (Si♭, Mi♭)
  
  do8 fa8. fa16 fa8 la8 sol8. fa16 sol8
  \break
  la16 sol fa8. fa16 la8 do re4.
  \break
  re8 do8. la16 la8 fa8 sol8. fa16 sol8
  \break
  la16 sol fa8. re16 re8 do8 fa4.
  \break
  re'8 do8. la16 la8 fa8 sol8. fa16 sol8
  \break
  re'8 do8. la16 la8 do8 re4.
  \break
  re8 do8. la16 la8 fa8 sol8. fa16 sol8
  \break
  la16 sol fa8. re16 re8 do8 fa4.
  \bar "|."
}
\addlyrics {
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative do'' {
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
      \chromaticHarmonicaTab \relative do'' {
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
    \relative do'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 50
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

\diatoniqueScore
\midiScore