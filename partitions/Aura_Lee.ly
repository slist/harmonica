\version "2.24.3"

\header {
  title = "Aura Lee"
  instrument = "Harmonica en C"
  composer = "George R. Poulton"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \key g \major % Tonalité de Sol majeur (fa♯)
  \time 4/4
  %\tempo "Andante"
  
  d4 g fis g |
  a e a2 |
  g4 fis e fis |
  g2. r4 |
  
  d4 g fis g |
  a e a2 |
  g4 fis e fis |
  g2. r4 |
  
  b4 b b2 |
  b4 b b2 |
  
  b4 a g a | b2. r4 |
  b4 b c b | a e a4. g8 |
  g4 fis b a | g2. r4

  \bar "|."
}

\addlyrics {
  As the black -- bird in the spring, 'neath the wil -- low tree,
  sat and piped, I heard him sing, prais -- ing Au -- ra Lee.
  Au -- ra Lee!
  Au -- ra Lee!
  Maid of gold -- en hair,
  sun -- shine came a -- long with thee and swal -- lows in the air.
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
    \tempo 4 = 120
  }
}

% ============================
% COMPILATION SÉPARÉE
% ============================

% Pour générer la version diatonique :
% lilypond -dcompile-diatonique <fichier.ly>

% Pour générer la version chromatique :
% lilypond -dcompile-chromatique <fichier.ly>

% Pour générer le fichier midi :
% lilypond --formats=midi -dcompile-midi <fichier.ly>

% Inclusion conditionnelle des scores

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

