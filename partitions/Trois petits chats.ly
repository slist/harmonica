\version "2.24.3"

\header {
  title = "Trois petits chats"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain" % Chanson traditionnelle française
  tagline = ##f
}

%Source: https://fr.wikipedia.org/wiki/Trois_Petits_Chats

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 2/4
  \key f \major  % Définit l'armure avec si♭
  
  r4 d8 e | f4 e8 f | d4 f8 g | a4 a | a
  \break
  a8 bes | a g g a | g f f g | f4 e | d r4 |
  \break

  r4 d8 e | f4 e8 f | d4 f8 g | a4 a | a
  \break
  a8 bes | a g g a | g f f g | f4 e | d r4 |
  \break

  \bar ":|."
}
\addlyrics {
  Trois p'tits chats, trois p'tits chats, trois p'tits chats, chats chats,
  Cha -- peau d'pail -- le, cha -- peau d'pail -- le, cha -- peau d'paille, paille, paille, 
  Pail -- las -- son, pail -- las -- son, pail -- las -- son, son, son,
  Som -- nam -- bu -- le, som -- nam -- bu -- le, som -- nam -- bule, bule, bule...
}

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
    \tempo 4 = 90
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))
