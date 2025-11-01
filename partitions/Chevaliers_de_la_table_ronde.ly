\version "2.25.26"
\header {
  title = "Chevaliers de la table ronde"
  %composer = ""
  %opus = ""
  %arranger = ""
  %instrument = "Harmonica chromatique"
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
  \tempo 4 = 120
  \time 4/4
  
  % FR
  \key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  %\key fa \major  % Si♭ --> try to \transpose fa sol
  %\key sib \major % Si♭, Mi♭
  
  r2. re8 sol | sol2 sol8 si si re | re2 si4 si8 si |
  \break
  la2 re,8 la' la la | sol2.
  
  
  \break

  \bar "|."  
}
\addlyrics {
  Che __ va -- liers de la ta -- ble ron -- de, goû -- tons voir si le vin est bon.
  Goû -- tons voir, oui, oui, oui, goû -- tons voir, non, non, non, goû -- tons voir si le vin est bon.
  Goû -- tons voir, oui, oui, oui, goû -- tons voir, non, non, non, goû -- tons voir si le vin est bon.
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
    \chromaticHarmonicaTab \relative do'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 96
  }
}

% ============================
% COMPILATION SÉPARÉE
% ============================

% Pour générer la version diatonique :
% lilypond -dcompile-diatonique <fichier.ly>

% Pour générer la version chromatique :
% lilypond -dcompile-chromatique <fichier.ly>

% Pour générer le fichier midi :
% lilypond --formats=midi -dcompile-midi <fichier.ly>

% Inclusion conditionnelle des scores

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

