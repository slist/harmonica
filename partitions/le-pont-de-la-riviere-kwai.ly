\version "2.24.3"

\header {
  title = "Le pont de la rivière Kwai"
  arranger = "Robert Longfield (1947 - )" % US
  composer = "Malcolm Arnold (1921 - 2006)" % UK
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted" % jusqu'en 2076
  composerNationality = "gb"
}

%Source: http://harmonicacomte.blogspot.com/2012/10/amazing-grace.html

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
  
  %\partial 4 % anacrouse
  %re8 sol | sol2 \tuplet 3/2 { si8 la sol } | si2 la4 sol2 mi4 | re2 re8 sol8
  %\break
  %sol2 \tuplet 3/2 { si8 la sol } | si2 la8 si | re2.~ | re2 si4
  %\break
  %re2 \tuplet 3/2 { si8 la sol } | si2 la4 | sol2 mi4 | re2 re8 sol |
  %\break
  %sol2 \tuplet 3/2 { si8 la sol } | si2 la4 | sol2.~ | sol4 r2 |

 % r2
 % d4 | g2 b4 | b2 a4 | g2 e4 | d2 d4 |
 % \break
 % g2 b4 | b2 a4-. | d2. | r2 b4 | d2 b4 | b2 a4 |
 % % Un point en dessous (ou au-dessus) d'une note dans une partition indique une staccato.
  % Le staccato est une indication d'articulation qui signifie que la note doit être jouée de manière courte et détachée. Cela contraste avec les notes jouées de manière légato, qui sont liées entre elles.
  % En général :
  % Sur un instrument à vent (comme l'harmonica chromatique), cela signifie souffler ou aspirer la note de manière brève et nette.
  % Si tu travailles une partition pour l'harmonica, tu peux expérimenter en soufflant ou en aspirant plus court pour obtenir cet effet !
  
%  \break
%  g2 e4 | d2 d4 | g2 b4 | b2 a4 | g2 
%  \bar "|."
%  \break
  
  % Version améloirée par mon professeur
  % Utilisation de triolets: 3 croches qui tiennent dans un temps !
  
%  \bar "|."
%  %r2
%  d8 g8 | g2 \tuplet 3/2 { b8 a g } | b2 b8 a | g2 e4 | d2 d8 g |
%  \break
%  g2 \tuplet 3/2 { b8 a g } | b2 a8 d | d2. | r2 b8 d | d2 \tuplet 3/2 { b8 a g } | b2 b8 a |
%  \break
%  g2 e4 | d2 d8 g | g2 \tuplet 3/2 { b8 a g } | b2 a4 | g2 
  \bar "|."
}
\addlyrics {
%  A -- maz -- ing grace how sweet the sounds, that
%  saved a wretch like me. I once was lost, but
%  now am found; was blind but now I see.
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
