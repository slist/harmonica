\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'harmonica diatonique en Sol (G)"
  subtitle = "Étude complète des notes, altérations, gammes"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Sol (G)"
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
  sol' si' re'' sol'' si'' re''' sol''' si''' re'''' sol''''
  \break
  \sectionTitle "Notes aspirées de 1 à 10"
  la' re'' fad'' la'' do''' mi''' fad''' la''' do'''' mi''''
  \break
  \sectionTitle "Altérations (bends, overblows, overdraws)"
  lab' sib' do'' reb'' mib'' mi'' fa'' lab'' sib'' reb''' mib''' fa''' lab''' sib''' reb'''' mib'''' fa'''' fad''''
  \break
  \sectionTitle "Toutes les notes"
  sol' lab' la' sib' si' do'' reb'' re'' mib'' mi'' fa'' fad''
  sol'' lab'' la'' sib'' si'' do''' reb''' re''' mib''' mi''' fa''' fad'''
  sol''' lab''' la''' sib''' si''' do'''' reb'''' re'''' mib'''' mi'''' fa'''' fad''''
  sol''''
  \pageBreak
  \sectionTitle "Gamme pentatonique majeure de Sol"
  sol' la' si' re'' mi'' sol'' la'' si'' re''' mi''' sol''' la''' si''' re'''' mi'''' sol''''
  \break
  \sectionTitle "Gamme pentatonique mineure de Sol"
  sol' sib' do'' re'' fa'' sol'' sib'' do''' re''' fa''' sol''' sib''' do'''' re'''' fa'''' sol''''
  \break
  \sectionTitle "Gamme pentatonique blues de Sol"
  sol' sib' do'' reb'' re'' fa'' sol'' sib'' do''' reb''' re''' fa''' sol''' sib''' do'''' reb'''' re'''' fa'''' sol''''
  \break
  \sectionTitle "Gamme mixolydienne de Sol"
  sol' la' si' do'' re'' mi'' fa'' sol'' la'' si'' do''' re''' mi''' fa''' sol''' la''' si''' do'''' re'''' mi'''' fa'''' sol''''
  \pageBreak
  \sectionTitle "Gamme pentatonique mineure de Si"
  si' re'' mi'' fad'' la'' si'' re''' mi''' fad''' la''' si''' re'''' mi'''' fad''''
  \break
  \sectionTitle "Gamme pentatonique blues de Si"
  si' re'' mi'' fa'' fad'' la'' si'' re''' mi''' fa''' fad''' la''' si''' re'''' mi'''' fa'''' fad''''
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  "Sol" "Si" "Ré" "Sol" "Si" "Ré" "Sol" "Si" "Ré" "Sol"
  "La" "Ré" "Fa♯" "La" "Do" "Mi" "Fa♯" "La" "Do" "Mi"
  "La♭" "Si♭" "Do" "Ré♭" "Mi♭" "Mi" "Fa" "La♭" "Si♭" "Ré♭" "Mi♭" "Fa" "La♭" "Si♭" "Ré♭" "Mi♭" "Fa" "Fa♯"
  "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Fa♯" "Sol"
  "Sol" "La" "Si" "Ré" "Mi" "Sol" "La" "Si" "Ré" "Mi" "Sol" "La" "Si" "Ré" "Mi" "Sol"
  "Sol" "Si♭" "Do" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré" "Fa" "Sol"
  "Sol" "Si♭" "Do" "Ré♭" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré♭" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré♭" "Ré" "Fa" "Sol"
  "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa" "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa" "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa" "Sol"
  "Si" "Ré" "Mi" "Fa♯" "La" "Si" "Ré" "Mi" "Fa♯" "La" "Si" "Ré" "Mi" "Fa♯"
  "Si" "Ré" "Mi" "Fa" "Fa♯" "La" "Si" "Ré" "Mi" "Fa" "Fa♯" "La" "Si" "Ré" "Mi" "Fa" "Fa♯"
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicGHarmonicaTab {
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
