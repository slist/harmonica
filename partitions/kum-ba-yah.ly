\version "2.24.3"

\header {
  title = "Kum ba yah"
  composer = ""
  date = ""
  tagline = ##f
  composerNationality = "us"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 3/4
  \tempo 4 = 105
  \key mi \major % fa♯, do♯, sol♯, ré♯
  
  r2 mi8 sold | si8. si16 si4 dod8 dod8 | si2
  \break
  mi,8 sold | si8. si16 si4 la8 sold8 | fad2
  \break
  mi8 sold | si8. si16 si4 dod8 dod8 | si2 
  \break
  la4 | sold8 (mi4.) fad8 fad | mi2
  
  % Les liaisons de prolongation (~) ne peuvent être utilisées qu'entre des notes de même hauteur.
  
  % Liaison d'articulation (phrasé ou legato). Pour lier des notes de hauteurs différentes.
  % Mettre la deuxième note entre parenthèses.
   
  \bar "|."
}
%%{
\addlyrics {
  "Kum" ba yah, my Lord, kum ba yah! 
  Kum ba yah, my Lord, kum ba yah! 
  Kum ba yah, my Lord, kum ba yah! 
  Oh, Lord,........ kum ba yah!
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
    \relative do'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 105
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

