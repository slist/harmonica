\version "2.26.0"

\header {
  title = "Piano Man"
  %subtitle = ""
  %subsubtitle = ""
  date = "1973"
  composer = "Billy Joel"
  %poet = "Billy Joel"
  instrument = "Harmonica diatonique en Do (C)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/39593079/scores/20282743"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "en"
  youtube = "https://www.youtube.com/watch?v=gxEPV4kolz0"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

% Préférer +3 (soufflé) à -2 (aspiré) pour le sol
#(define prefer-blow-3 #t)

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))
#(define compile-partition (ly:get-option 'compile-partition))

melodie = {
  \time 3/4
  %\tempo "Andantino" 4 = 72
  %\clef "treble^15"
  %    \ottava #2

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


  r4 r4 <do mi>8 <ré fa>
  \repeat volta 2 {
    
    <do mi sol>2~ <do mi sol>8 <ré fa la> | <do mi sol>4. <si ré fa>8~ <si ré fa> <sol do mi> <si ré fa> <sol do mi>4.~ do4~ |
    \break
    do r4 r4 | <sol do>2. | <ré' fa>8 <do mi>~ do4 <si ré> |
  
  
    \repeat volta 2 {

      do2.~ | do2.~ | do2. |
    }
    \alternative {
      { 
        r2. | \break }
    
      {
        r4 r4 sol'4
      }
    }
    \repeat volta 2 {

      sol2 sol4 | sol4 fa4. mi8 | fa mi do2 | r4 r do |
      \break
      do4 do4. do8 | do4 do8 ré~ ré4 | ré2.~ | ré4 r4 sol8 sol |
      \break
      sol4 sol2~ | sol fa8 mi | fa4 mi8 do~ do4~ | do2 do8 do | do4. fa8 fa4 |
    
    
    }
  }

  \bar "|."
}

accords = \chordmode {
  s2. |
  \repeat volta 2 {

    do sol/si fa/la 
    do/sol fa sol:7
    \repeat volta 2 {
      do fa/do do  
      \alternative {
        {
          fa4/do do fa/do 
        }
        {
          fa4/do do fa/do 
        }
      }
    }
    \repeat volta 2 {
      do2. sol/si fa/la do/sol
      fa do/mi ré sol:7
      do sol/si fa/la do /sol fa
    }
  }
  %  s8
  %  mib4. mib:7 lab q
  %  mib sib mib sib:7 mib mib:7
  %  lab q mib sib mib sib:7
  %  do:m q fa:m \parenthesize lab mib sib
  %  sol:7 sib:7 mib mib:7 lab q
  %  mib sib mib
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
      \diatonicCHarmonicaTab \relative do'' {
        % \clef "treble^8"
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
    \new ChordNames \with { \remove "Staff_performer" } {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \unfoldRepeats \relative do''' {
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
    \tempo 4 = 100
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
    \tempo 4 = 72
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