\version "2.24.3"

\header {
  title = "Silent night - Douce nuit"
  composer = "Franz Xaver Gruber"
  tagline = ##f
}

\markup " "
\markup " "
\markup " "

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 3/4
  %\tempo 4 = 80

  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  %\key sib \major  % Si♭ (Si♭, Mi♭)
  
  
  sol4. la8 sol4 | mi2. | sol4. la8 sol4 | mi2. | re'2 re4 | si2. | do2 do4 | sol2. | la2 la4 | do4. si8 la4 | sol4. la8 sol4 |
  \break
  mi2. | la2 la4 | do4. si8 la4 sol4. la8 sol4 | mi2. | re'2 re4 | fa4. re8  si4 | do2. | mi2 r4 | do4 sol mi | sol4. fa8 re4 | do2.~ | do2 r4
  
  %\break
  
  \bar "|."
}
\addlyrics {
  Dou -- " " ce nuit, sain -- " " te nuit!
  Dans les cieux, l'as -- tre luit.
  Le mys -- tère an -- non -- cé s'ac -- com -- plit.
  Cet en -- fant sur la paille en -- dor -- mi,
  c'est " " l'a -- mour in -- fi -- ni!
  C'est " " l'a -- mour in -- fi -- ni!
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
    \tempo 4 = 90
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
%\midiScore
