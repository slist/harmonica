\version "2.24.3"

\header {
  title = "La Marseillaise"
  composer = "Claude Joseph Rouget de Lisle (1760 - 1836)"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain" % Hymne national français
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 100

  %\clef "treble_8" % "treble^8" "treble_8"
  %\key f \major  % Définit l'armure avec si♭
  %\key d \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key g \major % Tonalité de Sol majeur (fa♯)
  \key c \major
  
  r2 r8 g8 g g | c4 c d d | g4. e8 c8. c16 e8. c16 | a4 f'2 d8. b16 |
  %\break
  c2 r4 c8. d16 | e4 e e f8. e16 | e4 d r4 d8. e16 | f4 f f g8. f16 |
  %\break
  e2 r4 g8. g16 | g4 e8. c16 g'4 e8. c16  | g2 r8 g8 g8. b16 | d2 f4 d8. b16 |
  %\break
  c2 bes | a4 c8. c16 c4 b8. c16 | d2. r8 d8 | ees4 ees4 ~ ees8 ees f g |
  %\break
  d2. ees8 d | c4. c8 c ees d c | c4 b r4 r8. g'16 | g2 r8 g8 e8. c16 |
  %\break
  d2 r4 r8. g16 | g2 r8 g8 e8. c16 | d2 r4 g,4 | c2 r4 d4 |
  %\break
  e1 | f2 g4 a | d,2 r4 a'4 g2 ~ g8. e16 f8. d16 | c1
   \bar "|."
}
\addlyrics {
  
}


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c'' {
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
      \chromaticHarmonicaTab \relative c'' {
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
    \relative c'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 100
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

