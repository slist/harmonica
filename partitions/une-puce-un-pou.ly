\version "2.24.3"

\header {
  title = "Une puce, un pou"
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
  %\clef "treble^8"
  %\key sol \major % Tonalité de Sol majeur (fa♯)
  
  %\partial 8 % anacrouse
    
  sol4 re si' sol | la8 la re, re si' si sol4 sol re si' sol |
  \break
  la8 la re, re sol4 r4 | sol8 sol sol si re,4 re | sol8 sol sol si re re re4 |
  \break
  sol,8 sol sol si re,4 re | si'8 si la la sol4 r4 | sol8 sol sol si re,4 re |
  \break
  sol8 sol sol si re re re4 | sol,8 sol sol si re,4 re | si'8 si la la sol4 r4 |
  \bar "|."
}
\addlyrics {
Une puce, un pou, as -- sis sur un ta -- bou -- ret, Jou -- aient aux cartes,
La pu -- ce per -- dait, La puce en co -- lè -- re, At -- tra -- pa le pou, pou, pou,
Le je -- ta par ter -- re, Lui tor -- dit le cou. Ma -- da -- me la pu -- ce,
Qu'a -- vez -- vous fait là, là, là? J'ai com -- mis un cri -- me, Un as -- sas -- si -- nat.
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

\markup {
  \vspace #2
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions

%diatoniqueScore
\chromatiqueScore
\midiScore
