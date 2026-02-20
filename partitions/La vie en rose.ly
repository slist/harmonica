\version "2.24.3"

\header {
  title = "La vie en rose"
  composer = "Louis Guillaume Guglielmi (1916-1991)"
  poet = "Edit Piaf (1915-1963)"
  lyricsLang = #'(fr)
  %copyrightStatus = "public-domain"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\layout {
  \context {
    \Lyrics
    \override LyricText.font-size = #-1
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #20 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #20 % Espace entre les portées
}

melodie = {
  \time 4/4
  \clef "treble^8"
  \tempo 4 = 82 % un tempo lent, « andante » typique d’une ballade française.

  
  % From https://musescore.com/user/17341981/scores/5938838
  
  fa'4. mi8 re do la fa' | mi4. re8 do la fa mi' | re4.
  %\break
  do8 la mi fa mi' | re2 do |
  %\break
  sol'4. fa8 mi re lad fa' | mi4. re8 do lad sol mi' | re4.
  %\break
  do8 lad fad sol mi' | re2 do |
  %\break
  fa4. mi8 re do la fa' | mi4. re8 do la fa mi' | re4. do8 la mi fa fa' | fa2 fa |
  %\break
  sol8 sol4 fa8 sol sol4 fa8 | sol sol4 fa8 do2 |
  %\break
  sol'8 sol4 fa8 sol sol4 fa8 | sol sol4 fa8 la4 sol |
  %\break
  fa4. mi8 re do la fa' | mi4. re8 do la fa mi' | re4. do8 re4 mi | fa1 | r1

  \bar "|."
}
\addlyrics {
   Quand il me prends dans ses bras, qu'il me par -- le tout bas, je vois la vie en ro -- se.
   Quand il dit des mots d'a -- mour, des mots de tous les jours, ça me fait quel -- que cho -- se.
   Il est en -- tré dans mon coeur, U -- ne part de bon -- heur, dont je con -- nais la cau -- se.
   C'est lui pour moi, moi pour lui dans la vie.
   Il me l'a dit, l'a ju -- ré pour la vi -- e.
   Et dès que je l'a -- per -- çois, a -- lors je sens en moi, mon coeur qui bat.
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
      \diatonicHarmonicaTab \relative do''' {
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
    \tempo 4 = 82
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
