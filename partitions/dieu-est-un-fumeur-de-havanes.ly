\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Dieu est un fumeur de Havanes"
  composer = "Serge Gainsbourg (1928-1991)"
  lyricsLang = #'(fr)
  copyrightStatus = "copyrighted"
  tagline = ##f
  composerNationality = "fr"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

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
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  \time 4/4
  \tempo 4 = 80
  %\clef "treble^8"
  sol8 sol sol sol la4 sol8 la | si8 re4. r2 | mi8 mi sol mi re do4. | re2 r2 |
  \break
  mi8 mi sol mi re do4. | si8 la4 sol2 r8 | la8 si la si la si4.
  \break
  \bar "|."
}
\addlyrics {
  Dieu est un fu -- meur de Ha -- va -- nes, je vois ses nu -- a -- ges gris
  Je sais qu'il fu -- me mê -- me la nuit, com -- me moi, ma ché -- rie.

  Tu n'es qu'un fumeur de gitanes, je vois tes volutes bleues
  Me faire parfois venir les larmes aux yeux
  Tu es mon maître après Dieu

  Dieu est un fumeur de havanes, c'est lui-même qui m'a dit
  Que la fumée envoie au paradis, je le sais, ma chérie

  Tu n'es qu'un fumeur de gitanes, sans elles, tu es malheureux
  Au clair de ma lune, ouvre les yeux, pour l'amour de Dieu

  Dieu est un fumeur de havanes, tout près de toi, loin de lui
  J'aimerais te garder toute ma vie, comprends-moi, ma chérie

  Tu n'es qu'un fumeur de gitanes et la dernière, je veux
  La voir briller au fond de mes yeux, aime-moi, nom de Dieu

  Dieu est un fumeur de havanes, tout près de toi, loin de lui
  J'aimerais te garder toute ma vie, comprends-moi, ma chérie

  Tu n'es qu'un fumeur de gitanes et la dernière, je veux
  La voir briller au fond de mes yeux, aime-moi, nom de Dieu
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

%\diatoniqueScore
%\chromatiqueScore
%\midiScore
