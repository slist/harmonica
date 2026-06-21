\version "2.24.3"

\header {
  title = "La famille tortue"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \clef "treble^8"
  r2 r4 la8 sib | do4 la' la8 sol fa mi | sol4 re re sol,8 la |
  \break
  sib4 sol' sol8 fa8 mi8 re8 | fa4 do4 do4 la8 sib do4 la'4 la8 sol8 fa8 mi8 |
  \break
  re4 sib' sib8 la8 sol8 fa8 mi4 do'4 do8 sib8 la8 sol8 fa4 la4 fa4 r4
  \bar "|."
}
\addlyrics {
  Ja -- mais on n'a vu, Ja -- mais on ne ver -- ra, La fa --
  mille tor -- tue cour -- rir a -- près les rats. Le pa -- pa tor -- tue, et la ma --
  man tor -- tue, Et les en -- fants tor -- tues, i -- ront tou -- jours au pas.
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

%diatoniqueScore
%\chromatiqueScore
%\midiScore
