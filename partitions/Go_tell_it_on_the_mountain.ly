\version "2.24.4"

\header {
  title = "Go, tell it on the mountain"
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
  
  % EN
  %\key g \major % Sol majeur (un dièse : fa♯)
  %\key es \major % Mi♭ majeur contient 3 bémols : Si♭ (B♭), Mi♭ (E♭), et La♭ (A♭).
  
  % FR
  \key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  %\key fa \major  % Si♭
  %\key sib \major % Si♭, Mi♭
  
  si2 si8. la16 sol8. mi16 | re2 sol | la8 la4 sol8 la4 sol8 (la) | si4 sol mi8 (re4.) |
  \break
  si'2 si8. la16 sol8. mi16 | re2 sol4 do | si8 si4. la4 la | sol2. 
  \break
  re4 | la'2 sol4 la4 | si8 sol4. r4 re4 |la'4. la8 sol4 la4 | si (re) r4 
  \break
  re,4 | la'4. la8 sol4 la4 | si8 sol4. r4 do4 | si4. sol8 la4. fad8 | sol1
    
  
  %\break
  %mi8 mi4 mi8 | fad4 la | dod dod~ | dod2 |
  %\break
  %mi,8 mi4 mi8 | fad4 la | si2~ | si |
  %\break
  %mi,8 mi4 mi8 | fad4 la | si si~ | si2 |
  %\break
  %si8 si4 dod8 | la4 fad | la2
  
  
  %r2 mi8 sold | si8. si16 si4 dod8 dod8 | si2
  
  %\break
  
  %mi,8 sold | si8. si16 si4 la8 sold8 | fad2
  
  %\break
  
  %mi8 sold | si8. si16 si4 dod8 dod8 | si2 
  
  %\break
  
  %la4 | sold8 (mi4.) fad8 fad | mi2
  
  %\break
  
  %fad2 re la4 re2. fad2 re mi4 mi2.
  %\break
  %fad2 re sol4 sol2 sol4 fad8 fad fad4 mi mi re1
  %\break
  %fad4 mi re mi fad fad fad2 mi4 mi mi2 fad4 la la2
  %\break
  %fad4 mi re mi fad fad fad2 mi4 mi fad mi re2
  %sol4 sol8 sol sol4 sol8 sol sol4 do, mib sol 
  %\break
  %fa fa8 fa fa4 fa8 fa fa4 sib, re fa
  %\break
  %sol4 sol8 sol sol4 sol8 sol sol4 la sib do
  %\break
  %sib sol fa re do2 do 
  %\break
  %sol' sol4. sol8 sol4 do, mib sol
  %\break
  %fa2 fa4. fa8 fa4 sib, re fa
  %\break
  %\break
  %sol2 sol4. sol8 sol4 la sib do
  %\break
  %sib sol fa re do2 do
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
  Go, tell it on the moun -- tain o -- ver the hills and..... ev' -- ry -- where.....
  Go, tell it on the moun -- tain that Je -- sus Christ is born.
  When I was a see -- ker I sought both night and day......
  I asked the Lord to help me and He showed me the way.
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
    \tempo 4 = 120
  }
}

% ============================
% COMPILATION SÉPARÉE
% ============================

% Pour générer la version diatonique :
% lilypond -dcompile-diatonique <fichier.ly>

% Pour générer la version chromatique :
% lilypond -dcompile-chromatique <fichier.ly>

% Pour générer le fichier midi :
% lilypond --formats=midi -dcompile-midi <fichier.ly>

% Inclusion conditionnelle des scores

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

