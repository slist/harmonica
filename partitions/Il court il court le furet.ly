\version "2.24.3"

\header {
  title = "Il court, il court, le furet"
  lyricsLang = #'(fr)
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
  r2 r8 do8 fa sol |la4 sol8 sol re4 sol8 fa8 mi8 do8 re8 mi8 fa8 do8 fa8 sol8
  \break
  la4 sol8 sol8 re4 sol8 fa8 mi8 do8 re8 mi8 fa4 fa8 fa8 re8 do8 re8 mi8 fa4 fa8 mi8 
  \break
  re8 do8 re8 mi8 fa4 fa8 mi8 re8 do8 re8 mi8 fa4 fa8 mi8 re8 do8 re8 mi8 fa4 r4  
    
  \bar "|."
}
\addlyrics {
   Il court, il court, le fu -- ret, Le fu -- ret du bois, Mes -- dames, Il court, il
  \break
  court, le fu -- ret, Le fu -- ret du bois jo -- li. il est pas -- sé par i -- ci, Il re --
  \break
  pas -- se -- ra par là. Il est pas -- sé par i -- ci, Il re -- pas -- se -- ra par là.
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
