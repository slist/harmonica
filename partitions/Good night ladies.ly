\version "2.24.3"

\header {
  title = "Good night, ladies"
  composer = "Edwin Pearce Christy (1825-1915)"
  date = "1847"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
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
  \time 4/4
  \key re \major % Ré majeur (fa♯, do♯)
  
  fad2 re la4 re2. fad2 re mi4 mi2.
  \break
  fad2 re sol4 sol2 sol4 fad8 fad fad4 mi mi re1
  \break
  fad4 mi re mi fad fad fad2 mi4 mi mi2 fad4 la la2
  \break
  fad4 mi re mi fad fad fad2 mi4 mi fad mi re2
 
  \bar "|."
}
%%{
\addlyrics {
  Good night, la -- dies!
  Good night, la -- dies!
  Good night, la -- dies, we're go -- ing to leave you now.
  
  Mer -- ri -- ly we roll a -- long, roll a -- long, roll a -- long,
  mer -- ri -- ly we roll a -- long, o'er the dark blue sea.
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

