\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Bilitis"
  composer = "Francis Lai (1932-2018)"
  copyrightStatus = "copyrighted"
  tagline = ##f
  composerNationality = "fr"
}

% From https://musescore.com/user/62893/scores/2659406

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  \time 4/4
  \tempo 4 = 80
  %\clef "treble^8"
  
  r4 mi8 fa sol4 mi' | la,1 | r8 la la si si do do re | sol,1 | 
  \break
  r8 sol sol la la si si do | fa,1 | r8 fa fa sol sol la la si | mi,1 |
  \break
  r4 mi8 fa sol4 mi' | fa,1 | r8 la la si si do do re | sol,1 |
  \break
  r4 mi8 fa sol4 mi'
  \repeat volta 2
  { la,1 | r8 la la si si do do re | sol,1
    \break
    r8 sol sol la la si si do | fa,1 | r8 fa fa sol sol la la si |
    \alternative {
      {
        mi,1
        \break
        r4 mi8 fa sol4 mi'  % cas 1
      }
      {
        do1   % cas 2
      }
    }
    <do mi sol do>1-^-.\arpeggio
    ^\markup { \hspace #2 \italic "arpeggio" }
  }
  r8 sol sol la la si si do |
  \break
  do1 | r8 la la si si do do re | re1 | mi8 fa sol4~ sol8 fa mi sol |
  \break
  fa la,~ la2. | re8 mi fa4~ fa8 mi re fa | mi sol,~ sol2. | la8 si do4~ do8 si do mi |
  \break
  re8 la4. si8 do mi re | la2~ la8 fa sol la | la1
  \bar "|."
}
\addlyrics {
  % Bilitis, Bilitis, what a beautiful name!
  % Bilitis, Bilitis, what a beautiful name!
}


accords = \chordmode {
  % fa1 s re:m s
  % do s fa2 do2 fa4
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
    \new ChordNames {
      \accords
    }
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
%\chromatiqueScore
%\midiScore
