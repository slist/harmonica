\version "2.24.3"

\header {
  title = "Zelda’s Lullaby"
  subtitle = "from the Legend of Zelda series of video games"
  subsubtitle = "The Legend of Zelda: Ocarina of Time."
  date = "1998"  
  composer = "Koji Kondo (1961 - )"
  %poet = ""
  instrument = "Harmonica diatonique en Sol (G)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/28724592/scores/8066706"
  %lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "jp"
  youtube = "https://www.youtube.com/watch?v=aQF1C5eUkEs"
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
  \time 3/4
  \tempo "Andante" 4 = 100
  \clef "treble^8"
  %\clef "treble_8"

  % DIESE
  \key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  %\key la \major % La majeur (trois dièses : fa♯, do♯, sol♯)
  %\key mi \major % Mi majeur (quatre dièses : fa♯, do♯, sol♯, ré♯)
  %\key si \major % Si majeur (cinq dièses : fa♯, do♯, sol♯, ré♯, la♯)
  %\key fad \major % Fa♯ majeur (six dièses : fa♯, do♯, sol♯, ré♯, la♯, mi♯)
  %\key dod \major % Do♯ majeur (sept dièses : fa♯, do♯, sol♯, ré♯, la♯, mi♯, si♯)


  % BÉMOLS
  %\key do  \major  % 0 - aucune altération
  %\key fa  \major  % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  \repeat volta 2 {
    si2 re4 | la2 sol8 la | si2 re4 | la2. |
    \break
    si2 re4 la'2 sol4 |  
  }
  \alternative {
    { re2 do8 si | la2. | }
    { re'2.~ | re | }
  }
  \break
  re2 do8 si | do si sol2 | do2 si8 la | si la mi2 |
  \break
  re'2 do8 si | do si sol4 do | sol'2.~ | sol |
  \break
  si,,2 re4 | la2 sol8 la | si2 re4 | la2. |
  \break
  si2 re4 | la'2 sol4 | re2 do8 si | la2. | sol2. |
  \bar "|."
}
\addlyrics {
}

accords = \chordmode {
  do re:7 do re:7
  si:m7 red:7 la:m7 re:7 la:m7 re:7
  fa:maj7 mi:m7 re:m7 do:maj7
  fa:maj7 mi:m7 mib:7 re:m7
  do re:7 do re:7
  si:m7 red:7 la:m7 re:7 sol
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
    \new ChordNames {
      \accords
    }
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
    \new ChordNames {
      \accords
    }
    \new Staff {
      \relative do''' {
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
    \new ChordNames {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \relative do''' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \accords
    }
  >>

  \midi {
    \tempo 4 = 100
  }
}

accompagnementMidiScore =
\score {
  <<
    % Noms des accords sur la partition
    \new ChordNames {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \set Staff.midiMinimumVolume = #0.5
      \set Staff.midiMaximumVolume = #0.5
      \relative do''' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \accords
    }
  >>

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
%\partitionScore
\midiScore
%\accompagnementMidiScore
