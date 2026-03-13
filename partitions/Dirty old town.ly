\version "2.24.3"

\header {
  title = "Dirty old town"
  composer = "Ewan MacColl (1915-1989)"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  tagline = ##f
}

% From: https://musescore.com/user/28111512/scores/6520909

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodieD = {
  \time 4/4
  \tempo "swing" 4 = 120
  \key re \major % Ré majeur (fa♯, do♯)
  
  r4 ^\markup \box { \italic "Harmonica Diatonique en D" }
  la4 re mi | fad1 | r4 re8 mi fad4 re | la1 | r2 fad'4 la
  \break
  si1 | r4 la8 fad mi4. re8 | fad1 | r2 la,8 re fad4
  \break
  mi1~ | mi | re |
}

melodieG = {
  \time 4/4  
  \key sol \major % Sol majeur (un dièse : fa♯)
  
  r4 ^\markup \box { \italic "Harmonica Diatonique en G" }
  
  re4 sol8 la4 si8~ \bar "||"
  \break
  si1 | r4 sol4 si8 sol4 re8~ | re1 | r2 si'4 re
  \break
  mi1 | r4 re8 si la4. sol8 | si1 | r4 si4 mi8 re4 si8~ |
  \break
  si1 | r4 sol4 si sol8 re~ | re1 | r2 mi8 sol si4 |
  \break
  la1 | r2 la8 sol mi4 | mi1 |
  \bar "|."
}

melodieChromatique = {
  \time 4/4
  \tempo "swing" 4 = 120

  \key re \major % Ré majeur (fa♯, do♯)
  
  r4  
  la4 re mi | fad1 | r4 re8 mi fad4 re | la1 | r2 fad'4 la
  \break
  si1 | r4 la8 fad mi4. re8 | fad1 | r2 la,8 re fad4
  \break
  mi1~ | mi | re |
  
  r4
  re,4 sol8 la4 si8~ \bar "||"
  \break
  si1 | r4 sol4 si8 sol4 re8~ | re1 | r2 si'4 re
  \break
  mi1 | r4 re8 si la4. sol8 | si1 | r4 si4 mi8 re4 si8~ |
  \break
  si1 | r4 sol4 si sol8 re~ | re1 | r2 mi8 sol si4 |
  \break
  la1 | r2 la8 sol mi4 | mi1 |
  \bar "|."
}
\addlyrics {
}

% ============================
% SCORE DIATONIQUE D
% ============================

diatoniqueDScore = 
\score {
  <<
    \new Staff { 
      \diatonicDHarmonicaTab \relative do'' {
        \melodieD
      }
    }
  >>
  \layout { }
}

% ============================
% SCORE DIATONIQUE G
% ============================

diatoniqueGScore = 
\score {
  <<
    \new Staff { 
      \diatonicGHarmonicaTab \relative do'' {
        \melodieG
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
        \melodieChromatique
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
      \melodieChromatique
    }
  }
  \midi {
    \tempo 4 = 50
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (begin
       (ly:parser-include-string "\\diatoniqueDScore")
       (ly:parser-include-string "\\diatoniqueGScore")))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

%\diatoniqueDScore
%\diatoniqueGScore
%\chromatiqueScore
%\midiScore