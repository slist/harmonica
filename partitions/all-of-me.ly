\version "2.24.3"

\header {
  title = "All of Me"
  subtitle = \markup \center-column {
    "John Legend (1978–)"
  }
  category = "Pop / rock"
  composer = \markup \column {
    "John Stephens (1978–)"
    "Toby Gad (1968–)"
  }
  poet = ""
  lyricsLang = #'(en)
  instrument = "Harmonica diatonique en La bémol (Ab)"
  copyrightStatus = "copyrighted"
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=450p7goxZqg"
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
  \time 4/4
    \clef "treble^8"

  \key lab \major % 4b - sib, mib, lab, reb
  
  r1 r1 r1 r1  
  
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

accords = \chordmode {
fa1:m reb lab mib fa:m reb lab mib
fa:m reb:7 lab mib fa:m reb:maj7
lab mib fa:m % reb:1.3.5.9 lab mib
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new ChordNames {
      \accords
    }
    \new Staff { 
      \diatonicAbHarmonicaTab \relative do''' {
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
  <<
    % Noms des accords sur la partition
    \new ChordNames \with { \remove "Staff_performer" } {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \unfoldRepeats \relative do'' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \set Staff.midiMinimumVolume = #0.2
      \set Staff.midiMaximumVolume = #0.35
      \unfoldRepeats \accords
    }
  >>

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
#(if compile-partition
     (ly:parser-include-string "\\partitionScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))


% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
%\chromatiqueScore
\midiScore
