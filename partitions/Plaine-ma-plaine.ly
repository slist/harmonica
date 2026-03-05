\version "2.24.3"

\header {
  title = "Plaine, ma plaine"
  subtitle = "Polyushka Polye from Symphony No.4 in D Major, Op.41"
  composer = "Lev Knipper (Dec 3, 1898 - Jul 30, 1974)"
  lyricsLang = #'(fr)
  copyrightStatus = "copyrighted"
  date = "1934"
  tagline = ##f
}

%Source: harmonica12.fr
% Chant soviétique populaire dont le titre original est : "Polyushko Pole")

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 125
  \key g \major  % Définit la tonalité de sol majeur (F♯ dans l'armure)
  %  \accidentalStyle modern  % Affiche les altérations de rappel
  c2 a4 c4 b2 e,
  c'8 b a g a4 e'
  b2 e, a4 g8 f e d e f e4 b' gis e
  \break
  a g8 f e d e f e4 b'2 e4
  \bar ":|."
}
\addlyrics {
  Plai -- ne, ma plai -- ne,
  Plai -- ne, ô mon im -- mense plai -- ne
  Où traî -- ne encore le cri des loups, ou -- ou -- ou,
  Gran -- de ste -- ppe blan -- che de chez nous, ou-ou-ou.
}

%{

Source: https://fr.scoutwiki.org/Plaine,_ma_plaine

2e couplet

Plaine, ma plaine,
Dans l'immensité de neige,
Entends-tu le pas des chevaux, ô-ô-ô,
Entends-tu le bruit de ces galops, ô-ô-ô.

3e couplet

Plaine, ma plaine,
Entends-tu ces voix lointaines
Les cavaliers qui vers les champs reviennent
Sous le ciel chevauchant en chantant

4e couplet

Vent de ma plaine,
Va-t-en dire aux autres plaines,
Que le soleil et les étés reviennent
Pour tous ceux qui savent espérer

5e couplet

Plaine, ma plaine,
Sous l'épais manteau de neige
La terre enferme dans sa main la graine
Qui fait la récolte de demain

6e couplet

Plaine, ma plaine,
Vent de la plaine
Tu peux gémir avec les loups
L'espoir est à nous plus fort que tout !
}
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

%\diatoniqueScore
%\midiScore
%\chromatiqueScore