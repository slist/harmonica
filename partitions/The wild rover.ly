\version "2.24.3"

\header {
  title = "The wild rover"
  composer = "The Dubliners"
  date = "1964"
  tagline = ##f
}

%Source: http://harmonicacomte.blogspot.com/2012/10/amazing-grace.html

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 3/4                  % Définit la mesure
  %\key g \major  % Sol majeur (un dièse : fa♯)
  \key f \major
  
   % Afficher le numéro de mesure seulement au début de chaque ligne sauf la première
  %\override Score.BarNumber.break-visibility = #'#(#f #t #t)
  %\override Score.BarNumber.stencil = #ly:text-interface::print
  %\set Score.barNumberVisibility = #all-bar-numbers-visible
  %\set Score.measurePosition = #0

  r2
  f4 | f g f | d c a' | a g a | bes2. | r2 c8 c |
  c4 a c | bes g e | c a' g | f2 r8 f8 | f4 g f |
  d c a' | a g a | bes2. | r2 c8 c | c4 a c | bes g e | c a' g | f e f |
  g2. | g2. e4 c2 ~ | c2. |
  r4 a'4 a | a g a | bes2. | r4 a bes | c2. |
  r4 a4 f | e d2 | r2 d4 | c a'2 ~ | a g4 f2. ~ | f2 
  
  \bar "|."
}
\addlyrics {
  I've been a wild ro -- ver for ma -- ny's the year, and I
  spent all my mon -- ey on whis -- key and beer. And now I'm re --
  turn -- ing with gold in great store, and I ne -- ver will play the wild ro -- ver no more.
  And it's no, nay, ne -- ver!
  No, nay, ne -- ver, no more, will I play the wild ro -- ver. No ne -- ver no more!
  
  
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c' {
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
      \chromaticHarmonicaTab \relative c' {
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
    \relative c' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 120
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

