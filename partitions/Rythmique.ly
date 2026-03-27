\version "2.24.3"

\header {
  title = "Harmonica en C - Rythmique (Diatonique)"
  %subtitle = "Marc CORNELISSEN www.marcmusique.com"
  %instrument = "Harmonica en C"
  %composer = "Marc CORNELISSEN www.marcmusique.com"
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
  %\clef "treble^8"
  \sectionTitle "A"
  c4 c c2 | g4 g g2 | c4 c g g | c g c2 |
  \break
  
  \sectionTitle "B"
  c4 g c g | c g c2 |
  \break

  \sectionTitle "C"
  c8 c c c g4 g | c8 c c c g4 g |
  c8 c c c g4 g | c g c2 |
  \break
  
  \sectionTitle "D"
  c8 g c g c4 c | c8 g c g c4 c |
  \break
    
  \sectionTitle "E"
  c8 c c4 g8 g g4 | c8 c g g c4 c |
  \break
  
  \sectionTitle "F"
  c8 c g g c c g g | c8 c g g c4 c
  \break
  
  \sectionTitle "G"
  c8 g c4 g8 c g4 | g8 c g g c g c4 
  \break

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

%\diatoniqueScore
%\chromatiqueScore
%\midiScore
