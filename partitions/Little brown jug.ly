\version "2.24.3"

\header {
  title = "Little brown jug"
  composer = "Glenn Miller Orchestra (1940)"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 100
  \clef "treble^8"
  \key la \major
  \partial 4
  mi4 | dod mi mi mi | re fad fad2 | sold8 sold sold sold fad4 sold |
  \break
  la si dod2 | dod,4 mi mi mi | re fad fad2 | sold4 sold fad sold | si la la2 \bar "||"
  \break
  dod,4 mi mi2 | re4 fad fad2 | sold8 sold sold4 fad sold | la si dod2
  \break
  dod,4 mi mi2 | re4 fad fad2 | sold8 sold sold4 fad sold | si la la
  \bar "|."
}
\addlyrics {
  My wife and I live all a -- lone, in a lit -- tle hut we
  call our own. She loves gin and I love rum, and we have such lots of fun.
  Ha -- ha -- ha, you and me, lit -- tle brown jug, don't I love thee.
  Ha -- ha -- ha, you and me, lit -- tle brown jug, don't I love thee.
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
