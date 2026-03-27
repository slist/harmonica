\version "2.24.3"

\header {
  title = "Cartographie de l'Harmonica en Do (C)"
  subtitle = "Étude complète des notes" % et altérations"
  opus = "Op. 1"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en C"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

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
  do mi sol do mi sol do mi sol do
  \break
  
  \sectionTitle "Notes aspirées de 1 à 10"
  re,,, sol si re fa la si re fa la  
  \break

  \sectionTitle "Altérations"
  % TODO
  
  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  Do Mi Sol Do Mi Sol Do Mi Sol Do
  "Ré" Sol Si "Ré" Fa La Si "Ré" Fa La
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
    \tempo 4 = 100
  }
}

\diatoniqueScore
\midiScore
