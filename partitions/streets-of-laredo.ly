\version "2.26.0"

\header {
  title = "Streets of Laredo"
  subtitle = "Cowboy's Lament"
  %subsubtitle = ""
  %date = ""
  composer = "American folk song"
  %poet = ""
  instrument = "Harmonica diatonique en Do (C)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/28724592/scores/6991823"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=L14UKBjC5Is"
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
  sol4 | 
  
  \once \override Slur.dash-definition = #'((0 1 0.5 0.5))
  sol4. ( fa8 ) mi4 | fa sol fa | mi4. ré8 do4 | si sol sol | % TODO sol sort en -2, serait plus facile en +3
  \break
  
  \once \override Tie.dash-definition = #'((0 1 0.5 0.5))
  do4.~ do8 do4 | ré mi fa | mi ré do | ré2 sol4 |
  \break
  
  sol4. fa8 mi4 | fa sol fa | mi4. ré8 do4 | si sol sol |
  \break
  
  do4. do8 do4 | ré mi fa | mi do ré | do2.~ | do2
  \bar "|."
}
%{
\addlyrics {
  As I walked out in the streets of La -- re -- do, as
  I walked out in La -- re -- do one day, I
  spied a young cow -- boy all wrapped in white lin -- en, all
  wrapped in white lin -- en and cold as the clay.
}

\addlyrics {
  “I see by your outfit that you are a cow -- boy,” these
  words he did say as I slow -- ly walked by. “Come
  sit down be -- side me, and hear my sad stor -- y. I'm
  shot in the heart and I know I must die.”
}

\addlyrics {
  “Oh, beat the drum slow -- ly and play the fife low -- ly, and
  play the dead march as you carry me a -- long. Take
  me to the val -- ley and lay the sod o'er me, for
  I'm a young cow -- boy and I know I've done wrong.”
%}

accords = \chordmode {
  s4
  do s s sol:7 s s do s s sol:7 s s
  do s s sol:7 s s do s s sol:7 s s
  do s s sol:7 s s do s s sol:7 s s
  la:m s s ré:m s s do s sol:7 do
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
      \diatonicHarmonicaTab \relative do''' {
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