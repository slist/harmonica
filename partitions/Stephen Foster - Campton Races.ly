\version "2.24.3"

\header {
  title = "Campton Races"
  instrument = "Harmonica en C"
  composer = "Stephen Foster"
  date = "1850-02"
  customDate = \markup { "February 1850" }  % Pour l'affichage personnalisé
  tagline = ##f
}

%Source: https://riffspot.com/music/camptown-races-harmonica/681/
% https://en.wikipedia.org/wiki/Camptown_Races

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 2/4
  % \clef "treble^8" % "treble_8"
  \tempo "Moderately fast" 4 = 110 %entre 110 et 120
  \key c \major
  
  r4 r8
  g8 g g e g a g e r8 e d4. e8 d4
  g8 g g e g a g e r8 
  d4 e8 d c4 r8
  g'8 g g e g16 g a8 g e r8 e8 d4. e8 d4 
  g8 g g e g16 g a a g g e8 r8 
  d4 e8 d c4. r8
  c8. c16 e8 g c4. r8
  a8. a16 c8 a g4.
  e16 f g8 g e16 e g g a8 g e4 d8 e16 f e d8 d16 c4.
  
  \bar "|."
}
\addlyrics {
  The Camp -- town la -- dies sing this song, Doo -- dah! doo -- dah!
  The Camp -- town race -- track's five miles long, Oh! doo -- dah day!
  I come down there with my hat caved in, Doo -- dah! doo -- dah!
  I go back home with a pock -- et full of tin, Oh! doo -- dah day!
  Going to run all night!
  Going to run all day!
  I'll "__" bet my mon -- ey on the bob -- tail nag, Some -- bod -- y bet on the bay.
}

%Some words may need explanation - a bobtail nag is a horse that has had its tail 'docked' (cut short) and a 'bay' is a brown horse with a black mane and tail.
%


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c' {
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

