\version "2.24.3"

\header {
  title = "Balade country"
  copyrightStatus = "copyrighted"
  tagline = ##f
}
\include "harmonica.ly"
\include "style.ly"

% vib. comme vibrato != trille qui serait plus un enchainement rapide
% entre les notes do et mi par exemple.


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  %\clef "treble^8"
    \override TextScript.padding = #2
    
    %{
    \set midiMinimumVolume = #0.1
    \set midiMaximumVolume = #0.9
    c1\mf \bendAfter #+4 c\mp \bendAfter #-4 c\mf \bendAfter #+4 c\mp \bendAfter #-4
    %}
  \bar ".|:"
  r4 r e f | g1^\markup { \italic "vib." } | r4 a g e | c1^\markup { \italic "vib." } | r4 r e f | g1^\markup { \italic "vib." }
  \break
  r4 a g e | d1^\markup { \italic "vib." } | r4 r e f | g1^\markup { \italic "vib." } | r4 a g e | c'1^\markup { \italic "vib." }
  \break
  r4 r c, d | e2^\markup { \italic "vib." } g4 e | d2^\markup { \italic "vib." } c4 b | c1^\markup { \italic "vib." }
  \bar ":|."
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
    \tempo 4 = 120
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

