\version "2.24.3"

\header {
  title = "Old MacDonald had a farm"
  composer = "Anonyme (XVIII siècle)"
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
  \time 4/4
  \clef "treble^8"
  \key la \major

  la4 la mi mi | fad fad mi2 | dod'4 dod si si | la2 r4 mi4 |
  \break
  la la la mi | fad fad mi2 | dod'4 dod si si | la2 r4 mi8 mi |
  \break
  la4 la la mi8 mi | la4 la la2 | la8 la la4 la8 la la 4 | la8 la la la la4 la |
  \break
  la la mi mi | fad fad mi2 | dod'4 dod si si | la2. r4
  \bar "|."
}
\addlyrics {
  Old Mac -- Do -- nald had a farm, E I E I O! And
  on his farm he had some chicks, E I E I O! With a
  chick -- chick here and a chick -- chick there. Here a chick, there a chick, ev -- ry -- where a chick -- chick
  Old Mac -- Do -- nald had a farm, E I E I O!
}

accords = \chordmode {
  la1 re2 la1 mi2:7 la1
  la1 re2 la1 mi2:7 la1
  s1 s1 s1 s1
  s1 re2 la1 mi2:7 la1
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
      \chromaticHarmonicaTab \relative do''' {
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

%diatoniqueScore
\chromatiqueScore
\midiScore
