\version "2.24.3"
\header {
  title = "House of the Rising Sun"
  subtitle = "Les portes du pénitencier"
  composer = "The Animals"
  arranger = ""
  lyricsLang = #'(fr)
  copyrightStatus = "copyrighted"
  tagline = ##f
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \tempo 4 = 88
  \time 3/4

  %r2 r8
  \partial 8 % anacrouse
  mi8 | la2~ la8 si | do2~ do8 mi | re4 la2 | la2~ la8 la' |
  \break
  la2 la8 la | sol2 mi8 re | mi2.~ mi4 r4 r8 
  \break
  la8 |
  la2~ la8 la | sol2~ sol8 mi | re4 la2 | la~ 
  la8 la8 | la2 la8 la | sold4 mi4~ mi8 sold8 | la2.
  \bar "|."  

}
\addlyrics {
  Les por -- tes du pé -- ni -- ten -- ci -- er
  Bien -- tôt vont se re -- fer -- mer
  Et c'est là que je finirai ma vie
  Com -- me d'au -- tres gars l'ont fi -- nie.
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

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
\chromatiqueScore
\midiScore
