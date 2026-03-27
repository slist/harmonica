\version "2.24.3"

\header {
  title = "Cartographie de l'Harmonica en Sol (G)"
  subtitle = "Étude complète des notes et altérations"
  opus = "Op. 1"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en G"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\layout {
  \context {
    \Lyrics
    %\override LyricText.font-size = #-1
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #30 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #30 % Espace entre les portées
}

melodie = {
  \clef "treble^8"
  
  \sectionTitle "Notes soufflées de 1 à 10 (-2 = +3)"
  g b d g b d g b d g
  \break
  
  \sectionTitle "Notes aspirées de 1 à 10"
  a,,, d fis a c e fis a c e  
  \break

  \sectionTitle "Altérations"
  aes,,, des c f e ees aes ees' bes' des fis f   
  
  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  G B D G B D G B D G
  A D F♯ A C E F♯ A C E
  A♭ D♭ C F E E♭ A♭ E♭ B♭ D♭ F♯ F
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicGHarmonicaTab \relative c'' {
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
    \tempo 4 = 108
  }
}

\diatoniqueScore
\midiScore

% ============================
% HISTOIRE DU BÉMOL
% ============================

\markup {
  \column {
    \vspace #3  % Un peu d'espace après la musique
    \draw-hline % Une ligne horizontale pour séparer
    \vspace #1
    \fill-line { \bold \fontsize #2 "Le saviez-vous ? L'origine du Bémol" }
    \vspace #1
    \justify {
      Le symbole du bémol (\flat) trouve son origine au Moyen \concat { Âge. }
      À cette époque, pour différencier les deux types de "Si", on utilisait 
      deux écritures distinctes :
    }
    \vspace #0.5
    \line { 
      • Le \bold "b carré" \italic "(b quadratum)" pour le Si naturel, qui a donné 
      naissance au \bold "bécarre" (\natural) et au \bold "dièse" (\sharp). 
    }
    \vspace #0.5
    \line { 
      • Le \bold "b rond" \italic "(b molle)" pour le Si bémol, qui a donné notre 
      \bold "bémol" (\flat) et le mot lui-même : "B-molle" (le B mou).
    }
    \vspace #1
    \italic \fill-line { "" "— Tiré de l'histoire de la notation musicale —" }
  }
}
