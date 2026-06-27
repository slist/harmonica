\version "2.24.3"

\header {
  title = "L'as tu-vu?"
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
  \key sol \major
  
  re4 fad la2 re4 sol,4 la2 sol8 sol8 sol8 sol8 fad4 fad4
  \break
  mi8 mi8 mi8 mi8 fad4 re4 re4 fad4 la2 re4 si4 la2 
  \break
  sol8 sol8 sol8 sol8 fad8 fad8 fad8 fad8 mi4 la4 re,2 
  
  \bar "|."
}
\addlyrics {
  "L'as" -- tu vu, "l'as" -- tu vu? Ce pe -- tit bon -- hom -- me,
  ce pe -- tit bon -- hom -- me, "L'as" -- tu vu, "l'as" -- tu vu?
  Ce -- pe -- tit bon -- hom -- me au cha -- peau poin -- tu.
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
