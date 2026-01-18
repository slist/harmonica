\version "2.24.3"

\header {
  title = "Un éléphant qui se balançait"
  %composer = ""
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
  \time 6/8
  \clef "treble^8"
  
  fa4. fa4 fa8 | re4. re4 re8 |sol4 sol8 r4 do,8~ | do4 do8 re4 mi8 |
  \break
  fa4 fa8 fa4 mi8 | re4.r4 sol8~ | sol4 la8 sol4 fa8 |mi4 do8 re4 mi8
  \break
  fa4.~ fa4. | re4. r4 sol8~ | sol4 la8 sol4 fa8 | mi4 do8 re4 mi8 |
  \break
  fa4. fa4. | re4. re4. | la'4 la8~ la4 fa8~ | fa4. r4 r8
  
  \bar "|."
}
\addlyrics {
  Un é -- lé -- phant qui  se ba -- lan -- çait Sur u -- ne
  toi -- le, toi -- le, toile... toi -- le d'a -- rai -- gnée; C' -- é --  tait
  un jeu telle -- ment a  -- mu -- sant Qu'il alla cher -- 
  cher un deu -- xième é -- lé -- phant!
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
    \tempo 4 = 180
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
