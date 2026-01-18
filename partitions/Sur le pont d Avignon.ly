\version "2.24.3"

\header {
  title = "Sur le pont d'avignon"
  %instrument = "Harmonica en C"
  %composer = "Anonyme"
  %date = ""
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain" % Chanson traditionnelle française
  tagline = ##f
}


%Source: https://www.rhapsody.fr/wp-content/uploads/2021/08/Anonyme-Au-Clair-de-la-Lune-1.pdf


\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 2/4
  \tempo 4 = 80

  %\clef "treble_8" % "treble^8" "treble_8"
  \key f \major  % Définit l'armure avec si♭
  %\key d \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key g \major % Tonalité de Sol majeur (fa♯)
  
  f8 f f4 | g8 g g4 | a8 bes c f,
  %\break
  e f g c, | f f f4 | g8 g g4 |
  %\break
  a8 bes c f, | g e f4\fermata | 
  \tuplet 3/2 {f8 f f} f f g4 f\fermata
  f8 f f f | g4 f\fermata
  \bar ":|."
}
\addlyrics {
  Sur le pont d'A -- vi -- gnon, on y dan -- se, on y dan -- se,
  sur le pont d'A -- vi -- gnon, on y dan -- se tous en rond.
  Les bel -- les dames font comme ça, et puis en -- core comme ça.
}

% Les beaux Messieurs font comme ça
% Et puis encore comme ça

%Some words may need explanation - a bobtail nag is a horse that has had its tail 'docked' (cut short) and a 'bay' is a brown horse with a black mane and tail.

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c' {
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
      \chromaticHarmonicaTab \relative c' {
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
    \relative c' {
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

