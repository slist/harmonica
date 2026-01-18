\version "2.24.3"

\header {
  title = "Hymne à la joie"
  composer = "L. W. Beethoven (1770-1827)"
  lyricsLang = #'()
  copyrightStatus = "public-domain" % Chanson traditionnelle anglaise (XVIe siècle)
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 80

  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  %\key sib \major  % Si♭ (Si♭, Mi♭)
  
  mi4 mi fa sol | sol fa mi re | do do re mi | mi4. re8 re2
  \break
  mi4 mi fa sol | sol fa mi re | do do re mi | re4. do8 do2
  \break
  re4 re mi do | re mi8 fa mi4 do | re mi8 fa mi4 re | do re sol,2 |
  \break
  mi'4 mi fa sol | sol fa mi re | do do re mi | re4. do8 do2
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

%\diatoniqueScore
%\midiScore
