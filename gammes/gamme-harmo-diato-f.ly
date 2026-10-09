\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'harmonica diatonique en Fa (F)"
  subtitle = "Étude complète des notes, altérations, gammes"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Fa (F)"
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
  fa' la' do'' fa'' la'' do''' fa''' la''' do'''' fa''''
  \break
  \sectionTitle "Notes aspirées de 1 à 10"
  sol' do'' mi'' sol'' sib'' re''' mi''' sol''' sib''' re''''
  \break
  \sectionTitle "Altérations (bends, overblows, overdraws)"
  solb' lab' sib' si' reb'' re'' mib'' solb'' lab'' si'' reb''' mib''' solb''' lab''' si''' reb'''' mib'''' mi''''
  \break
  \sectionTitle "Toutes les notes"
  fa' solb' sol' lab' la' sib' si' do'' reb'' re'' mib'' mi''
  fa'' solb'' sol'' lab'' la'' sib'' si'' do''' reb''' re''' mib''' mi'''
  fa''' solb''' sol''' lab''' la''' sib''' si''' do'''' reb'''' re'''' mib'''' mi''''
  fa''''
  \pageBreak
  \sectionTitle "Gamme pentatonique majeure de Fa"
  fa' sol' la' do'' re'' fa'' sol'' la'' do''' re''' fa''' sol''' la''' do'''' re'''' fa''''
  \break
  \sectionTitle "Gamme pentatonique mineure de Fa"
  fa' lab' sib' do'' mib'' fa'' lab'' sib'' do''' mib''' fa''' lab''' sib''' do'''' mib'''' fa''''
  \break
  \sectionTitle "Gamme pentatonique blues de Fa"
  fa' lab' sib' si' do'' mib'' fa'' lab'' sib'' si'' do''' mib''' fa''' lab''' sib''' si''' do'''' mib'''' fa''''
  \break
  \sectionTitle "Gamme mixolydienne de Fa"
  fa' sol' la' sib' do'' re'' mib'' fa'' sol'' la'' sib'' do''' re''' mib''' fa''' sol''' la''' sib''' do'''' re'''' mib'''' fa''''
  \pageBreak
  \sectionTitle "Gamme pentatonique mineure de La"
  la' do'' re'' mi'' sol'' la'' do''' re''' mi''' sol''' la''' do'''' re'''' mi''''
  \break
  \sectionTitle "Gamme pentatonique blues de La"
  la' do'' re'' mib'' mi'' sol'' la'' do''' re''' mib''' mi''' sol''' la''' do'''' re'''' mib'''' mi''''
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  "Fa" "La" "Do" "Fa" "La" "Do" "Fa" "La" "Do" "Fa"
  "Sol" "Do" "Mi" "Sol" "Si♭" "Ré" "Mi" "Sol" "Si♭" "Ré"
  "Sol♭" "La♭" "Si♭" "Si" "Ré♭" "Ré" "Mi♭" "Sol♭" "La♭" "Si" "Ré♭" "Mi♭" "Sol♭" "La♭" "Si" "Ré♭" "Mi♭" "Mi"
  "Fa" "Sol♭" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Sol♭" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Sol♭" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa"
  "Fa" "Sol" "La" "Do" "Ré" "Fa" "Sol" "La" "Do" "Ré" "Fa" "Sol" "La" "Do" "Ré" "Fa"
  "Fa" "La♭" "Si♭" "Do" "Mi♭" "Fa" "La♭" "Si♭" "Do" "Mi♭" "Fa" "La♭" "Si♭" "Do" "Mi♭" "Fa"
  "Fa" "La♭" "Si♭" "Si" "Do" "Mi♭" "Fa" "La♭" "Si♭" "Si" "Do" "Mi♭" "Fa" "La♭" "Si♭" "Si" "Do" "Mi♭" "Fa"
  "Fa" "Sol" "La" "Si♭" "Do" "Ré" "Mi♭" "Fa" "Sol" "La" "Si♭" "Do" "Ré" "Mi♭" "Fa" "Sol" "La" "Si♭" "Do" "Ré" "Mi♭" "Fa"
  "La" "Do" "Ré" "Mi" "Sol" "La" "Do" "Ré" "Mi" "Sol" "La" "Do" "Ré" "Mi"
  "La" "Do" "Ré" "Mi♭" "Mi" "Sol" "La" "Do" "Ré" "Mi♭" "Mi" "Sol" "La" "Do" "Ré" "Mi♭" "Mi"
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicFHarmonicaTab {
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
