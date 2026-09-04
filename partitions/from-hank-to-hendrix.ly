\version "2.24.3"

\header {
  title = "From Hank to Hendrix"
    subtitle = "TODO: Review tempo of last line"

  composer = "Neil Young (1945 - )"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "ca"
  instrument = "Harmonica diatonique en G"
  youtube = "https://www.youtube.com/watch?v=TF13Xk62Onk"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))
#(define compile-partition (ly:get-option 'compile-partition))

melodie = {
  \tempo "Moderately" 4 = 107
  \time 4/4
  %\key sol \major % fa♯
  %\clef "treble^8"
  
  r4 r8 
    % A
  si8  \tuplet 3/2 { si4 la sol } | re'1~ |   re4. 
  
\break
  % B

  si8 si la sol la | si1~ | 
\break
  % C
  
  si4. 
  sol'8 re mi r8 re si | si la sol sol r8 sol sol la1 % TODO revoir le rythme !
  
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
      \diatonicGHarmonicaTab \relative do''' {
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
% SCORE PARTITION (sans tablature harmonica)
% ============================

partitionScore =
\score {
  <<
    \new Staff {
      \relative do'' {
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
    \tempo 4 = 107
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
#(if compile-partition
     (ly:parser-include-string "\\partitionScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))


% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\chromatiqueScore
\diatoniqueScore
\midiScore
