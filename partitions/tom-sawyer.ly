\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Tom Sawyer"
  composer = "Geddy Lee (1953–), Alex Lifeson (1953–)"
  poet = "Neil Peart (1952–2020), Pye Dubois (1947–)"
  lyricsLang = #'(fr)
  copyrightStatus = "copyrighted"
  tagline = ##f
  composerNationality = "ca"
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
  \tempo 4 = 100
  \clef "treble^8"
  si'4 sol re'2 | mi4 mi8. mi16  re8 si~ si sol |
  \break
  mi'4 mi8. mi16 re8 si la sol | la2 r4 si8 do |
  \break
  re4 re8. re16 do8 si la sol | mi sol~ sol mi re4 sol8 la |
  \break
  si8 re~ re re, si' si la la | sol2 r2
  \bar "|."
}
\addlyrics {
  Tom Saw -- yer, c'est l'A -- mé -- ri -- que, le sym -- bo -- le de la li -- ber -- té.
  Il est né sur les bords du fleu -- ve Mi -- ssi -- ssi -- pi
  Tom Saw -- yer, c'est pour nous tous un a -- mi.
  
  Il est toujours près pour tenter l’aventure
  Avec ses bons copains
  Il n’a peur de rien, c’est un américain
  Il aime l’école, surtout quand elle est loin

  Tom Sawyer, c’est l’Amérique, le symbole de la liberté
  Il est né sur les bords du fleuve Mississipi
  Tom Sawyer c’est pour nous tous un ami

  Tom Sawyer, c’est l’Amérique,
  pour tous ceux qui aime la vérité
  Il connaît les merveilles qui sont dans la forêt
  Les chemins, les rivières et les sentiers

  Il a dans ses poches des objets fabuleux
  Qu’il empote avec lui
  Trois bouts de ficelle, quelques pierres et du bois
  Il les partage avec tous ses amis

  Tom Sawyer, c’est l’Amérique
  Pour tous ceux qui aime la liberté
  Il est né sur les bords du fleuve Mississipi
  Tom Sawyer c’est pour nous tous un ami
  Il est né sur les bords du fleuve Mississipi
  Tom Sawyer c’est pour nous tous un ami
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
