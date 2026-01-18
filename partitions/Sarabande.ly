\version "2.24.3"
\header {
  title = "Sarabande"
  
  composer = \markup {
    \column {
      \line { 
        \with-url #"https://fr.wikipedia.org/wiki/Georg_Friedrich_Haendel" 
        "Georg Friedrich Haendel (1685 - 1759)"
      }
    }
  }
%composer = \markup { "🇬🇧 Georg Friedrich Haendel" }
%composer = "Georg Friedrich Händel (Haendel) (1685 - 1759)"
  opus = "HWV 437"
  lyricsLang = #'()
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
  \tempo 4 = 70
  \time 3/4
  
  % FR
  %\key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  \key fa \major  % Si♭ --> try to \transpose fa sol
  %\key sib \major % Si♭, Mi♭
  
  \repeat volta 2 {
  fa4 fa r8 sol8 | mi4 mi r4 | la4 la r8 sib8 | sol4 sol r8 la8 |
  sib4 sib r8 do8 | la4 la r8 la8 | re4 re r8 mi8 | dod4 dod r4 |
  fa,4 fa r8 sol8 | mi4 mi r4 | la la r8 sib8 | sol4 sol r8 la |
  sib4 sib r8 do | la4. la8 re dod | re mi fa4 mi8 re | re2 r4 |
  }
  
  \repeat volta 2 {
  fa,4.
  }
     
  \bar "|."  
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
    \tempo 4 = 70
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

