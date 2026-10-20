\version "2.26.0"

\header {
  title = "In the good Old Summertime"
  subtitle = ""
  %subsubtitle = ""
  date = "1902"
  composer = "George Evans"
  poet = "Ren Shields"
  instrument = ""
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/498481/scores/6346110"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=H8TnZ80lmdM"
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
  \tempo 4 = 100
  %\clef "treble^15"
  %    \ottava #2

  % La clé est définie dans chaque score (voir plus bas)
  
  \key do \major

  % DIESE
  %\key sol \major % Sol majeur (un dièse : fa♯)
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

  \partial 4 % anacrouse
  sol8 la | sol4 mi2 | sol do4 |  mi2.~ | mi4 ré do |
  %\break
  do ré2 | do la4 | sol2.~ | sol |
  %\break
  mi2 sol4 | do2 ré4 | mi2 ré4 |  do2. |  
  %\break
  ré2 mi4 | ré2 mi4 | ré2.~ | ré2 sol,4 | 
  %\break
  mi2 sol4 | do2 ré4 | mi2 ré4 | do2 do4 | 
  %\break
  do2 ré4 | do la do | sol2.~ | sol2 sol4 |
  %\break
  mi2 sol4 | do2 ré4 | mi2 ré4 | do2 sol4 |
  %\break
  la4 do2 | do ré4 | do2.~ | do4 r2 |
  \bar "|."
}
\addlyrics {
  In the good old sum -- mer -- time in the
  good old sum -- mer -- time
  stroll -- ing thru' the shad -- y lanes
  with your ba -- by mine you
  hold her hand and she holds yours and
  that's a ver -- y good sign that
  she's your toot -- sie woot -- sie in the
  good old sum -- mer time.
}

accords = \chordmode {
  s4 do2. s do:7 s
  fa s do sol:7
  do s mi la:m
  ré:7 s sol:7 s
  do s s do:7
  fa s  do sol:7
  do s  mi:7 la:m
  ré:7 sol:7 do s
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \accords
    }
    \new Staff { 
      \diatonicCHarmonicaTab \relative do''' {
        \clef "treble^8"
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
        % clé de sol normale : la mélodie est écrite une octave plus bas qu'en diatonique
        \clef "treble"
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
        \clef "treble^8"
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
    %\tempo 4 = 120
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