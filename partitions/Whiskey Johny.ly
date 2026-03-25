\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Whiskey Johny"
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
  \tempo 4 = 100
  \clef "treble^8"
  %\partial 2
  fa4 la fa do | fa la fa2 | fa4 la2. | fa4 la2 do4 |
  \break
  sib4. la8 sol4 fa | mi sol do,2 | fa4 la do4. do8 | la4 fa2
  \bar "|."
}
\addlyrics {
  Whis -- key is the life of man. Whis -- key, John -- ny!
  Al -- ways was since the world be -- gan, Whis -- key for my John -- ny!
}


accords = \chordmode {
  fa1 s re:m s
  do s fa2 do2 fa4
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
