\version "2.24.3"

\header {
  title = "You are my sunshine"
  category = "Pop / rock"
  subtitle = ""
  subsubtitle = ""
  date = "1939"  
  composer = "Jimmie Davis (1899-2000)"
  poet = ""
  lyricsLang = #'(en)
  instrument = "Harmonica diatonique en Do (C)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/39593079/scores/15840232"
  copyrightStatus = "copyrighted"
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=1MevYCdn5S8"
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
  \tempo "Moderately" 4 = 120
  \clef "treble^8"
 

  % DIESE
  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  %\key la \major % La majeur (trois dièses : fa♯, do♯, sol♯)
  %\key mi \major % Mi majeur (quatre dièses : fa♯, do♯, sol♯, ré♯)
  %\key si \major % Si majeur (cinq dièses : fa♯, do♯, sol♯, ré♯, la♯)
  %\key fad \major % Fa♯ majeur (six dièses : fa♯, do♯, sol♯, ré♯, la♯, mi♯)
  %\key dod \major % Do♯ majeur (sept dièses : fa♯, do♯, sol♯, ré♯, la♯, mi♯, si♯)


  % BÉMOLS
  \key do  \major  % 0 - aucune altération
  %\key fa  \major  % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  \partial 2. % anacrouse

  \blow sol4 do re \bar "||" mi2 mi~ | mi4 mi ré mi | do2 do~ | do4 do ré mi |
  \break
  fa2 la | sol fa | mi1~ | mi4 do ré mi | fa2 la~ | la4 la sol fa |
  \break
  mi2 do~ | do do4 ré | mi2. fa4 | ré2 ré4 mi | do1~ | do4 \blow sol4  do ré | \bar "||"
  \break
  mi2 mi~ | mi4 mi ré mi | do2 do~ | do4 do ré mi | fa2 la~ |
  \break
  la4 la sol fa | mi1~ | mi4 do ré mi | fa2 la~ | la4 la sol fa |
  \break
  mi2 do~ | do do4 ré | mi2. fa4 | ré2 ré4 mi | do1~ | do
  \bar "|."
}
\addlyrics {
  The oth -- er night, dear, as I lay sleep -- ing
  I dreamed I held you in my arms.
  When I a -- woke, dear, I was mis -- tak -- en
  and I hung my head and I cried
  You are my sun -- shine, my on -- ly sun -- shine
  You make me hap -- py when skies are gray
  You'll nev -- er know, dear, how much I love you
  Please don't take my sun -- shine a -- way

}

accords = \chordmode {
  s2. do1 q q do:7
  fa q do do:7 fa q
  do q q sol:7 do q
  do q q do:7 fa
  q do do:7 fa q
  do q q sol:7 do q
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new ChordNames \with {
      chordChanges = ##t
    } {
      \accords
    }
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
    \new ChordNames \with {
      chordChanges = ##t
    } {
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
    \new ChordNames \with {
      chordChanges = ##t
    } {
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
    \tempo 4 = 120
  }
}

accompagnementMidiScore =
\score {
  <<
    % Noms des accords sur la partition
    \new ChordNames \with { \remove "Staff_performer" } {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \set Staff.midiMinimumVolume = #0.5
      \set Staff.midiMaximumVolume = #0.5
      \relative do'' {
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
