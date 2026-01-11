\version "2.24.3"

\header {
  title = "Le rock and roll des gallinacés"
  composer = "Steve Waring (1943-)"
  arranger = "Stéphane List"
  
  lyricsLang = #'(fr)

  copyright = "© Steve Waring — Tous droits réservés"
  copyrightStatus = "copyrighted"
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
    \override LyricText.font-size = #1
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
  fa4 do fa do | fa la8 do~ do4 r4 | fa,4 do fa do | fa re8 do8~ do4 r4 |
  \break
  fa4 do fa do | fa la8 do8~ do4 r4 | do sib la4 do, |re8 mi r8 fa8~ fa4 r4 |
  \break
  fa4 r4 fa4 r4 | fa4 la8 do8~ do4 r4 |  fa,4 r4 fa4 r4 | fa4 re8 do8~ do4 r4 |
  \break
  fa4 r4 fa4 r4 | fa4 la8 do8~ do4 r4 | do4 sib la do,8 do | re mi r8 fa8~ fa4 r4 |
  \bar "|."
}
\addlyrics {
  Dans ma basse -- cour il y a Des poules, des  din -- dons, des oies;
  Il "y a" mê -- me des ca -- nards Qui bar -- bo -- tent dans la "mare !"
  Cot, cot, cot co -- dec, Cot, cot,  cot co -- dec,
  cot, cot, cot co -- dec, Rock and roll des gal -- li -- na -- "cés !"
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
%\chromatiqueScore
%\midiScore
