\version "2.24.3"

\header {
  title = "Casatschok - Katioucha - Katyusha"
  instrument = "Harmonica en C"
  autor = "Mikhaïl Issakovski"
  composer = "Matveï Blanter"
  date = ""
  tagline = ##f
}

%{
%Source: https://www.harptabs.com/song.php?ID=4436
Song: 	-6 -7 7 -6 7 7 -7 -6 -7 5
-7 7 -8 -7 -8 -8 7 -7 -6
|: -6 -10 9 -10 9 -9 -9 8 -8 8 -6
-9 -8 -9 7 -8 -8 7 -7 -6 :|
%}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 2/4
  \tempo 4 = 105
  a4. b8 c4. a8 c c b a b4 e,
  \break
  b'4. c8 d4. b8 d8 d c b a2
  \break
  \bar ".|:"
  e'4 a g ( a8 ) g f f e d e4 a,
  r8 f'4 d8 e4. c8 b8 e, c' b a2 
  \bar ":|."
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
    \relative c' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 105
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

