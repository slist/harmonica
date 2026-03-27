\version "2.24.3"

\header {
  title = "Dirty old town"
  composer = "Ewan MacColl (1915-1989)"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  tagline = ##f
}

% From: https://musescore.com/user/28111512/scores/6520909

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodieD = {
  \time 4/4
  \tempo "swing" 4 = 120
  \key re \major % Ré majeur (fa♯, do♯)
  
  r4 ^\markup \box { \italic "Harmonica Diatonique en D" }
  la4 re mi | fad1 | r4 re8 mi fad4 re | la1 | r2 fad'4 la
  \break
  si1 | r4 la8 fad mi4. re8 | fad1 | r2 la,8 re fad4
  \break
  mi1~ | mi | re |
}
\addlyrics {
  I found my love by the gas -- works croft,
  Dreamed a dream by the old ca -- nal,
  Kissed my girl by the fac -- to -- ry wall,
  Dir -- ty old town, dir -- ty old town.
}
melodieG = {
  \time 4/4  
  \key sol \major % Sol majeur (un dièse : fa♯)
  
  r4 ^\markup \box { \italic "Harmonica Diatonique en G" }
  
  re4 sol8 la4 si8~ \bar "||"
  \break
  si1 | r4 sol4 si8 sol4 re8~ | re1 | r2 si'4 re
  \break
  mi1 | r4 re8 si la4. sol8 | si1 | r4 si4 mi8 re4 si8~ |
  \break
  si1 | r4 sol4 si sol8 re~ | re1 | r2 mi8 sol si4 |
  \break
  la1 | r2 la8 sol mi4 | mi1 |
  \bar "|."
}
\addlyrics {
  I found my love by the gas -- works croft,
  Dreamed a dream by the old ca -- nal,
  Kissed my girl by the fac -- to -- ry wall,
  Dir -- ty old town, dir -- ty old town.
  I heard a si -- ren from the docks,
  Saw a train set the night on fire,
  Smelled the spring on the smo -- ky wind,
  Dir -- ty old town, dir -- ty old town.
  Clouds are drif -- ting a -- cross the moon,
  Cats are prowl -- ing up -- on their beat,
  Spring's a girl in the streets at night,
  Dir -- ty old town, dir -- ty old town.
  I'm gon -- na make a good sharp axe,
  Shi -- ning steel tem -- pered in the fire,
  We'll chop you down like an old dead tree,
  Dir -- ty old town, dir -- ty old town.
}

melodieChromatique = {
  \time 4/4
  \tempo "swing" 4 = 120

  \key re \major % Ré majeur (fa♯, do♯)
  
  r4  
  la4 re mi | fad1 | r4 re8 mi fad4 re | la1 | r2 fad'4 la
  \break
  si1 | r4 la8 fad mi4. re8 | fad1 | r2 la,8 re fad4
  \break
  mi1~ | mi | re |
  
  r4
  re,4 sol8 la4 si8~ \bar "||"
  \break
  si1 | r4 sol4 si8 sol4 re8~ | re1 | r2 si'4 re
  \break
  mi1 | r4 re8 si la4. sol8 | si1 | r4 si4 mi8 re4 si8~ |
  \break
  si1 | r4 sol4 si sol8 re~ | re1 | r2 mi8 sol si4 |
  \break
  la1 | r2 la8 sol mi4 | mi1 |
  \bar "|."
}
\addlyrics {
  I found my love by the gas -- works croft,
  Dreamed a dream by the old ca -- nal,
  Kissed my girl by the fac -- to -- ry wall,
  Dir -- ty old town, dir -- ty old town.
  I heard a si -- ren from the docks,
  Saw a train set the night on fire,
  Smelled the spring on the smo -- ky wind,
  Dir -- ty old town, dir -- ty old town.
  Clouds are drif -- ting a -- cross the moon,
  Cats are prowl -- ing up -- on their beat,
  Spring's a girl in the streets at night,
  Dir -- ty old town, dir -- ty old town.
  I'm gon -- na make a good sharp axe,
  Shi -- ning steel tem -- pered in the fire,
  We'll chop you down like an old dead tree,
  Dir -- ty old town, dir -- ty old town.
}

diatoniqueScore =
\score {
  <<
    \new Staff {
      \diatonicDHarmonicaTab \relative do'' {
        \melodieD
      }
      \break
      \diatonicGHarmonicaTab \relative do'' {
        \melodieG
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
        \melodieChromatique
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
      \melodieChromatique
    }
  }
  \midi {
    \tempo 4 = 50
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
%\diatoniqueDScore
%\diatoniqueGScore
%\chromatiqueScore
%\midiScore