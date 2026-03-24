\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Red River Valley"
  subtitle = "Traditional American Folk Song"
  %composer = "Traditional (author unknown)"
  %poet = "Traditional"
  lyricsLang = #'(en)
  %copyright = "Public Domain"
  copyrightStatus = "public-domain" % Mélodie traditionnelle
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

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
  \key fa \major % Tonalité de Fa majeur (sib♯)
  \time 4/4
  \tempo 4 = 120
  \clef "treble^8"
  \partial 2
  do4 fa | la2 la4 la | la2 sol4 la | sol fa2.~ | fa2 do4 fa | la2 fa4 la |
  \break
  do2 sib4 la | sol1~ | sol2 do4 sib | la2 la4 sol | fa2 sol4 la |
  \break
  do4 sib2.~ | sib2 re,4 reb | do2 mi4 fa | sol2 la4 sol | fa1~ | fa2
  
  %re4 | re fad la | re2. | si | r4 r4 sol | sol la si
  \break
  %la2.~ | la | r4 r re, | re fad la | la2.
  \break
  %mi | r4 r fad | sol fad mi | re2.~ | re2
  \bar "|."
}
\addlyrics {
  From this val -- ley they say you are go -- ing, we will miss you bright
  eyes and sweet smile, for they say you are talk -- ing the
  sun -- shine which has bright -- ened our path -- way a while.
}


accords = \chordmode {
  s2 fa1 do:7 fa s s
  s do:7 s fa fa:7
  sib s fa do:7 fa
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicDHarmonicaTab \relative do'' {
      %\diatonicHarmonicaTab \relative do'' {
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
    \tempo 4 = 120
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
