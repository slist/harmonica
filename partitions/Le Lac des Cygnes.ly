\version "2.24.3"
\header {
  title = "Le lac des cygnes"
  composer = "Piotr Ilitch Tchaïkovsky (1840 - 1893)"
  details = "(Opus 20, acte 2, scène n°10)"
  copyrightStatus = "public-domain" % Œuvre tombée dans le domaine public
  opus = "Opus 20"
  arranger = ""
  instrument = ""
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \tempo 4 = 84
  \time 4/4
  
  mi2 la,8 si do re | mi4. do8 mi4. do8 | mi4. la,8 do la fa do' |
  %\break
  la2~ la8 re do si | mi2 la,8 si do re | mi4. do8 mi4. do8 |
  %\break
  mi4. la,8 do la fa do' | la2. la4 | si4 do re mi8 fa |
  %\break
  sol4. fa8 mi4 fa8 sol | la4. sol8 fa4 sol8 la | si4. la8 mi do si la |
  %\break
  si4 do re mi8 fa | sol4. fa8 mi4 fa8 sol | la4. sol8 fa4 sol8 la |
  %\break
  sib4. fa8 re4 fa8 sib | si4. fad8 si4. mi,8 | mi2 la,8 si do re |
  %\break
  mi4. do8 mi4. do8 | mi4. la,8 do sold fa do' | la2~ la8 si do re |
  %\break
  mi2 la,8 si do re | mi4. do8 mi4. do8 | mi4. la,8 do sold fa do' |
  %\break
  la1
  \bar "|."  
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
    \tempo 4 = 84
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

