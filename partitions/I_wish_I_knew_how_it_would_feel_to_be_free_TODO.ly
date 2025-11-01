\version "2.24.3"
\header {
  title = "I wish I knew how it would feel to be free"
  composer = "Nina Simone"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = \relative do'' {
  %\tempo "Largo" 4 = 50
  %\time 3/4
  \tempo 4 = 126
  
  % FR
  %\key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  \key fa \major  % Si♭ --> try to \transpose fa sol
  %\key sib \major % Si♭, Mi♭
  
  % La méthode suivante fonctionne mais ajoute une mesure au compteur...
  %\dynamicUp
  %s1 \mf  % skip: note fantôme qui occupe une durée mais n'imprime rien, permet de placer le mezzo-forte sans note
  %\bar "" % Supprime la barre de la mesure
  
  %\bar ".|:" 
  
  % -. : note staccato
  % En notation musicale, une note noire avec un point au-dessus correspond à une note staccato.
  % Le point au-dessus (ou parfois en dessous selon la position sur la portée) indique que la note doit être jouée courte et détachée, c’est-à-dire plus brève que sa valeur normale.
  
  % ||
  % Fin d’une section musicale : pour marquer une séparation importante, mais pas nécessairement la fin de la pièce.
  
  % la première mesure est incomplète (on appelle ça une anacrouse ou “pickup measure”).
  \partial 2 r2 \bar "||" 
  
  \compressEmptyMeasures
  \override MultiMeasureRest.expand-limit = 2
  R1*3 % 3 mesures de silence regroupées
  \expandEmptyMeasures

  r2 
  r4
  \break
  fa4-. \bar "||" do'2 la8-- sol4-. fa8~ | fa2 re8-- fa4-. fa8~ | fa2 re8-- fa4-. fa8~ fa2 r4
  \break
  fa4-.       |   do'2 re8 do4-. la8~ | la2 sol8-- la4-.sol8~ | sol2 mi8-- re4-. do8~ | do2 r4
  \break
  fa4-.       |   do'2 la8-- sol4-. fa8~ | fa2 re8-- fa4-. fa8~ | fa2 re8-- fa4-. fa8~ | fa2
  \break
  fa8-- fa4-. la8~ | la2 sol8-- sol4-. do,8~ | do2 fa8-- fa4-. fa8~ | fa2 r4
  \break
  fa4-. \bar "||" do'2 la8-- sol4-. fa8~ | fa2
  

  \bar "|."  
}
\addlyrics {
  And I wi -- sh I knew how
It would feel to be free
I wi -- sh that I could break
All the chains holding me
I wi -- sh I could say
All the things that I'd like to say
Say 'em loud say 'em clear
For the whole round world to hear
I wi -- sh I could share
All the love that's in my heart
Remove all the bars
that keep us apart
And I wi -- sh you could know
What it means to be me
Then you'd see and agree
Every man should be free
I wi -- sh I could live
Like I'm longin' to live
I wi -- sh I could give
What I'm longin' to give
And I wi -- sh I could do
All the things I'd like to do
You know they'll still miss part of you
Yes Sir...
And I'm way way over due
I wish I could be like a bird up in the sky
How sweet it would be
If I found out I could fly
So long to my song
And look down upon Ihe sea
And I sing because I know
I would see you
I sing because I know
I would see you
And I sing because I know
I would see you
To be free, yeah
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

