\version "2.24.3"

\header {
  title = "Man With The Harmonica"
  subtitle = "from Once Upon a Time in The West"
  composer = "Ennio Morricone (1928-2020)"
  tagline = ##f
}

% From: https://www.youtube.com/watch?v=cHsQw_CXdtc

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 6/4
  \tempo "Lento" 4 = 58
  
  %\bar "|:"
  mi2\mp^\markup { \center-align \italic "ad lib." } red2^\markup { \italic "misterioso" } mi\> | mi\mp do4 red~\> red mi \bar "||" 
  \time 4/4
  mi8\p red~ red4 mi8 red~\> red4 |
  
  \break
  
  \time 6/4
  mi4\mp do red mi2. |
  la,4 do red mi~\fermata mi8 red mi4\> |
  \time 4/4
  r1\! |
  
  \break 
  mi8\mp red4 mi8~ mi4. red8 | mi4 r4 r2 | % Il y a des "repeat measure sign" au dessus des mesures que lilypond ne sait pas faire.
  \break
  mi8 red4 mi8~ mi4. red8 | mi4 r4 r2 | r1 |
  \break
  mi8 do red8 mi~ mi4. red8 | mi4 r4 mi4 red | r2 mi4 red4 |
  \break
  mi4 r4 r2^\markup { \italic "rit...." } \bar "||"
  \tempo "Faster" 4=82 
  la,1 | mi'1 |
  \break
  si1 | r2 r8. si16 do si la si | la2 r2 |
  \break
  la'1 | si4 mi,2.~ | mi2 r2 |
  \break
  mi2. r8 do8 | la'2. r8 la8 | re,1~ |
  \break
  re2 r8 re8 mi16 re do re | do1 | la'2. r8 la8 |
  \break
  si2 mi,4.\mp red8 | mi1\<^\markup { \italic "accel... "} \bar "||"
  \tempo "A little Faster" 4=82
  la,2\mf mi'2 |
  \break
  si2 si8 si do16 si la si | la2 la'2 | si4 mi,2 fa4 |
  \break
  sol2^\markup { \italic "cresc. poco a poco" } la4. sol8 \bar "||" sol2 \tuplet 3/2 { re4^\markup { \italic "cresc." } sol4 do4~ } | do2 si4. do8 |
  \break
  si4 mi,2 mi4 | la2.\< la4\! | fa'\f mi re do |
  \break
  si2. r8 la8 | la1 | mi2\mp^\markup { \italic "molto rall..." } red2_\markup { \italic "dim." } | mi4 \> do red mi\fermata\! |

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
    %\tempo 4 = 58
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
%\chromatiqueScore
%\midiScore

\pageBreak

\markup {
  \column {
    \vspace #1
    \fill-line { \bold "Commentaires" }
  }
}

\markup {
  \column {
    \bold "Indications de nuances"
    \vspace #0.5
    \fill-line {
      \wordwrap {
        Les lettres telles que « p », « mp », « f » ou « ff » sont appelées indications de nuances.
        Elles précisent l’intensité avec laquelle chaque note ou passage doit être joué.
        Ces indications aident l’interprète à donner une expression musicale plus précise et vivante.
      }
    }
  }
}

\markup {
  \column {
    \vspace #0.5
    \line { "   • pp = pianissimo : très doux" }
    \line { "   • p = piano : doux" }
    \line { "   • mp = mezzo-piano : moyennement doux" }
    \line { "   • mf = mezzo-forte : moyennement fort" }
    \line { "   • f = forte : fort" }
    \line { "   • ff = fortissimo : très fort" }
    \line { "   • sfz = sforzando : accent fort et soudain" }
    \vspace #1
  }
}

\markup {
  \column {
    \bold "ad lib."
    \wordwrap {
      “ad lib.” est l’abréviation de ad libitum, une expression latine qui signifie :
« à volonté », « librement », « comme vous le souhaitez ».
Sur une partition, cela indique au musicien qu’il peut interpréter librement un passage.
Selon le contexte, cela peut vouloir dire :
    }
    \vspace #0.5
    \line { "   • jouer le rythme, les pauses et les respirations librement, sans tempo strict" }
    \line { "   • improviser ou ajouter des ornements" }
    \line { "   • répéter une phrase autant de fois que souhaité" }
    \line { "   • sauter ou abréger un passage si nécessaire" }
    \line { "   • allonger certaines notes" }
    \vspace #0.5
    \wordwrap { "Cela produit l'effet cinématographique du thème: dramatique et libre, pas mécanique." }
    \vspace #1
  }
}

\markup {
  \column {
    \vspace #1
    \bold "Abréviations"
    \vspace #0.5
    \line { "dim. = diminuendo = diminuer progressivement le volume de la note ou du passage." }
    \line { "cresc. = crescendo = augmenter le volume progressivement." }
    \vspace #0.5
    \line { "accel. = accelerando = accélérer progressivement le tempo." }
    \line { "rit. = ritardando = ralentir progressivement le tempo." }
    \line { "rall. = rallentado = ralentir progressivement le tempo (souvent un peu plus long que \"rit.\"." }
    \line { "molto rall. = molto rallentado = ralentir fortement le tempo." }
    
  }
}

