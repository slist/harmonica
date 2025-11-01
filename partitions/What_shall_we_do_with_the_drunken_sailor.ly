\version "2.24.3"

\header {
  title = "What shall we do with the drunken sailor"
  composer = ""
  date = ""
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
  %\tempo 4 = 100
  %\tempo "Moderately" % 4=100
  %\tempo "Moderately" 4=100
  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key g \major % Sol majeur (un dièse : fa♯)
  %\key d \major % Ré majeur (fa♯, do♯)
  \key sib \major  % Si♭ (Si♭, Mi♭)
  %\key es \major % Mi♭ majeur contient 3 bémols : Si♭ (B♭), Mi♭ (E♭), et La♭ (A♭).
  
  sol4 sol8 sol sol4 sol8 sol sol4 do, mib sol 
  \break
  fa fa8 fa fa4 fa8 fa fa4 sib, re fa
  \break
  sol4 sol8 sol sol4 sol8 sol sol4 la sib do
  \break
  sib sol fa re do2 do 
  \break
  sol' sol4. sol8 sol4 do, mib sol
  \break
  fa2 fa4. fa8 fa4 sib, re fa
  %\break
  \break
  sol2 sol4. sol8 sol4 la sib do
  \break
  sib sol fa re do2 do
  %r2 re4 re | sol8 sol4. sol4. sol8 | mi4 re si re sol1 ~ 
  %\break
  %sol4 r sol la | si8 si4. si4. si8 | re4 si la sol | la1 ~
  %\break
  %la4 r re do | si8 si4. si4. si8 | la4 sol sol sol | mi8 mi4. mi4. mi8 |
  %\break
  %la4 sol fad mi | re8 re4. sol4 la | si la mi fad | sol1 ~ | sol4 r2.
  
  %mi2 mi4 | si'4 si si | fad4. sol8 fad4 | mi2. | si'2 re4 |
  %\break
  %mi2 re4 | si4 dod la | si2 si4 mi2 mi4 | re2 si4 |
  %\break
  
  % Les liaisons de prolongation (~) ne peuvent être utilisées qu'entre des notes de même hauteur.
  
  % Liaison d'articulation (phrasé ou legato). Pour lier des notes de hauteurs différentes.
  % Mettre la deuxième note entre parenthèses.
  
  %si la sol | fad8  ( re4. ) re4 | mi2 si'4 | la2 sol4 fad mi re | mi2.
 
  \bar "|."
}
%%{
\addlyrics {
  What shall we do with the drun -- ken sai -- lor,
  what shall we do with the drun -- ken sai -- lor, 
  what shall we do with the drun -- ken sai -- lor ear -- ly in the mor -- ning,
  Hoo -- ray and up she ri -- ses, hoo -- ray and up she ri -- ses, hoo -- ray and up she ri -- ses ear -- ly in the mor -- ning.
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

