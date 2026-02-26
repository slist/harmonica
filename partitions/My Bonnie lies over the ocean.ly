\version "2.24.3"

\header {
  title = "My Bonnie lies over the ocean"
  composer = "Auteur original inconnu"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
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
  \time 3/4
  \clef "treble^8"
  \tempo 4 = 125
  \key la \major % fa♯, do♯, sol♯
  \partial 4 % anacrouse
  mi4 | dod' si la | si la fad | mi dod2 | r2 mi4 | dod' si la |
  \break
  la sold la | si2. | r2 mi,4 | dod' si la | si la fad | mi dod2 |
  \break
  r2 mi4 | fad si la | sold fad sold | la2.~ | la2. | mi2. | la2. |
  \break
  fad2. | si2 la4 | sold sold sold | sold fad sold | la2 si4 | dod2. | mi,2. |
  \break
  la2. | fad2. | si2 la4 | sold sold sold | sold fad sold  | la2.~ | la4 r2 |
  \bar "|."
}
\addlyrics {
  My Bon -- nie lies o -- ver the o -- cean, my Bon -- nie lies o -- ver the sea,
  My Bon -- nie lies o -- ver the o -- cean, please bring back my Bon -- nie to me.
  Bring back, bring back, oh, bring back my Bon -- nie to me, to me.
  Bring back, bring back, oh, bring back my Bon -- nie to me, to me.
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
    \tempo 4 = 125
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
