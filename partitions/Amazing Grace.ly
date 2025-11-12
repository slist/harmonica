\version "2.24.3"

\header {
  title = "Amazing Grace"
  meter = "Hymn"
  arranger = "Trad. arr."
  composer = "John Newton"
  tagline = ##f
}

%Source: http://harmonicacomte.blogspot.com/2012/10/amazing-grace.html

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 3/4

  r2
  d4 | g2 b4 | b2 a4 | g2 e4 | d2 d4 |
  \break
  g2 b4 | b2 a4-. | d2. | r2 b4 | d2 b4 | b2 a4 |
  % Un point en dessous (ou au-dessus) d'une note dans une partition indique une staccato.
  % Le staccato est une indication d'articulation qui signifie que la note doit être jouée de manière courte et détachée. Cela contraste avec les notes jouées de manière légato, qui sont liées entre elles.
  % En général :
  % Sur un instrument à vent (comme l'harmonica chromatique), cela signifie souffler ou aspirer la note de manière brève et nette.
  % Si tu travailles une partition pour l'harmonica, tu peux expérimenter en soufflant ou en aspirant plus court pour obtenir cet effet !
  
  \break
  g2 e4 | d2 d4 | g2 b4 | b2 a4 | g2 
  \bar "|."
  \break
  
  % Version améloirée par mon professeur
  % Utilisation de triolets: 3 croches qui tiennent dans un temps !
  
  \bar "|."
  %r2
  d8 g8 | g2 \tuplet 3/2 { b8 a g } | b2 b8 a | g2 e4 | d2 d8 g |
  \break
  g2 \tuplet 3/2 { b8 a g } | b2 a8 d | d2. | r2 b8 d | d2 \tuplet 3/2 { b8 a g } | b2 b8 a |
  \break
  g2 e4 | d2 d8 g | g2 \tuplet 3/2 { b8 a g } | b2 a4 | g2 
  \bar "|."
}
\addlyrics {
  A -- maz -- ing grace how sweet the sounds, that
  saved a wretch like me. I once was lost, but
  now am found; was blind but now I see.
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


%\chromatiqueScore
%\midiScore