\version "2.24.3"

\header {
  title = "Mon âne"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \clef "treble^8"
  \key sol \major % Tonalité de Sol majeur (fa♯)
  
  \partial 8 % anacrouse
  re8 | sol4. sol8 sol4 r8 sol8 | la8 sol8 fad8 mi8 re4 r8 re8 
  \break
  sol8 sol8 sol8 sol8 sol4 r8 sol8 | la8 sol8 fad mi re4 r8 re'8 |do8 do do do do4 r8 do8 |
  \break
  la8 sol la si sol sol sol si|la8 sol la si sol4 r4
  \bar "|."
}
\addlyrics {
  Mon âne, mon âne, A bien mal à la tête. Ma --
  da -- me lui fait faire, Un bon -- net pour sa fête, Un bon -- net pour sa fête, Et
  des sou -- liers li -- las, la, la, Et des sou -- liers li -- las.
}

accords = \chordmode {
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
    \new ChordNames {
      \accords
    }
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

%diatoniqueScore
%\chromatiqueScore
%\midiScore
