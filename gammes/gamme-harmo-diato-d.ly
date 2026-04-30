\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Cartographie de l'Harmonica en Ré (D)"
  subtitle = "Étude complète des notes, altérations, gammes"
  opus = "Op. 2"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Ré (D)"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

\layout {
  \context {
    \Lyrics
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #8
  system-system-spacing.basic-distance = #24
}

melodie = {
  \clef "treble^8"

  \sectionTitle "Notes soufflées de 1 à 10"
  re mi la re' mi' la' re'' mi'' la'' re'''
  \break

  \sectionTitle "Notes aspirées de 1 à 10"
  mi,,, la dod mi' sol' si' dod'' mi'' sol'' si''
  \break

  \sectionTitle "Altérations (bends)"
  mib,,, reb dob sib lab solb
  \break

  \sectionTitle "Gamme de Ré majeur"
  re,,, mi fad sol la si dod re'
  \break

  \sectionTitle "Gamme mixolydienne de Ré (blues/folk)"
  re,,, mi fad sol la si do re'
  \break

  \sectionTitle "Gamme pentatonique majeure de Ré"
  re,,, mi fad la si re'
  \break

  \sectionTitle "Gamme pentatonique mineure de Ré"
  re,,, fa sol la do re'
  \break

  \sectionTitle "Gamme blues de Ré"
  re,,, fa sol solb la do re'

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1
  Ré Mi La Ré Mi La Ré Mi La Ré
  Mi La Do♯ Mi Sol Si Do♯ Mi Sol Si
  Ré♭ Do♭ Si♭ La♭ Sol♭ Mi♭
  Ré Mi Fa♯ Sol La Si Do♯ Ré
  Ré Mi Fa♯ Sol La Si Do Ré
  Ré Mi Fa♯ La Si Ré
  Ré Fa Sol La Do Ré
  Ré Fa Sol Sol♭ La Do Ré
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicDHarmonicaTab \relative re' {
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
      \chromaticHarmonicaTab \relative re' {
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
    \relative re' {
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
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

%\diatoniqueScore
%\chromatiqueScore
%\midiScore
