\version "2.24.3"

\header {
  title = "Au Clair de la Lune"
  instrument = "Harmonica en C"
  composer = "Anonyme"
  copyrightStatus = "public-domain"
  lyricsLang = #'(fr)
  date = ""
  tagline = ##f
}

%Source: https://www.rhapsody.fr/wp-content/uploads/2021/08/Anonyme-Au-Clair-de-la-Lune-1.pdf

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  %\clef "treble_8" % "treble^8" "treble_8"
  c8 c c d e4 d |
  c8 e d d c2 |
  c8 c c d e4 d |
  c8 e d d c2 |
  d8 d d d a4 a |
  d8 c b a g2 |
  c8 c c d e4 d |
  c8 e d d c2 
  \bar "|."
}
\addlyrics {
  Au clair de la lu -- ne, mon a -- mi Pier -- rot.
  Prê -- te moi ta plu -- me, pour é -- crire un mot.
  Ma chan -- delle est mor -- te, je n'ai plus de feu.
  Ou -- vre moi ta por -- te, pour l'a -- mour de Dieu.
}



% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c'' {
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
      \chromaticHarmonicaTab \relative c'' {
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
    \chromaticHarmonicaTab \relative c'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 90
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

