\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'harmonica diatonique en Si♭ (Bb)"
  subtitle = "Étude complète des notes, altérations, gammes"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Si♭ (Bb)"
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
  sib' re'' fa'' sib'' re''' fa''' sib''' re'''' fa'''' sib''''
  \break
  \sectionTitle "Notes aspirées de 1 à 10"
  do'' fa'' la'' do''' mib''' sol''' la''' do'''' mib'''' sol''''
  \break
  \sectionTitle "Altérations (bends, overblows, overdraws)"
  si' reb'' mib'' mi'' solb'' sol'' lab'' si'' reb''' mi''' solb''' lab''' si''' reb'''' mi'''' solb'''' lab'''' la''''
  \break
  \sectionTitle "Toutes les notes"
  sib' si' do'' reb'' re'' mib'' mi'' fa'' solb'' sol'' lab'' la''
  sib'' si'' do''' reb''' re''' mib''' mi''' fa''' solb''' sol''' lab''' la'''
  sib''' si''' do'''' reb'''' re'''' mib'''' mi'''' fa'''' solb'''' sol'''' lab'''' la''''
  sib''''
  \pageBreak
  \sectionTitle "Gamme pentatonique majeure de Si♭"
  sib' do'' re'' fa'' sol'' sib'' do''' re''' fa''' sol''' sib''' do'''' re'''' fa'''' sol'''' sib''''
  \break
  \sectionTitle "Gamme pentatonique mineure de Si♭"
  sib' reb'' mib'' fa'' lab'' sib'' reb''' mib''' fa''' lab''' sib''' reb'''' mib'''' fa'''' lab'''' sib''''
  \break
  \sectionTitle "Gamme pentatonique blues de Si♭"
  sib' reb'' mib'' mi'' fa'' lab'' sib'' reb''' mib''' mi''' fa''' lab''' sib''' reb'''' mib'''' mi'''' fa'''' lab'''' sib''''
  \break
  \sectionTitle "Gamme mixolydienne de Si♭"
  sib' do'' re'' mib'' fa'' sol'' lab'' sib'' do''' re''' mib''' fa''' sol''' lab''' sib''' do'''' re'''' mib'''' fa'''' sol'''' lab'''' sib''''
  \pageBreak
  \sectionTitle "Gamme pentatonique mineure de Ré"
  re'' fa'' sol'' la'' do''' re''' fa''' sol''' la''' do'''' re'''' fa'''' sol'''' la''''
  \break
  \sectionTitle "Gamme pentatonique blues de Ré"
  re'' fa'' sol'' lab'' la'' do''' re''' fa''' sol''' lab''' la''' do'''' re'''' fa'''' sol'''' lab'''' la''''
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  "Si♭" "Ré" "Fa" "Si♭" "Ré" "Fa" "Si♭" "Ré" "Fa" "Si♭"
  "Do" "Fa" "La" "Do" "Mi♭" "Sol" "La" "Do" "Mi♭" "Sol"
  "Si" "Ré♭" "Mi♭" "Mi" "Sol♭" "Sol" "La♭" "Si" "Ré♭" "Mi" "Sol♭" "La♭" "Si" "Ré♭" "Mi" "Sol♭" "La♭" "La"
  "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Sol♭" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Sol♭" "Sol" "La♭" "La" "Si♭" "Si" "Do" "Ré♭" "Ré" "Mi♭" "Mi" "Fa" "Sol♭" "Sol" "La♭" "La" "Si♭"
  "Si♭" "Do" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré" "Fa" "Sol" "Si♭"
  "Si♭" "Ré♭" "Mi♭" "Fa" "La♭" "Si♭" "Ré♭" "Mi♭" "Fa" "La♭" "Si♭" "Ré♭" "Mi♭" "Fa" "La♭" "Si♭"
  "Si♭" "Ré♭" "Mi♭" "Mi" "Fa" "La♭" "Si♭" "Ré♭" "Mi♭" "Mi" "Fa" "La♭" "Si♭" "Ré♭" "Mi♭" "Mi" "Fa" "La♭" "Si♭"
  "Si♭" "Do" "Ré" "Mi♭" "Fa" "Sol" "La♭" "Si♭" "Do" "Ré" "Mi♭" "Fa" "Sol" "La♭" "Si♭" "Do" "Ré" "Mi♭" "Fa" "Sol" "La♭" "Si♭"
  "Ré" "Fa" "Sol" "La" "Do" "Ré" "Fa" "Sol" "La" "Do" "Ré" "Fa" "Sol" "La"
  "Ré" "Fa" "Sol" "La♭" "La" "Do" "Ré" "Fa" "Sol" "La♭" "La" "Do" "Ré" "Fa" "Sol" "La♭" "La"
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicBbHarmonicaTab {
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
