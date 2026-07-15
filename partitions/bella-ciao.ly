\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Bella ciao"
  subtitle = "Musique traditionnelle d'un chant de révolte italien"
  %composer = ""
  %arranger = ""

  lyricsLang = #'(it)
  %copyrightStatus = "copyrighted"
  copyrightStatus = "public-domain"
  composerNationality = "IT"
  %instrument = "Harmonica"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib)
  %\key sol \major % Tonalité de Sol majeur (fa♯)
  \time 4/4
  %\tempo "Andantino rubato" 4 = 80
  \tempo 4 = 96
  %\clef "treble^8"
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  r2 r8 
  % ou \partial 4.
  mi,8 la si | \repeat volta 2 {
    do8 la r4 r8 mi8 la8 si | do la r4 r8 mi8 la8 si8 |
    \break
    do4 si8 la do4 si8 la | mi'4 mi mi8 mi re mi | fa8 fa4 r4 fa8 mi re |
    \break
    fa8 mi4 r4 mi8 re do | si4 mi do si | la4. r4 mi8 la si |
  }
  \break
  do8 la r4 r8 mi8 la8 si | do8 la r4 r8 mi8 la8 si | do4 si8 la do4 si8 la8 |
  \break
  mi'4 mi mi8 mi re mi | fa8 la r4 r8 la8 sol fa | la mi r4 r8 mi8 re do |
  \break
  si4 mi do si | la2. r4
  \bar "|."
}
\addlyrics {
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
      %\set Staff.instrumentName = "Harmonica en C"
      \diatonicHarmonicaTab \relative do'' {
        \melodie
      }
    }
  >>
  \layout {
    %indent = 2.5\cm
  }
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
    \tempo 4 = 96
  }
}

\markup {
  \vspace #2
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
