\version "2.24.3"

\header {
  title = "Jingle Bells - Vive le vent"
  composer = "James Lord Pierpont (1822-1893)" % Apr 25, 1822 - Aug 5, 1893
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  tagline = ##f
}

%{
Source: 
https://riffspot.com/music/jingle-bells-harmonica/1998/
https://www.youtube.com/watch?v=y6DscttUCgI

Jingle Bells est un chant de Noël  traditionnel américain, plus connu en France sous le titre Vive le vent. Les débutants pourrons jouer la partie A la répéter à la place de la partie B et les joueurs intermédiaires la partie A et B qui utilise l’altération d’un Ton du 3.
Source, partition/Tab : https://tinyurl.com/52u6d8aw
%}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo "Moderately" 4 = 110
  
  g8 e' d c g4 r8 g16 g g8 e' d c a4 r4
  \break
  a8 f' e d b4 r4 g'8 g f d e4 r4
  \break
  g,8 e' d c g4 r4 g8 e' d c a4 r8 a8
  \break
  a f' e d g g g g a g f d c4. r8
  \break
  e e e4 e8 e e4 e8 g c,8. d16 e4. r8
  \break
  f8 f f8. f16 f8 e e e16 e e8 d d e d4 g
  \break
  e8 e8 e4 e8 e e4 e8 g c,8. d16 e2
  \break
  f8 f f8. f16 f8 e e e16 e g8 g f d c2
  \bar "|."
}
\addlyrics {
  Dash -- ing through the snow In a one -- horse o -- pen sleigh,
  O'er the fields we go, Laugh -- ing all the way.
  Bells on bob -- tail ring Mak -- ing spir -- its bright What
  fun it is to ride and sing a sleigh -- ing song to -- night
  Jin -- gle bells, jin -- gle bells Jingle -- gle all the way,
  Oh what fun it is to ride in a one -- horse o -- pen sleigh, O
  Jin -- gle bells, jin -- gle bells Jingle -- gle all the way,
  Oh what fun it is to ride in a one -- horse o -- pen sleigh.
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
    \tempo 4 = 110
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))
