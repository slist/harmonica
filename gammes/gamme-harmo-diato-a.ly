\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'harmonica diatonique en La (A)"
  subtitle = "Étude complète des notes, altérations, gammes"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en La (A)"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

\layout {
  \context {
    \Lyrics
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #8 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #24 % Espace entre les portées
}

% Notes en hauteurs absolues (do' = do central, comme sur la tablature de l'harmonica)
melodie = {
  \clef "treble^8"

  \sectionTitle "Notes soufflées de 1 à 10 (-2 = +3)"
  la' dod'' mi'' la'' dod''' mi''' la''' dod'''' mi'''' la''''
  \break
  \sectionTitle "Notes aspirées de 1 à 10"
  si' mi'' sold'' si'' re''' fad''' sold''' si''' re'''' fad''''
  \break
  \sectionTitle "Altérations (bends, overblows, overdraws)"
  sib' do'' re'' mib'' fa'' fad'' sol'' sib'' do''' mib''' fa''' sol''' sib''' do'''' mib'''' fa'''' sol'''' sold''''
  \break
  \sectionTitle "Toutes les notes"
  la' sib' si' do'' dod'' re'' mib'' mi'' fa'' fad'' sol'' sold''
  la'' sib'' si'' do''' dod''' re''' mib''' mi''' fa''' fad''' sol''' sold'''
  la''' sib''' si''' do'''' dod'''' re'''' mib'''' mi'''' fa'''' fad'''' sol'''' sold''''
  la''''
  \pageBreak
  \sectionTitle "Gamme pentatonique majeure de La"
  la' si' dod'' mi'' fad'' la'' si'' dod''' mi''' fad''' la''' si''' dod'''' mi'''' fad'''' la''''
  \break
  \sectionTitle "Gamme pentatonique mineure de La"
  la' do'' re'' mi'' sol'' la'' do''' re''' mi''' sol''' la''' do'''' re'''' mi'''' sol'''' la''''
  \break
  \sectionTitle "Gamme pentatonique blues de La"
  la' do'' re'' mib'' mi'' sol'' la'' do''' re''' mib''' mi''' sol''' la''' do'''' re'''' mib'''' mi'''' sol'''' la''''
  \break
  \sectionTitle "Gamme mixolydienne de La"
  la' si' dod'' re'' mi'' fad'' sol'' la'' si'' dod''' re''' mi''' fad''' sol''' la''' si''' dod'''' re'''' mi'''' fad'''' sol'''' la''''
  \pageBreak
  \sectionTitle "Gamme pentatonique mineure de Do♯"
  dod'' mi'' fad'' sold'' si'' dod''' mi''' fad''' sold''' si''' dod'''' mi'''' fad'''' sold''''
  \break
  \sectionTitle "Gamme pentatonique blues de Do♯"
  dod'' mi'' fad'' sol'' sold'' si'' dod''' mi''' fad''' sol''' sold''' si''' dod'''' mi'''' fad'''' sol'''' sold''''
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  "La" "Do♯" "Mi" "La" "Do♯" "Mi" "La" "Do♯" "Mi" "La"
  "Si" "Mi" "Sol♯" "Si" "Ré" "Fa♯" "Sol♯" "Si" "Ré" "Fa♯"
  "Si♭" "Do" "Ré" "Mi♭" "Fa" "Fa♯" "Sol" "Si♭" "Do" "Mi♭" "Fa" "Sol" "Si♭" "Do" "Mi♭" "Fa" "Sol" "Sol♯"
  "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "Sol♯" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "Sol♯" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "Sol♯" "La"
  "La" "Si" "Do♯" "Mi" "Fa♯" "La" "Si" "Do♯" "Mi" "Fa♯" "La" "Si" "Do♯" "Mi" "Fa♯" "La"
  "La" "Do" "Ré" "Mi" "Sol" "La" "Do" "Ré" "Mi" "Sol" "La" "Do" "Ré" "Mi" "Sol" "La"
  "La" "Do" "Ré" "Mi♭" "Mi" "Sol" "La" "Do" "Ré" "Mi♭" "Mi" "Sol" "La" "Do" "Ré" "Mi♭" "Mi" "Sol" "La"
  "La" "Si" "Do♯" "Ré" "Mi" "Fa♯" "Sol" "La" "Si" "Do♯" "Ré" "Mi" "Fa♯" "Sol" "La" "Si" "Do♯" "Ré" "Mi" "Fa♯" "Sol" "La"
  "Do♯" "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Mi" "Fa♯" "Sol♯"
  "Do♯" "Mi" "Fa♯" "Sol" "Sol♯" "Si" "Do♯" "Mi" "Fa♯" "Sol" "Sol♯" "Si" "Do♯" "Mi" "Fa♯" "Sol" "Sol♯"
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicAHarmonicaTab {
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
    {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 100
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
