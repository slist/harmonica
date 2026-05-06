\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Gammes Jazz"
  subtitle = "Modes et gammes pour l'improvisation — Harmonica en Do (C)"
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
  \time 4/4

  \sectionTitle "Mode Dorien — Ré (2e position)"
  ré4 mi fa sol la si do' ré' do' si la sol fa mi ré2
  \break

  \sectionTitle "Mode Mixolydien — Sol (cross-harp)"
  sol4 la si do' ré' mi' fa' sol' fa' mi' ré' do' si la sol2
  \break

  \sectionTitle "Mode Lydien — Fa"
  fa4 sol la si do' ré' mi' fa' mi' ré' do' si la sol fa2
  \break

  \time 7/4
  \sectionTitle "Gamme par tons — Do (6 degrés)"
  do4 ré mi fad sold sib do' sib sold fad mi ré do2
  \break

  \time 4/4
  \sectionTitle "Gamme diminuée (ton-demi-ton) — Do"
  do4 ré mib fa solb lab la si do'1
  \break

  \sectionTitle "Gamme bébop dominante — Sol"
  sol4 la si do' ré' mi' fa' fad' sol' fad' fa' mi' ré' do' si la sol1

  \bar "|."
}

\addlyrics {
  Ré Mi Fa Sol La Si Do Ré Do Si La Sol Fa Mi Ré
  Sol La Si Do Ré Mi Fa Sol Fa Mi Ré Do Si La Sol
  Fa Sol La Si Do Ré Mi Fa Mi Ré Do Si La Sol Fa
  Do Ré Mi Fa♯ Sol♯ Si♭ Do Si♭ Sol♯ Fa♯ Mi Ré Do
  Do Ré Mi♭ Fa Sol♭ La♭ La Si Do
  Sol La Si Do Ré Mi Fa Fa♯ Sol Fa♯ Fa Mi Ré Do Si La Sol
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
    \tempo 4 = 72
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))
