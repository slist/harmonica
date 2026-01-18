\version "2.24.3"

\header {
  title = "Greensleeves"
  %instrument = "Harmonica en C"
  %composer = "Anonyme"
  %date = ""
  lyricsLang = #'(en)
  copyrightStatus = "public-domain" % Chanson traditionnelle anglaise (XVIe siècle)
  tagline = ##f
}

% Source: https://www.harmonica12.fr/Folkloriques/Greensleeves.pdf

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 6/8
  
  %\tempo 4 = 80
  \tempo 4. = 67

  %\clef "treble_8" % "treble^8" "treble_8"
  %\key f \major  % Définit l'armure avec si♭
  %\key d \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key g \major % Tonalité de Sol majeur (fa♯)
  \key c \major
  
  r4. r4 a8 | c4 d8 e8. f16 e8 | d4 b8 g8. a16 b8 |
  \break
  c4 a8 a8. gis16 a8 | b4 gis8 e4 a8 | c4 d8 e8. f16 e8 |
  \break
  d4 b8 g8. a16 b8 | c8. b16 a8 gis8. fis16 gis8 | a4 a8 a4 r8 |
  \break
  g'4. g8. f16 e8 | d4 b8 g8. a16 b8 | c4 a8 a8. gis16 a8 |
  \break
  b4 gis8 e4 r8 | g'4. g8. f16 e8 | d4 b8 g8. a16 b8 |
  \break
  c8. b16 a8 gis8. fis16 gis8 | a4. a4.
  
  \bar "|."
}
\addlyrics {
A -- las, my love, you do me wrong,
To cast me off dis -- cour -- teous -- ly.
For I have loved you well and long,
De -- light -- ing in your com -- pa -- ny.

Green -- sleeves was all my joy
Green -- sleeves was my de -- light,
Green -- sleeves was my heart of gold,
And who but my la -- dy Green -- sleeves.

Your vows you've broken, like my heart,
Oh, why did you so enrapture me?
Now I remain in a world apart
But my heart remains in captivity.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.

I have been ready at your hand,
To grant whatever you would crave,
I have both wagered life and land,
Your love and good-will for to have.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.

If you intend thus to disdain,
It does the more enrapture me,
And even so, I still remain
A lover in captivity.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.

My men were clothed all in green,
And they did ever wait on thee;
All this was gallant to be seen,
And yet thou wouldst not love me.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.

Thou couldst desire no earthly thing,
But still thou hadst it readily.
Thy music still to play and sing;
And yet thou wouldst not love me.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.

Well, I will pray to God on high,
That thou my constancy mayst see,
And that yet once before I die,
Thou wilt vouchsafe to love me.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.

Ah, Greensleeves, now farewell, adieu,
To God I pray to prosper thee,
For I am still thy lover true,
Come once again and love me.

Greensleeves was all my joy
Greensleeves was my delight,
Greensleeves was my heart of gold,
And who but my lady Greensleeves.
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
    \tempo 4. = 67
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

