\version "2.24.3"

\header {
  title = "Le loup, le renard et la belette"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \clef "treble^8"
  la'4 la8 la8 la4 la8 si8 | do8 si8 do8 la8 sol4 sol4 | si4 si8 do8 re4 do8 si8 |
  \break
  la4 sol4 la4 r8 do8 | si4 do4 la4 r8 si8 | la4 sol4 la2 |
  \break
  la4 la8 la8 la4 la8 si8 | la4 sol4 la4 r8la8 | re4 do4 la4 la4 |
  \break
  re4 do4 si2 | la4 la8 si8 do2 | la8 la8 la8 sol8 la2 |
  \bar "|."
}
\addlyrics {
  J'ai vu le loup, le re -- nard et la be -- let -- te, J'ai vu le loup le re --
  nard dan -- ser J' les ai vus ta -- per du pied;
  J'ai vu le loup, le re -- nard, la belette, J' les ai vus ta --
  per du pied; J'ai vu le loup, le re -- nard dan -- ser.
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
      \diatonicHarmonicaTab \relative do'' {
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
    \new ChordNames {
      \accords
    }
    \new Staff { 
      \chromaticHarmonicaTab \relative do'' {
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
    \relative do'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 140
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

%diatoniqueScore
%\chromatiqueScore
%\midiScore
