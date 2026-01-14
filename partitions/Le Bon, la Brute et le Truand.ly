\version "2.24.3"

\header {
  title = "Le Bon, la Brute et le Truand"
  composer = "Ennio Morricone (1928-2020)"
  copyrightStatus = "copyrighted"
  tagline = ##f
}

% From: https://musescore.com/user/26895614/scores/5277890

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 110

  la'16 re la re la2 fa4 | sol re2. |
  \break
  la'16 re la re la2 fa4 | sol do2. |
  \break
  la16 re la re  la2 fa4 | mi8 re do2. |
  \break
  la'16 re la re  la2 sol4 | re4 re2. |
  \break
  r2 r4 la8 r8 | re8 la' fa do'2~ do8~ | do2. r8 la,8 | re la' fa do'2~ do8~ | do2. r8 la,8 |
  \break
  re8 la' fa do'2~ do8~ | do2.
  
    la8 mi' r8 do sol'2 la4 mi fa16 mi re r4 r16

  
  \bar "|."
}
\addlyrics {
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
    \relative do'' {
      \melodie
    }
  }
  \midi {
    %\tempo 4 = 58
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
