\version "2.24.3"

\header {
  title = "We wish you a Merry Christmas"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

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
  \time 3/4
  \clef "treble^8"
  \key sol \major
  \partial 4
  re4 | sol sol8 la sol fad | mi4 do mi | la la8 si la sol |
  fad4 re re | si' si8 do si la | sol4 mi re8 re | mi4 la fad |
  sol2 re4 | sol sol sol | fad2 fad4 | sol fad mi | re2 la'4 |
  si la8 la sol sol | re'4 re, re8 re | mi4 la fad | sol2
  \bar "|."
}
\addlyrics {
  We wish you a mer -- ry Christ -- mas,
  we wish you a mer -- ry Christ -- mas,
  we wish you a mer -- ry Christ -- mas and a hap -- py new year.
  Good tid -- ings we bring to you and your kin;
  we wish you a mer -- ry Christ -- mas and a hap -- py new year.
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
      \diatonicHarmonicaTab \relative do''' {
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
    \tempo 4 = 140
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
