\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Gammes Pentatoniques"
  subtitle = "Positions 1 à 5 sur harmonica en Do (C)"
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

melodie = {
  \clef "treble^8"
  \time 6/4

  \sectionTitle "1re position (Do majeur) — pentatonique majeure"
  do re mi sol la do' la sol mi re do2
  \break

  \sectionTitle "1re position (La mineur) — pentatonique mineure"
  la, do re mi sol la sol mi re do la,2
  \break

  \sectionTitle "2e position (Sol majeur) — pentatonique majeure (cross-harp)"
  sol, la si re mi sol mi re si la sol,2
  \break

  \sectionTitle "2e position (Mi mineur) — pentatonique mineure"
  mi, sol la si re mi re si la sol mi,2
  \break

  \sectionTitle "3e position (Ré majeur) — pentatonique majeure"
  re, mi fad la si re' si la fad mi re,2
  \break

  \sectionTitle "3e position (Si mineur) — pentatonique mineure"
  si,, re mi fad la si la fad mi re si,,2
  \break

  \sectionTitle "4e position (La majeur) — pentatonique majeure"
  la,, si dod mi fad la fad mi dod si la,,2
  \break

  \sectionTitle "5e position (Fa majeur) — pentatonique majeure"
  fa, sol la do re fa re do la sol fa,2

  \bar "|."
}
\addlyrics {
  Do Ré Mi Sol La Do La Sol Mi Ré Do
  La Do Ré Mi Sol La Sol Mi Ré Do La
  Sol La Si Ré Mi Sol Mi Ré Si La Sol
  Mi Sol La Si Ré Mi Ré Si La Sol Mi
  Ré Mi Fa♯ La Si Ré Si La Fa♯ Mi Ré
  Si Ré Mi Fa♯ La Si La Fa♯ Mi Ré Si
  La Si Do♯ Mi Fa♯ La Fa♯ Mi Do♯ Si La
  Fa Sol La Do Ré Fa Ré Do La Sol Fa
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicHarmonicaTab \relative do' {
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
    \new Staff {
      \chromaticHarmonicaTab \relative do' {
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
    \relative do' {
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
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
%\chromatiqueScore
%\midiScore
