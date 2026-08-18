\version "2.24.3"

\header {
  title = "Le pont de la rivière Kwaï"
  arranger = "Robert Longfield (1947 - )" % US
  composer = "Malcolm Arnold (1921 - 2006)" % UK
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted" % jusqu'en 2076
  composerNationality = "gb"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 2/4
  %\key sol \major % fa♯
  
  \compressEmptyMeasures
  \override MultiMeasureRest.expand-limit = 2
  R2*4 % 4 mesures de silence regroupées
  \expandEmptyMeasures
  
  sol8 ( mi ) r4 | r8 mi8 ( fa sol ) | mi'4-. mi4-. | do2 | sol8 ( mi ) r4 | r8 mi8 ( fa mi ) | sol4-. sol-. | fa2 |
  \break
  fa8 ( re ) r4 | r8 re8 ( mi fa )| sol ( mi ) r4 | r8 mi8 ( fad mi )  | re ( sol ) r8 mi8-. |fad8 ( re ) r8 la'8-. | sol2~ |sol2 | sol8 ( mi )  r4 | r8 mi8 ( fa sol ) |
  \break
  mi'4-. mi-.  |do2  |sol8 mi r4 |r8 mi8 fa mi | sol4 sol4 | fa2 | fa8 re r4 |r8 la'8 si la | do sol r4 |r8 sol8 fa mi | 
  \break
  re8 la' r8 do, | si sol'8 r8 sol8 | do,2~ | do8 r8 r4 | do'4. ( re8 | mi4 ) sol | mi8 ( red mi red | mi ) fa mi4 | do4. (re8 | mi4 ) sol |
  \break
  mi8  (red mi red | re ) do-. si4 | si4. (do8 | re4. ) re8-. |do4.( si8 | do8)do8-. mi4->
  
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
    \chromaticHarmonicaTab \relative do'' {
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


% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\chromatiqueScore
\midiScore
