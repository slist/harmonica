\version "2.24.3"

\header {
  title = "Joyeux anniversaire"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 3/4
  
  %r2 --> la première mesure est incomplète (on appelle ça une anacrouse ou “pickup measure”).
  %   --> on peut afficher un silence (r2):q ou rien et signifier la fin de l'anacrouse avec la
  %   --> double barre verticale.
  
  \partial 4
  g8. g16 \bar "||" a4 g c | b2
  \break
  g8. g16 | a4 g d' | c2
  \break
  g8. g16 | g'4 e c | b a\fermata % Point d'orgue, il indique que la note ou le silence sur lequel il est placé doit être prolongé au-delà de sa durée normale, selon l'interprétation du musicien ou du chef d'orchestre.
  \break
  f'8. f16 | e4 c d | c2.
  \bar "|."
}
\addlyrics {
  Joy -- eux an -- ni -- ver -- saire.
  Joy -- eux an -- ni -- ver -- saire.
  Joy -- eux an -- ni -- ver -- sai -- re.
  Joy -- eux an -- ni -- ver -- saire.
}


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c''' {
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
    \relative c''' {
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

\diatoniqueScore