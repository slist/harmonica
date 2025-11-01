\version "2.25.26"
\header {
  title = "Dans la troupe"
  %composer = "César Geoffray (1901 - 1972)" % Entrera dans le domaine public à partir du 1er janvier 2043
  %Ce chant n'est pas sous copyright : https://fr.scoutwiki.org/Dans_la_troupe
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
  \tempo 4 = 96
  \time 4/4
  
  % FR
  %\key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  \key fa \major  % Si♭ --> try to \transpose fa sol
  %\key sib \major % Si♭, Mi♭
  
  do4 sol mi' do | re8 re sol, sol do4 r4 |
  \break
  do4 sol mi' do | re8 re sol, sol do4 r4 |
  \break
  do8 do sol sol mi' mi do4 |
  \break
  re8 re sol, sol mi'4 do|
  \break
  do8 do sol sol mi' mi do4 |
  \break
  re8 re sol, sol do4 r4 |
  \bar "|."  
}
\addlyrics {
  Dans la trou -- pe,  
  y’a pas d’jambe de bois!  
  Y’a des nouil -- les, mais ça n’se voit pas!  
  La meil -- leure fa -- çon d’mar -- cher, c’est en -- core la nô -- tre;  
  c’est de mettre un pied d’vant l’autre et d’re -- com -- men -- cer.
  
  Dans la troupe  
  Pas d’difficulté !  
  Si la soupe parfois est brûlée !  
  La meilleure façon d’manger, c’est encore la nôtre  
  C’est d’mettre une bouchée d’vant l’autre et d’recommencer.

  Dans la troupe  
  Y’a pas d’gens grognon !  
  Quand un scout reçoit un savon !  
  La seule façon d’encaisser, c’est encore la nôtre  
  C’est d’être plus chic qu’un autre et d’persévérer !
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
    \tempo 4 = 100
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

