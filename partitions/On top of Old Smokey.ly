\version "2.24.3"

\header {
  title = "On top of Old Smokey"
  composer = "Traditional"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain" % Mélodie traditionnelle
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
  \key re \major % Tonalité de Ré majeur (fa♯, do♯)
  \time 3/4
  \clef "treble^8"
  \partial 4
  re4 | re fad la | re2. | si | r4 r4 sol | sol la si
  \break
  la2.~ | la | r4 r re, | re fad la | la2.
  \break
  mi | r4 r fad | sol fad mi | re2.~ | re2
  \bar "|."
}
\addlyrics {
  On top of old Smo -- key, all cov -- ered with
  snow; I lost my true lov -- er a -- court -- ing too slow.
}


accords = \chordmode {
  s4 re2. sol s s s
  re s s s la:7
  s s s re
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
    \tempo 4 = 108
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
