\version "2.24.3"

\header {
  title = "Head, shoulders, Knees and toes"
  instrument = "Harmonica en C"
  composer = "Gilbert DeBenedetti (1946-)"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  tagline = ##f
}

%Source: https://itsybitsykidsmusic.com/head-shoulders-knees-and-toes/

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \key bes \major % Tonalité de Si bémol majeur (qui inclut si (b) bémol et mi(e) bémol)
  \time 4/4
  \clef "treble^8" % "treble_8"
  \tempo 4 = 90
  f4. f8 g f e8 f d4 f8 f f2
  f4. f8 g f e8 f c4 f8 f f ees d c bes4 d f bes
  c8 bes a bes g2
  a4. a8 a f g a bes4 bes,8 bes bes2
  

  \bar "|."
}
\addlyrics {
  Head and shoul -- ders, knees and toes, knees and toes.
  Head and shoul -- ders, knees and toes, knees and to -- es
  a -- nd eyes and ears and mou -- th a -- nd nose.
  Head and should -- ers knees and toes, knees and toes.
}

%{
  6     -6   6     -5    6   5      6    6   6
Head, shoulders, knees and toes, knees and toes
 6     -6   6     -5    6   -4      6    6   6
Head, shoulders, knees and toes, knees and toes
-5  5  -4 4    5   6    7    -8  -7   -6 
   and   eyes and ears and mouth and nose.
-7     -7   6     -6   -7  7      4    4   4
Head, shoulders knees and toes, knees and toes

Chromatic
Song: 	
 7     7 -8      -9   -8   7
Head, shoulders knees and toes, 

 -7    -7  -7    <-6  6    -5
knees and toes, knees and toes

 7    7 -8      -9   -8   7
Head shoulders knees and toes, 

-7     -5    7    7    7
eyes, ears  mouth and nose


HEAD SHOULDERS KNEES AND TOES
A#
head shoulders knees and toes (knees and toes)
F
head shoulders knees and toes (knees and toes)
A# A#7 D# A7
eyes and ears and mouth and nose
F F7 A# D# A# C
head shoulders knees and toes (knees and toes)
thumb fingers back and chin (back and chin)
G
thumb fingers back and chin (back and chin)
C C7 F B7
foot and ankle and heel and shin
G G7 C F C D
thumb fingers back and chin (back and chin)
chest booty thighs and waist (thighs and waist)
A
chest booty thighs and waist (thighs and waist)
D D7 G C#7
ears and eyes and hair and face
A A7 D G D E
chest booty thighs and waist (thighs and waist)
hands belly cheeks and hips (cheeks and hips)
B
hands belly cheeks and hips (cheeks and hips)
E E7 A D#7
wrist and arms and elbows and lips
B B7 E A E F#
hands belly cheeks and hips (cheeks and hips)
head shoulders knees and toes (knees and toes)
C#
head shoulders knees and toes (knees and toes)
F# F#7 B F7
eyes and ears and mouth and nose
C# C#7 F# B F#
head shoulders knees and toes (knees and toes)

%}


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
    \tempo 4 = 90
  }
}

% ============================
% COMPILATION SÉPARÉE
% ============================

% Pour générer la version diatonique :
% lilypond -dcompile-diatonique <fichier.ly>

% Pour générer la version chromatique :
% lilypond -dcompile-chromatique <fichier.ly>

% Pour générer le fichier midi :
% lilypond --formats=midi -dcompile-midi <fichier.ly>

% Inclusion conditionnelle des scores

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

