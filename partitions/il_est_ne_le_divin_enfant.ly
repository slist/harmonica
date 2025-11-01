\version "2.24.3"

\header {
  title = "Il est né le divin enfant"
  %instrument = "Harmonica en C"
  %composer = "Anonyme"
  %date = ""
  tagline = ##f
}

% Source: https://www.partitions-domaine-public.fr/pdf/533/noel-il-est-ne-le-divin-enfant.html

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \tempo 4 = 116

  %\clef "treble_8" % "treble^8" "treble_8"
  \key f \major  % Définit l'armure avec si♭
  %\key d \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key g \major % Tonalité de Sol majeur (fa♯)
  
  c4 f f a8 f | c4 f f2 | f4 f8 g a4 bes8 a | g4 f g g |
  \break
  c,4 f f a8 f | c4 f f2 |
  \break
  f4 g a bes8 a | g4 c f,2 |
  \break
  a4 bes c bes8 a | bes4 d c2 |
  \break
  a4 bes c d8 c | bes4 a a g |
  \break
  a4 bes c bes8 a | bes4 d c2 |
  \break
  a4 bes c d8 c | bes4 a g2
  \bar "|."
}
\addlyrics {
  Il est né le di -- vin en -- fant, Jou -- ez haut -- bois, ré -- son -- nez mu -- set -- "tes !"
  Il est né le di -- vin en -- fant, Chan -- tons tous son a -- vè -- ne -- "ment !"
  De -- puis plus de qua -- tre mille ans, Nous le pro -- met -- taient les pro -- phè -- tes 
  De -- puis plus de qua -- tre mille ans, Nous at -- ten -- dions cet heu -- reux temps.
  
}

%{
1. Depuis plus de quatre mille ans,
Nous le promettaient les prophètes
Depuis plus de quatre mille ans,
Nous attendions cet heureux temps.

2. Ah ! Qu'il est beau, qu'il est charmant !
Ah ! Que ses grâces sont parfaites !
Ah ! Qu'il est beau, qu'il est charmant !
Qu'il est doux ce divin enfant !

3. Une étable est son logement
Un peu de paille est sa couchette,
Une étable est son logement
Pour un dieu quel abaissement !

4. Partez, grands rois de l'Orient !
Venez vous unir à nos fêtes
Partez, grands rois de l'Orient !
Venez adorer cet enfant !

5. Il veut nos coeurs, il les attend :
Il est là pour faire leur conquête
Il veut nos coeurs, il les attend :
Donnons-les lui donc promptement !

6. Oh Jésus ! Oh Roi tout-puissant
Tout petit enfant que vous êtes,
Oh Jésus ! Oh Roi tout-puissant,
Régnez sur nous entièrement !

%}


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      %\set Staff.instrumentName = "Harmonica diatonique (Do)"
      %\clef treble
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
      %\set Staff.instrumentName = "Harmonica chromatique (Do)"
      %\clef treble
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
    \chromaticHarmonicaTab \relative c'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 116
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
