\version "2.24.3"

\header {
  title = "Oh! Susanna"
  composer = "Stephen Foster"
  date = "1848"
  tagline = ##f
}

% Source: https://musescore.com/user/5385411/scores/9382792

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 150
  %\tempo "Moderately" % 4=100
  %\tempo "Moderately" 4=100
  
  % EN
  %\key g \major % Sol majeur (un dièse : fa♯)
  %\key es \major % Mi♭ majeur contient 3 bémols : Si♭ (B♭), Mi♭ (E♭), et La♭ (A♭).
  
  % FR
  %\key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  %\key fa \major  % Si♭ --> try to \transpose fa sol
  %\key sib \major % Si♭, Mi♭
  
  r2 r4 do8 re | mi4 sol sol4. la8 | sol4 mi2 do8 re | mi2 mi8 re do4 |
  \break
  re2. do8 re | mi4 sol sol4. la8 | sol4 mi do re | mi sol re sol | do,2. do4 |
  \break
  fa2. fa8 fa | la 4 la2 la4 | sol4. sol8 mi4 do | re2. do8 re | mi4 sol sol4. la8 |
  \break
  sol4 mi do re | mi sol re sol | do,2. do8 re | mi4 sol sol4. la8 | sol4 mi2 do8 re |
  \break
  mi4 sol mi8 re do4 | re2. do8 re | mi4 sol do la | sol mi do re |
  \break
  mi sol re sol | do,2. do8 re | mi4 sol sol4. la8 | sol4 mi2 do4 | mi2 mi8 re do4 |
  \break
  re2. do8 re | mi4 sol do la | sol mi do re | mi sol re sol | do,2. do4 |
  \break
  fa2. fa8 fa | la4 la2 la4 | sol4. sol8 mi4 do | re2. do8 re | mi4 sol sol4. la8 |
  \break
  sol4 mi 
  
  % rall. = rallentado = ralentir progressivement dans le tempo
  %\mark \markup { \italic "rall." }
      
  % Début du rallentando avec ligne
  \once \override TextSpanner.bound-details.left.text =
    \markup { \italic "rall.  " }
  \once \override TextSpanner.dash-fraction = #0.2
  \once \override TextSpanner.dash-period = #2.5
 
  do\startTextSpan re | mi sol re sol | do,1\stopTextSpan
  
  \bar "|."
}

%{
\addlyrics {
      % Couplet 1
      I come from Al -- a -- ba -- ma with my ban -- jo on my knee, 
      I'm go -- ing to Lou -- i -- si -- a -- na my true love for to see. 
      It rained all night the day I left, the wea -- ther it was dry. 
      The sun so hot I froze to death, Su -- san -- na don't you cry.

      % Couplet 2
      I had a dream the o -- ther night, when eve -- ry thing was still, 
      I thought I saw Su -- san -- na dear a -- com -- ing down the hill. 
      A buck -- wheat cake was in her mouth, a tear was in her eye. 
      Says I, "I'm com -- ing from the South, Su -- san -- na don't you cry."
}
%}

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
    \tempo 4 = 150
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))
