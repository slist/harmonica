\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Isn't She Lovely" % 1976
  %subtitle = ""
  composer = "Stevie Wonder (1950 - )"
  %arranger = ""

  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  %copyrightStatus = "public-domain"

  composerNationality = "US"
  %instrument = "Harmonica"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

\layout {
  \context {
    \Voice
    \override TupletNumber.direction = #UP
    \override TupletBracket.direction = #UP
  }
}

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  %\key sol \major % Tonalité de Sol majeur (fa♯)
  %\time 2/2
  %\tempo "Andantino rubato" 4 = 80
  \tempo 4 = 112
  \clef "treble^8" % Harmonica sounds one octave higher than written.
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  \partial 2
  \tuplet 3/2 { mi4 fa mi } | re2 do | r2 \tuplet 3/2 { mi4 fa mi } | re2 do4. la8 ( | sol2 ) \tuplet 3/2 { mi'4 fa mi } |
  %\break
  re2 do | r2 \tuplet 3/2 { mi4 fa mi } | re2 do4. la8 ( | sol2 ) mi'8 fa sol sol~ |
  %\break
  sol4. mi8 fa4 sol8 fa~ | fa2~  \tuplet 3/2 { fa4 mi mi } | mi8 re do re~ re4 do8. la16~ | la4. sol8 \tuplet 3/2 { mi'4 fa mi } |
  %\break
  re2 do | la sol4. mi16 ( re | do4 ) \tuplet 3/2 { r8 sol8 la } \tuplet 3/2 { do re mi }  \tuplet 3/2 { sol la do } | do4-. do,-. 
  
  % do4.  = do noire pointée (durée 1,5 temps)
  % do4-. = do noire staccato (courte)

  \bar "|."
}
\addlyrics {
  Is -- n't she love -- ly, is -- n't she won -- der -- ful? Is -- n't she
  pre -- cious? Less than one min -- ute old. I nev -- er thought
  through love we'd be mak -- ing one as love -- ly as she. But is -- n't she
  love -- ly? Made from love.
}

accords = \chordmode {
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new Staff {
      %\set Staff.instrumentName = "Harmonica en C"
      \diatonicHarmonicaTab \relative do''' {
        \melodie
      }
    }
  >>
  \layout {
    %indent = 2.5\cm
  }
}

% ============================
% SCORE CHROMATIQUE
% ============================

chromatiqueScore = 
\score {
  <<
    \new ChordNames {
      \accords
    }
    \new Staff { 
      \chromaticHarmonicaTab \relative do''' {
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
    \relative do''' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 112
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
\diatoniqueScore
%\chromatiqueScore
\midiScore
