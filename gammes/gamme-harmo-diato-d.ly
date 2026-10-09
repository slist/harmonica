\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'harmonica diatonique en Ré (D)"
  subtitle = "Étude complète des notes, altérations, gammes"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Ré (D)"
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
  re' fad' la' re'' fad'' la'' re''' fad''' la''' re''''
  \break
  \sectionTitle "Notes aspirées de 1 à 10"
  mi' la' dod'' mi'' sol'' si'' dod''' mi''' sol''' si'''
  \break
  \sectionTitle "Altérations (bends, overblows, overdraws)"
  mib' fa' sol' lab' sib' si' do'' mib'' fa'' lab'' sib'' do''' mib''' fa''' lab''' sib''' do'''' dod''''
  \break
  \sectionTitle "Toutes les notes"
  re' mib' mi' fa' fad' sol' lab' la' sib' si' do'' dod''
  re'' mib'' mi'' fa'' fad'' sol'' lab'' la'' sib'' si'' do''' dod'''
  re''' mib''' mi''' fa''' fad''' sol''' lab''' la''' sib''' si''' do'''' dod''''
  re''''
  \pageBreak
  \sectionTitle "Gamme pentatonique majeure de Ré"
  re' mi' fad' la' si' re'' mi'' fad'' la'' si'' re''' mi''' fad''' la''' si''' re''''
  \break
  \sectionTitle "Gamme pentatonique mineure de Ré"
  re' fa' sol' la' do'' re'' fa'' sol'' la'' do''' re''' fa''' sol''' la''' do'''' re''''
  \break
  \sectionTitle "Gamme pentatonique blues de Ré"
  re' fa' sol' lab' la' do'' re'' fa'' sol'' lab'' la'' do''' re''' fa''' sol''' lab''' la''' do'''' re''''
  \break
  \sectionTitle "Gamme mixolydienne de Ré"
  re' mi' fad' sol' la' si' do'' re'' mi'' fad'' sol'' la'' si'' do''' re''' mi''' fad''' sol''' la''' si''' do'''' re''''
  \pageBreak
  \sectionTitle "Gamme pentatonique mineure de Fa♯"
  fad' la' si' dod'' mi'' fad'' la'' si'' dod''' mi''' fad''' la''' si''' dod''''
  \break
  \sectionTitle "Gamme pentatonique blues de Fa♯"
  fad' la' si' do'' dod'' mi'' fad'' la'' si'' do''' dod''' mi''' fad''' la''' si''' do'''' dod''''
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  "Ré" "Fa♯" "La" "Ré" "Fa♯" "La" "Ré" "Fa♯" "La" "Ré"
  "Mi" "La" "Do♯" "Mi" "Sol" "Si" "Do♯" "Mi" "Sol" "Si"
  "Mi♭" "Fa" "Sol" "La♭" "Si♭" "Si" "Do" "Mi♭" "Fa" "La♭" "Si♭" "Do" "Mi♭" "Fa" "La♭" "Si♭" "Do" "Do♯"
  "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Do♯" "Ré"
  "Ré" "Mi" "Fa♯" "La" "Si" "Ré" "Mi" "Fa♯" "La" "Si" "Ré" "Mi" "Fa♯" "La" "Si" "Ré"
  "Ré" "Fa" "Sol" "La" "Do" "Ré" "Fa" "Sol" "La" "Do" "Ré" "Fa" "Sol" "La" "Do" "Ré"
  "Ré" "Fa" "Sol" "La♭" "La" "Do" "Ré" "Fa" "Sol" "La♭" "La" "Do" "Ré" "Fa" "Sol" "La♭" "La" "Do" "Ré"
  "Ré" "Mi" "Fa♯" "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa♯" "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa♯" "Sol" "La" "Si" "Do" "Ré"
  "Fa♯" "La" "Si" "Do♯" "Mi" "Fa♯" "La" "Si" "Do♯" "Mi" "Fa♯" "La" "Si" "Do♯"
  "Fa♯" "La" "Si" "Do" "Do♯" "Mi" "Fa♯" "La" "Si" "Do" "Do♯" "Mi" "Fa♯" "La" "Si" "Do" "Do♯"
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicDHarmonicaTab {
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
