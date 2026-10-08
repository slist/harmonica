\version "2.26.0"

\header {
  title = "Ashokan Farewell"
  subtitle = ""
  %subsubtitle = ""
  date = "1982"
  composer = "Jay Ungar (1946-)"
  %poet = ""
  instrument = "Harmonica diatonique en Ré (D)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/28724592/scores/6988656"
  %lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=2kZASM8OX7s"
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
  \tempo 4 = 120
  %\clef "treble^15"
  %    \ottava #2

  \clef "treble^8"
  %\clef "treble_8"

  % DIESE
  %\key sol \major % Sol majeur (un dièse : fa♯)
  \key re \major % Ré majeur (fa♯, do♯)
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

  \partial 4 % anacrouse
  la8 dod | 
  \repeat volta 2 {
    ré4. dod8 si8 la |
    fad2 mi8 fad |
    sol4. fad8 mi ré |
    ré2. |
    \break

    la4 ré fad |
    la ré fad |
  }
  \alternative {
    {
      fad4. sol8 fad4 |
      mi2 la,8 dod |
      \break

    }
    {
      la4 dod mi |
      ré2 fad,8 sol |
    }
  }
  \repeat volta 2 {
    la4. fad8 ré4 | ré'2 la4
    \break
    si4. dod8 ré4 | la8 fad4. mi4 | fad4. mi8 ré4 | ré2 fad4 | mi2. |
    \break
    la2 fad8 mi | ré4 fad la | mi'2. | si4. dod8 ré4 | la4 fad4. ré8 | 
  }
  \alternative {
    {
      la4 ré fad | la8 ré4. fad,4 | mi4. ré8 dod4 | ré2 la'8 dod | 
      \break
    }
    {
      la,8 ré fad la ré fad | la ré4. fad,4 | mi4. la,8 dod4 | ré2 
    }
  }
  \bar "|."
}

accords = \chordmode {
  %\set chordChanges = ##f

  s4

  \repeat volta 2 {
    ré2. |
    ré/fad |
    sol |
    mi:m |
    ré |
    si:m |
  }
  \alternative {
    {
      sol | la:7 |
    }
    {
      la:7| ré |
    }
  }
  
  \repeat volta 2
  {

    ré | ré:7/fad |
    sol | ré | s | si:m | la |
    la:7 | ré | do | sol | ré |
  }
  \alternative {
    {
      s | si:m | la:7 | ré |
    }
    {
      s | si:m | mi4:m s la:7 | ré
    }
  }
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new ChordNames {
      %\set chordChanges = ##t
      \accords
    }
    \new Staff { 
      \diatonicDHarmonicaTab \relative do''' {
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
      \set chordChanges = ##t
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

% ===========================================
% SCORE PARTITION (sans tablature harmonica)
% ===========================================

partitionScore =
\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
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
      \unfoldRepeats \relative do'' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \unfoldRepeats \accords
    }
  >>

  \midi {
    \tempo 4 = 120
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
      \set Staff.midiMinimumVolume = #0.25
      \set Staff.midiMaximumVolume = #0.25
      \unfoldRepeats \relative do'' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \unfoldRepeats \accords
    }
  >>

  \midi {
    \tempo 4 = 120
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