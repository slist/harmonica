\version "2.24.3"

\header {
  title = "Ah ! vous dirai-je, maman"
  composer = "Traditionnel"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
  youtube = "https://www.youtube.com/watch?v=ygpWvmZVxho"
}

% TODO: C'est fait par Mistral ! Il reste à mettre les accords..

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
  \key do \major % Tonalité de Do majeur (aucune altération)

  do''4 do'' sol'' sol'' | la'' la'' sol''2 |
  \break
  fa''4 fa'' mi'' mi'' | re'' re'' do''2 |
  \break
  sol''4 sol'' fa'' fa'' | mi'' mi'' re''2 |
  \break
  sol''4 sol'' fa'' fa'' | mi'' mi'' re''2 |
  \break
  do''4 do'' sol'' sol'' | la'' la'' sol''2 |
  fa''4 fa'' mi'' mi'' | re'' re'' do''2 |
  \bar "|."
}
\addlyrics {
  "Ah !" vous di -- rai -- je, ma -- man, Ce qui cau -- se mon tour -- "ment ?"
  Pa -- pa veut que je rai -- son -- ne, Comme une grande per -- son -- ne.
  Moi je dis que les bon -- bons Va -- lent mieux que la rai -- son.
}

accords = \chordmode {
  do2 do4 do4 | fa2 do2 |
  fa4 do4 do4 do4 | sol4 sol4 do2 |
  do4 do4 fa4 fa4 | do4 do4 sol2 |
  do4 do4 fa4 fa4 | do4 do4 sol2 |
  do2 do4 do4 | fa2 do2 |
  fa4 do4 do4 do4 | sol4 sol4 do2 |
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab {
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
    \new ChordNames {
      \accords
    }
    \new Staff { 
      \chromaticHarmonicaTab {
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
    \new ChordNames {
      \accords
    }
    \new Staff {
      \melodie
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
    \melodie
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
#(if compile-partition
     (ly:parser-include-string "\\partitionScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
%\chromatiqueScore
\midiScore