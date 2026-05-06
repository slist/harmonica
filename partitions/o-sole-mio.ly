\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "O sole mio!"
  composer = "E. di Capua (1865-1917)"
  poet = "G. Capurro (1879–1920)"
  lyricsLang = #'(it)
  copyrightStatus = "public-domain"
  tagline = ##f
  composerNationality = "it"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

\layout {
  \context {
    \Lyrics
    \override LyricText.font-size = #-1
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #20 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #20 % Espace entre les portées
}

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  \key sol \major % Tonalité de Sol majeur (fa♯)
  \time 2/4
  %\tempo 4 = 80
  \tempo "Andantino."
  %\clef "treble^8"
  r8 sol' sol fad | re2 | re8 fad fad mi | do2 | do8 fad fad mi |
  \break
  r2 r r | r8 re do si | la4 sol | 
    \break
  sol8 la si sol | fad4 mi~ | mi8 fad sol la | fad mi mi4~ | mi8 fad sol la |
  
  %sol8 sol sol sol la4 sol8 la | si8 re4. r2 | mi8 mi sol mi re do4. | re2 r2 |
  \break
  %mi8 mi sol mi re do4. | si8 la4 sol2 r8 | la8 si la si la si4.
  \break
  \bar "|."
}
\addlyrics {
  "" "" "" "" "" "" "" "" "" "" "" "" ""
  Che bel -- la co -- sa
  "'na" iur -- na -- ta'e so -- le, n'a -- ria se -- re -- na dop -- po "'na" tem -- pe -- sta!
  

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

%\diatoniqueScore
%\chromatiqueScore
%\midiScore
