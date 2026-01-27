\version "2.24.3"
\header {
  title = "Dansons la capucine"
  composer = "Traditionnel français"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
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
  \tempo 4 = 100
  \time 2/4
  
  re4 do8 sol8 | re' re do sol | re'4 do8 sol |
  \break
  re'8 re do4 | re do8 sol | re' re do sol |
  \break
  re'4 do8 sol | re' re do4 | do' r4
  \bar "|."  
}
\addlyrics {
  Dans -- sons la ca -- pu -- ci -- ne. Y'a plus de pain chez nous,
  Y'en a chez la voi -- si -- ne, mais ce n'est pas pour nous. "You !"
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
    \chromaticHarmonicaTab \relative do'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 100
  }
}

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))


%\chromatiqueScore
%\midiScore