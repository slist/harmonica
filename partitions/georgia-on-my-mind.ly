\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Georgia on My Mind"
  composer = "Hoagy Carmichael (1899-1981) & Stuart Gorrell (1901-1963)"
  %lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "us"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  %\key sol \major % Tonalité de Sol majeur (fa♯)
  \time 6/4
  \tempo "Andantino rubato" 4 = 80
  %\tempo 4 = 80
  %\clef "treble^8"
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  r1 r8 sol8->  mi-> do' | r4 red4.-> mi8 sol2. | r4 re2-> re4 mi r | r la-> r la-. mi-. red |
  \break
  do2. r4 do8-> la4 do8 | r4 re4.-> fa8 sol4 la r | r red,2-> mi4 do8-> la4 do8~-> | do2.\fermata r4 r2
  \bar "|."
}
\addlyrics {
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
    \tempo 4 = 80
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
%\chromatiqueScore
%\midiScore
