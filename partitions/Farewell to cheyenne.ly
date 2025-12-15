\version "2.24.3"

\header {
  title = "Farewell To Cheyenne"
  subtitle = "from Once Upon a Time in The West"
  composer = "Ennio Morricone (1928-2020)"
  instrument = "Harmonica diatonique en C"
  tagline = ##f
}

% From: https://www.sheetmusicdirect.com/de-DE/se/ID_No/1444188/Product.aspx

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
  
  %r1 | r1 | 
  re4 re re re | re do8. re16 mi4 re8. do16 re1~ |
  \break
  re1 | re4 re re re re do8. re16 mi4 re8. do16 | re1~ |
  \break
  re2 mi |
  
  la4 la la la la la la sol8. fa16 la2.~ la8. sol16 | la1 |
  \break
  la4 la la la la la la sol8. fa16 sol1

  \bar "|."
}
\addlyrics {
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
    %\tempo 4 = 58
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
