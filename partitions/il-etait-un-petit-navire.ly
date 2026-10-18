\version "2.26.0"

\header {
  title = "Il était un petit navire"
  subtitle = "Chant de marins traditionnel (XIXe siècle)"
  %subsubtitle = ""
  date = ""
  composer = "Traditionnel"
  %poet = ""
  instrument = "Harmonica diatonique en Do (C)"
  enteredby = "Stéphane List"
  source = "Comédie-vaudeville Méridien (Clairville / Montaubry), v. 1850"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
  youtube = "https://www.youtube.com/watch?v=YGIpWPo4Ndw"
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
  \time 2/4
  \tempo 4 = 80
  %\clef "treble^15"
  %    \ottava #2

  % La clé est définie dans chaque score (voir plus bas)

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

  \partial 4. % anacrouse
  si8 si si | ré,4 si' | do8 si si4 | la8 [ r16 la16 ] la8 la | ré,4 la' | si8 la la4 | sol8 [ r16 si ]  si8 si |
  si4 si | si8 ré do si | la [ r16 la16 ] la8 la | la4 la | la8 do si la | sol ré sol si | ré4 si |
  \repeat volta 2 {
    ré4 si | ré do8. si16 | la2 la8 si do ré | mi4 ré | mi ré
  }
  \alternative {
    {
      si2~ | si4 si4
    }
    {
      sol2
    }
  }
  \bar "|."
}
\addlyrics {
  Il é -- tait un pe -- tit na -- vi -- re
  Il é -- tait un pe -- tit na -- vi -- re
  Qui n'a -- vait ja -- ja -- ja -- mais na -- vi -- gué.  
  Qui n'a -- vait ja -- ja -- ja -- mais na -- vi -- gué.
  O -- "hé !" O -- hé!
  O -- "hé !" O -- "hé !" Ma -- te -- lot,
  Ma -- te -- lot na -- vi -- gue sur les flots. O -- flots
}

accords = \chordmode {
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