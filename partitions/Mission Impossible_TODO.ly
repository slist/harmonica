\version "2.24.3"

\header {
  title = "Mission Impossible"
  %instrument = "Harmonica"
  tagline = ##f
}


% From: https://www.free-scores.com/PDF_FR/anderson-gustav-mission-impossible-89474.pdf

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 5/4
  \tempo "Allegro molto" 4 = 170

  % TODO : 4 mesures vides

  \bar"||" do8 la mi2. r4 | do'8 la mib2. r4 | do'8 la re,2. r4 | do'8-- re-. r4 r4 r2 |
  %r4
  %^\markup \box { \italic "Harmo en D" }
  
  %la4 re mi | fad1 | r4 re8 mi fad4 re | la1 | r2 fad'4 la
  %\break
  %si1 | r4 la8 fad mi4. re8 | fad1 | r2 la,8 re fad4
  %\break
  %mi1~ | mi | re |
  
  %r4
  %^\markup \box { \italic "Harmo en G" }
  
  %re,4 sol8 la4 si8~ \bar "||"
  %\break
  %si1 | r4 sol4 si8 sol4 re8~ | re1 | r2 si'4 re
  %\break
  %mi1 | r4 re8 si la4. sol8 | si1 | r4 si4 mi8 re4 si8~ |
  %\break
  %si1 | r4 sol4 si sol8 re~ | re1 | r2 mi8 sol si4 |
  %\break
  %la1 | r2 la8 sol mi4 | mi1 |
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
    \tempo 4 = 50
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
\chromatiqueScore
\midiScore