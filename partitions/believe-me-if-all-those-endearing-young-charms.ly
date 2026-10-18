\version "2.26.0"

\header {
  title = "Believe Me, If All Those Endearing Young Charms"
  subtitle = "Traditional Irish Air"
  %subsubtitle = ""
  date = "1808"
  composer = "Thomas Moore"
  %poet = "Thomas Moore"
  instrument = "Harmonica diatonique en Mib (Eb)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/28724592/scores/7006976"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  composerNationality = "en"
  youtube = ""
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
  \time 6/8
  \tempo "Andantino" 4 = 72
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
  \key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  \partial 8 % anacrouse
  sol16 fa | mib8. fa16 mib8 mib sol sib | lab do mib mib4 ré16 do |
 % \break
  sib8. lab16 sol8 fa8. mib16 fa8 | sol4.~ sol4 sol16 fa | mib8. fa16 mib8 mib8 sol sib |
%  \break
  lab8 do mib mib4\fermata ré16 do | sib8 mib sol, fa8. mib16 fa8 | mib4.~ mib4 sib'16 lab |
%  \break
  sol8 sib mib mib8.~ mib16 sib sib | do8 lab mib' mib4 ré16 do | sib8. lab16  sol8   fa8. mib16 fa8 |
%  \break
  sol4.~ sol4 sol16 fa | mib8. fa16 mib8 mib8 sol sib | lab8 do mib mib4\fermata ré16 do |
%  \break
  sib8 mib sol, fa8. mib16 fa8 | mib4.~ mib8 r8
  \bar ":|."
}

accords = \chordmode {
  s8
  mib4. mib:7 lab q
  mib sib mib sib:7 mib mib:7
  lab q mib sib mib sib:7
  do:m q fa:m \parenthesize lab mib sib
  sol:7 sib:7 mib mib:7 lab q
  mib sib mib
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
      \diatonicEbHarmonicaTab \relative do''' {
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