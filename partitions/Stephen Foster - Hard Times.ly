\version "2.24.3"

\header {
  title = "Hard Times"
  composer = "Stephen Foster (1826-1864)"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  tagline = ##f
}

%From https://www.wedesoft.de/software/2021/12/19/lilypond-bluesharp-tabs/


\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  r2 c'4 d
  e2 e4 d
  e8 g4.~ g4 e
  d4 c c d8 c
  e2 c'4 a
  g2 e8 c4.
  d4. c8 e4 d
  c1~
  c2 c4 d
  e2 e4 d
  e8 g4.~ g4 e
  d4 c c d8 c
  e2 c'4 a
  g2 e8 c4.
  d4. c8 e4 d
  c1~
  c2 e4 f4
  g2. g4
  g2 f4 g4
  a1
  g2 r2
  c2 a8 g4.
  e2 d8 c4.
  d4. c8 d4 e
  d2 c4 d
  e2 e4 d
  e8 g4.~ g4 e
  d4 c c d8 c
  e2 c'4 a
  g2 e8 c4.
  d4. c8 e4 d
  c1~
  c4 r4 r2
  \bar "|."
}


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
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
    \relative c'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 90
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

