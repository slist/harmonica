\version "2.24.3"

\header {
  title = "All Of Me"
  arranger = ""
  composer = "John Legend (1978 - )"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "us"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \key lab \major % 4b - sib, mib, lab, reb
  
  r2 sib8 do do4 | do8 do do4 do lab | 
  \break
  lab4 r4 sib8 do do4 | do8 sib do4 do8 sib lab fa~ | fa4. r8 do'8 do4. | reb2 do8 lab r4 |
  \break
  reb2 do8 lab r8 lab | sib2 do8 lab4 fa8~ | fa4. r8 sib do do4 | do8 sib do4 do8 sib lab lab~ |
  \break
  lab4 r4 sib8 do do4 | mib8 reb do4 do8 sib lab fa~ | fa4. r8 sib8 do4. | reb2 do8 lab r8 lab8
  \break
  reb4 reb do8 lab r8 lab | sib2 do8 lab4. | reb2 r4. lab8 | fa'4. mib4 reb do8~ | do4. sib4 lab sol8 | 
  \break
  sol4.

  \bar "|."
}
\addlyrics {
  What would I do with -- out your smart
  mouth. Draw -- in' me in and you kick -- in' me out Got my head spin -- nin'.
  No kid -- din' I can't pin you down What's go -- ing on in that beau -- ti -- ful mind
  I'm on your ma -- gi -- cal my -- ste -- ry ride And I'm so di -- zzy. Don't
  know what hit me. But I'll be al -- right. My head's un -- der -- wa -- ter but I'm

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
