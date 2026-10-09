\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Gammes Pentatoniques — harmonica diatonique en Do (C)"
  subtitle = "Positions 1 à 5 : pentatonique majeure et pentatonique mineure relative"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Do (C)"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

\paper {
  markup-system-spacing.basic-distance = #8
  system-system-spacing.basic-distance = #24
}

% Notes en hauteurs absolues (do' = do central, comme sur la tablature de l'harmonica)
melodie = {
  \clef "treble^8"
  \time 4/4

  \sectionTitle "1re position (Do majeur) — pentatonique majeure"
  do'4 re' mi' sol' la' do'' la' sol' mi' re' do'2
  \break

  \sectionTitle "1re position (La mineur) — pentatonique mineure"
  la'4 do'' re'' mi'' sol'' la'' sol'' mi'' re'' do'' la'2
  \break

  \sectionTitle "2e position (Sol majeur) — pentatonique majeure"
  sol'4 la' si' re'' mi'' sol'' mi'' re'' si' la' sol'2
  \break

  \sectionTitle "2e position (Mi mineur) — pentatonique mineure"
  mi'4 sol' la' si' re'' mi'' re'' si' la' sol' mi'2
  \break

  \sectionTitle "3e position (Ré majeur) — pentatonique majeure"
  re'4 mi' fad' la' si' re'' si' la' fad' mi' re'2
  \break

  \sectionTitle "3e position (Si mineur) — pentatonique mineure"
  si'4 re'' mi'' fad'' la'' si'' la'' fad'' mi'' re'' si'2
  \break

  \sectionTitle "4e position (La majeur) — pentatonique majeure"
  la'4 si' dod'' mi'' fad'' la'' fad'' mi'' dod'' si' la'2
  \break

  \sectionTitle "4e position (Fa♯ mineur) — pentatonique mineure"
  fad'4 la' si' dod'' mi'' fad'' mi'' dod'' si' la' fad'2
  \break

  \sectionTitle "5e position (Mi majeur) — pentatonique majeure"
  mi'4 fad' sold' si' dod'' mi'' dod'' si' sold' fad' mi'2
  \break

  \sectionTitle "5e position (Do♯ mineur) — pentatonique mineure"
  dod'4 mi' fad' sold' si' dod'' si' sold' fad' mi' dod'2
  \break

  \bar "|."
}
\addlyrics {
  "Do" "Ré" "Mi" "Sol" "La" "Do" "La" "Sol" "Mi" "Ré" "Do"
  "La" "Do" "Ré" "Mi" "Sol" "La" "Sol" "Mi" "Ré" "Do" "La"
  "Sol" "La" "Si" "Ré" "Mi" "Sol" "Mi" "Ré" "Si" "La" "Sol"
  "Mi" "Sol" "La" "Si" "Ré" "Mi" "Ré" "Si" "La" "Sol" "Mi"
  "Ré" "Mi" "Fa♯" "La" "Si" "Ré" "Si" "La" "Fa♯" "Mi" "Ré"
  "Si" "Ré" "Mi" "Fa♯" "La" "Si" "La" "Fa♯" "Mi" "Ré" "Si"
  "La" "Si" "Do♯" "Mi" "Fa♯" "La" "Fa♯" "Mi" "Do♯" "Si" "La"
  "Fa♯" "La" "Si" "Do♯" "Mi" "Fa♯" "Mi" "Do♯" "Si" "La" "Fa♯"
  "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Mi" "Do♯" "Si" "Sol♯" "Fa♯" "Mi"
  "Do♯" "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Si" "Sol♯" "Fa♯" "Mi" "Do♯"
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
% SCORE MIDI
% ============================

midiScore =
\score {
  \new Staff {
    \set Staff.midiInstrument = #"harmonica"
    \unfoldRepeats {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 80
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
%\midiScore
