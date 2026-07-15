\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Un autre monde"
  subtitle = "Téléphone (1984)"
  composer = "Jean Louis Aubert / Louis Bertignac"
  arranger = "Corine Marienneau / Richard Kolinka"

  lyricsLang = #'(fr)
  copyrightStatus = "copyrighted"
  composerNationality = "FR"
  %instrument = "Harmonica"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  \key fa \major % Tonalité de Fa majeur (sib♯)
  %\key sol \major % Tonalité de Sol majeur (fa♯)
  \time 4/4
  %\tempo "Andantino rubato" 4 = 80
  \tempo "Rock tempo" 4 = 132
  %\clef "treble^8"
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  %r2 r4
  %\partial 4 % anacrouse
  
  %\mark \markup \box "Intro"
  \partial 2
  la8 la4 do8~ | do4. la8 sol4 la | la4. mi8~ mi2 | r1 | r2 la8 la4 do8~ | do4. la8 sol4 la4 |
  \break
  la2 r2 | r1  | r2 la4 la8 do8~ | do4. la8 sol4 la4 | la4. mi8~ mi2 | r1 | r2 la8 la4 do8~ |
  \break
  do4. la8 sol4 la4 | la4. sol8~ sol2 | r1 | r2 r4 r8 fa8 | sol8 sol fa4 la sol | fa r4 r2 |
  \break
  sol8 sol sol fa la4 sol | fa r4 r4 r8 fa8 | sol8 sol fa4 la sol | fa r4 r2 | r4 r8 la8 la sol fa sol~
  \break
  sol2 % ???
  
  \bar "|."
}
\addlyrics {
  Je rê -- vais d'un au -- tre mon -- de où la ter -- re se -- rait ronde
  où la lu -- ne se -- rait blon -- de et la vie se -- rait fé -- con -- de Je dor -- mais à poings fer -- més
  je ne vo -- yais plus en pieds je rê -- vais ré -- a -- li -- té ma ré -- a -- li -- té 
  
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
      %\set Staff.instrumentName = "Harmonica en E"
      \diatonicEHarmonicaTab \relative do'' {
        \melodie
      }
    }
  >>
  \layout {
    %indent = 2.5\cm
  }
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
    \tempo 4 = 130
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
\diatoniqueScore
%\chromatiqueScore
\midiScore
