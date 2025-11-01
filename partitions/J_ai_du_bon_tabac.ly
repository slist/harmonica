\version "2.24.3"

\header {
  title = "J'ai du bon tabac"
  composer = "Gabriel-Charles de Latteignant (Abbé)"
  date = "1697-1779"
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
  \time 2/4
  \tempo 4 = 120
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
  
  %\key fa \major  % Si♭
  %\key sib \major % Si♭, Mi♭
  
  fa8 sol la fa | sol4 sol8 la | sib4 sib4 | la la | fa8 sol la fa | 
  sol4 sol8 la | sib4 do | fa,2 | do'4 do8 sib | la4 sol8 la | sib4 do |
  sol2 | do4 do8 sib | la4 sol8 la | sib4 do | sol2 |
  fa8 sol la fa | sol4 sol8 la | sib4 sib4 | la la | fa8 sol la fa | 
  sol4 sol8 la | sib4 do | fa,2 
  \bar "|."
}
\addlyrics {
  J'ai du bon ta -- bac dans ma ta -- ba -- tière -- re.
  J'ai du bon ta -- bac, tu n'en au ras pas. 
  
  J'en ai du fin et du bien râ -- pé.
  Mais ce n'est pas pour ton vi -- lain nez.
  
  J'ai du bon ta -- bac dans ma ta -- ba -- tière -- re.
  J'ai du bon ta -- bac, tu n'en au ras pas. 
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \transpose fa sol \relative do'' {
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
      \chromaticHarmonicaTab \transpose fa sol \relative do' {
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
    \transpose fa sol \relative do' {
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

