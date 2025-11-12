\version "2.24.3"

\header {
  title = "Petit Papa Noël"
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
  \time 4/4
  %\tempo "Allegro molto" 4 = 170

  \key sol \major % fa♯

  % TODO : 4 mesures vides

  \partial 4
  re4 | sol sol sol la | sol2 r4 sol8 la | si4 si si do |
  \break
  si2 r4 la4 | sol4. sol8 sol sol fad mi | re2. re8 re | sol2 sol8 sol fad sol |
  \break
  la2. re,4 | sol4 sol sol la | sol2 r4 sol8 la | si4 si si do |
  \break
  si2. la4 | sol4. sol8 sol sol fad mi | re2. re8 re | sol2 sol8 sol la la |
  \break
  sol2. r4 | mi8 mi mi mi mi4 mi8 fad | sol4. mi8 mi4 re | sol8 sol sol sol sol4 fad8 sol |
  \break
  la2. r4 | sib8 sib sib sib sib4 la8 si | do4. la8 sol4 fa4 | sib sib8 sib do4 do8 do |
  \break
  re2
 
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
      \chromaticHarmonicaTab \relative do' {
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
    \relative do' {
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

%\diatoniqueScore
\chromatiqueScore
\midiScore
