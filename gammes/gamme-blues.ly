\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Gammes Blues"
  subtitle = "Positions 1, 2 et 3 sur harmonica en Do (C)"
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
  \time 7/4

  \sectionTitle "Gamme blues de Do — 1re position"
  do mib fa solb sol sib do' sib sol solb fa mib do2
  \break

  \sectionTitle "Gamme blues de Sol — 2e position (cross-harp)"
  sol,4 sib do reb re fa sol fa re reb do sib sol,2
  \break

  \sectionTitle "Gamme blues de Ré — 3e position"
  re,4 fa sol solb la do re do la solb sol fa re,2
  \break

  \sectionTitle "Gamme blues de La — 4e position"
  la,,4 do re mib mi sol la sol mi mib re do la,,2
  \break

  \sectionTitle "Gamme blues de Mi — 5e position"
  mi,,4 sol la sib si re mi re si sib la sol mi,,2
  \break

  \sectionTitle "Blues shuffle rythmique (Do)"
  \time 4/4
  \repeat volta 2 {
    do8 mib fa solb sol4 sib | do'2 do'8 sib solb fa |
    sol mib do mib fa solb sol sib | do'1
  }

  \bar "|."
}
\addlyrics {
  Do Mi♭ Fa Sol♭ Sol Si♭ Do Si♭ Sol Sol♭ Fa Mi♭ Do
  Sol Si♭ Do Ré♭ Ré Fa Sol Fa Ré Ré♭ Do Si♭ Sol
  Ré Fa Sol Sol♭ La Do Ré Do La Sol♭ Sol Fa Ré
  La Do Ré Mi♭ Mi Sol La Sol Mi Mi♭ Ré Do La
  Mi Sol La Si♭ Si Ré Mi Ré Si Si♭ La Sol Mi
  Do Mi♭ Fa Sol♭ Sol Si♭ Do Si♭ Sol♭ Fa Sol Mi♭ Do Mi♭ Fa Sol♭ Sol Si♭ Do Do
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

%\diatoniqueScore
%\chromatiqueScore
%\midiScore
