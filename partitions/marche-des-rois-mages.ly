\version "2.26.0"

\header {
  title = "Marche des Rois Mages"
  subtitle = "Chanson traditionnelle française"
  %subsubtitle = ""
  date = "1872"
  composer = "Georges Bizet (1838-1875)"
  %poet = ""
  instrument = ""
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/27271846/scores/8979803"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
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
  %\time 3/4
  \tempo 4 = 100
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

  \partial 2 % anacrouse
  la4 mi | la4. si8 do8. si16 do8.
  \bar "|."
}
\addlyrics {
  Ce ma -- tin j'ai vu dans le loin -- tain, fré -- mir au vent des ban -- de -- ro -- les clai -- res.
  Ce ma -- tin j'ai vu dans le loin -- tain, ve -- nir des gens vê -- tus de frais sa --tin.
}

% TODO : check si c'est des s ou q qu'il faut faire
accords = \chordmode {
  la:m q q do re:m sol
  ré:m la:m q q q q ré:m do sol
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
      \diatonicBbHarmonicaTab \relative do''' {
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
    \tempo 4 = 112
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