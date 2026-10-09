\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'harmonica diatonique en Mi (E)"
  subtitle = "Étude complète des notes, altérations, gammes"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Mi (E)"
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
  mi' sold' si' mi'' sold'' si'' mi''' sold''' si''' mi''''
  \break
  \sectionTitle "Notes aspirées de 1 à 10"
  fad' si' red'' fad'' la'' dod''' red''' fad''' la''' dod''''
  \break
  \sectionTitle "Altérations (bends, overblows, overdraws)"
  fa' sol' la' sib' do'' dod'' re'' fa'' sol'' sib'' do''' re''' fa''' sol''' sib''' do'''' re'''' red''''
  \break
  \sectionTitle "Toutes les notes"
  mi' fa' fad' sol' sold' la' sib' si' do'' dod'' re'' red''
  mi'' fa'' fad'' sol'' sold'' la'' sib'' si'' do''' dod''' re''' red'''
  mi''' fa''' fad''' sol''' sold''' la''' sib''' si''' do'''' dod'''' re'''' red''''
  mi''''
  \pageBreak
  \sectionTitle "Gamme pentatonique majeure de Mi"
  mi' fad' sold' si' dod'' mi'' fad'' sold'' si'' dod''' mi''' fad''' sold''' si''' dod'''' mi''''
  \break
  \sectionTitle "Gamme pentatonique mineure de Mi"
  mi' sol' la' si' re'' mi'' sol'' la'' si'' re''' mi''' sol''' la''' si''' re'''' mi''''
  \break
  \sectionTitle "Gamme pentatonique blues de Mi"
  mi' sol' la' sib' si' re'' mi'' sol'' la'' sib'' si'' re''' mi''' sol''' la''' sib''' si''' re'''' mi''''
  \break
  \sectionTitle "Gamme mixolydienne de Mi"
  mi' fad' sold' la' si' dod'' re'' mi'' fad'' sold'' la'' si'' dod''' re''' mi''' fad''' sold''' la''' si''' dod'''' re'''' mi''''
  \pageBreak
  \sectionTitle "Gamme pentatonique mineure de Sol♯"
  sold' si' dod'' red'' fad'' sold'' si'' dod''' red''' fad''' sold''' si''' dod'''' red''''
  \break
  \sectionTitle "Gamme pentatonique blues de Sol♯"
  sold' si' dod'' re'' red'' fad'' sold'' si'' dod''' re''' red''' fad''' sold''' si''' dod'''' re'''' red''''
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  "Mi" "Sol♯" "Si" "Mi" "Sol♯" "Si" "Mi" "Sol♯" "Si" "Mi"
  "Fa♯" "Si" "Ré♯" "Fa♯" "La" "Do♯" "Ré♯" "Fa♯" "La" "Do♯"
  "Fa" "Sol" "La" "Si♭" "Do" "Do♯" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré" "Fa" "Sol" "Si♭" "Do" "Ré" "Ré♯"
  "Mi" "Fa" "Fa♯" "Sol" "Sol♯" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Ré♯" "Mi" "Fa" "Fa♯" "Sol" "Sol♯" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Ré♯" "Mi" "Fa" "Fa♯" "Sol" "Sol♯" "La" "Si♭" "Si" "Do" "Do♯" "Ré" "Ré♯" "Mi"
  "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Mi" "Fa♯" "Sol♯" "Si" "Do♯" "Mi"
  "Mi" "Sol" "La" "Si" "Ré" "Mi" "Sol" "La" "Si" "Ré" "Mi" "Sol" "La" "Si" "Ré" "Mi"
  "Mi" "Sol" "La" "Si♭" "Si" "Ré" "Mi" "Sol" "La" "Si♭" "Si" "Ré" "Mi" "Sol" "La" "Si♭" "Si" "Ré" "Mi"
  "Mi" "Fa♯" "Sol♯" "La" "Si" "Do♯" "Ré" "Mi" "Fa♯" "Sol♯" "La" "Si" "Do♯" "Ré" "Mi" "Fa♯" "Sol♯" "La" "Si" "Do♯" "Ré" "Mi"
  "Sol♯" "Si" "Do♯" "Ré♯" "Fa♯" "Sol♯" "Si" "Do♯" "Ré♯" "Fa♯" "Sol♯" "Si" "Do♯" "Ré♯"
  "Sol♯" "Si" "Do♯" "Ré" "Ré♯" "Fa♯" "Sol♯" "Si" "Do♯" "Ré" "Ré♯" "Fa♯" "Sol♯" "Si" "Do♯" "Ré" "Ré♯"
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicEHarmonicaTab {
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
