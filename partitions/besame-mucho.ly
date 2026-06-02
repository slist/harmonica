\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Bésame Mucho"
  composer = "Consuelo Velázquez (1916–2005)"
  lyricsLang = #'(es)
  copyrightStatus = "copyrighted"
  composerNationality = "MX"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  
  % Liste des tonalités triées par nombre de # ou b dans l'armure

  % BÉMOLS
  %\key do \major   % 0 - aucune altération
  \key fa \major   % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  % DIÈSES
  %\key do \major  % 0 - aucune altération
  %\key sol \major % 1# - fa#
  %\key re \major  % 2# - fa#, do#
  %\key la \major  % 3# - fa#, do#, sol#
  %\key mi \major  % 4# - fa#, do#, sol#, re#
  %\key si \major  % 5# - fa#, do#, sol#, re#, la#
  %\key fis \major % 6# - fa#, do#, sol#, re#, la#, mi#
  %\key cis \major % 7# - fa#, do#, sol#, re#, la#, mi#, si#
  
  % Liste des tempos courants

  % TRÈS LENT
  %\tempo "Larghissimo" 4 = 20
  %\tempo "Grave"        4 = 35
  %\tempo "Largo"        4 = 45
  %\tempo "Lento"        4 = 55

  % LENT
  %\tempo "Adagio"       4 = 65
  %\tempo "Andante"      4 = 76
  %\tempo "Andantino"    4 = 80
  %\tempo "Andantino rubato" 4 = 80
  %\tempo "Allegro" 4 = 95
  %\tempo "Energetic rock" 4 = 95

  % MODÉRÉ
  %\tempo "Moderato"     4 = 100
  %\tempo "Allegretto"   4 = 110
  %\tempo "Allegro"      4 = 120

  % RAPIDE
  %\tempo "Vivace"       4 = 140
  %\tempo "Presto"       4 = 180
  %\tempo "Prestissimo"  4 = 220

  \tempo "Bolero (swing léger)" 4 = 78
  %\set Score.swingRatio = 0.58

  \time 4/4
  
  %\clef "treble^8"
  \clef "treble_8"
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  %\partial 4 % anacrouse

  %r1 r r r r 

% SEGNO
  \mark \markup { \musicglyph #"scripts.segno" }


  re4 re8 re~ re2~ |
  %\break
  re4 r4 \tuplet 3/2 { re4 mi fa } | la~ la8 sol~ sol2~ | sol2 r2 | \tuplet 3/2 { sol4 sol sol } \tuplet 3/2 { la la la } | \tuplet 3/2 { sib sib sib } \tuplet 3/2 { dod re mi } |
  %\break
  la,1~ | la2 r2 | re4 re8 re~ re2~ | re \tuplet 3/2 { re4 do sib } | la~ la8 sol~ sol2~ |
  %\break
  sol r2 | \tuplet 3/2 { re'4 la fa } \tuplet 3/2 { la fa re } | \tuplet 3/2 { fa mi re } \tuplet 3/2 { mi re dod } | re1~ | re^\markup { \italic "To Coda" } |   % TO CODA
  
  \break
  \tuplet 3/2 { sol4 sol sol } \tuplet 3/2 { sol fa mi } | \tuplet 3/2 { fa fa fa } \tuplet 3/2 { fa mi re } | mi mi8 mi \tuplet 3/2 { mi4 fa sol } | la1 | \tuplet 3/2 { sol4 sol sol } \tuplet 3/2 { sol4 fa mi } |
  %\break
  \tuplet 3/2 { fa fa fa } \tuplet 3/2 { fa mi re } | \tuplet 3/2 { mi mi mi } \tuplet 3/2 { mi fa re } | mi1^\markup { \italic "D.S. al Coda" }|
  \break
  \tuplet 3/2 { re'4 la fa } \tuplet 3/2 { la fa re } | \tuplet 3/2 { fa mi re } \tuplet 3/2 { mi re dod } | re1~ | re
  %r0
  
  %\repeat volta 3 {
  %  r1 | r4\mp dod,8 dod~ dod4 dod | dod dod8 dod8~ dod4 dod | dod dod8 dod~ dod mi4  dod8~ ( dod2 si8 la4.) | r8 do8 dod do dod4 dod | 
  %  \break
  %  dod8 do4 dod8~ dod dod4. | re4 re re8 re4 dod8~ | dod1 | r4 do4 dod dod | dod dod8 dod~ dod dod4. | dod4 dod dod mi8 dod~ ( |
  %  \break
  %  dod2 si8 la4. ) | r8 dod8 dod do dod4. do8 | dod8 do dod2 r8 la8 | re4 re re re8 dod~ | dod1 
  %}
  %\alternative {
  %  {  }
  %  {  }
  %  {  }
  %}
  %mi4 mi mi mi |
  %\break
  %mi8 ( re ) re4 dod si | re2 ( dod8 si4.~ | si2 ) dod8 re4 mi8~ | mi4 mi mi mi8 mi~ | mi4 re dod8 si4 re8~ (  | re2 dod8 si4.~ | si1 ) 

  % TODO : gérer les 3 répétitions
  % gérer des paroles différentes selon l'alternative

  \bar "|."
}
\addlyrics {
  % \lyricmode {
  %   Bésame mucho, como si fuera esta noche la última vez
  %   Bésame mucho, que tengo miedo a perderte, perderte después
  % }
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
      \chromaticHarmonicaTab \relative do' {
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
    \tempo 4 = 78
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

\markup {
  \column {
    \vspace #1
    \bold "Les chemins musicaux : Segno, D.S. al Coda, Coda"
    \vspace #0.5
    \line { "Tu joues normal… jusqu’à lire : D.S. al Coda (= Dal Segno à la Coda)" }
    \line { "Tu reviens au symbole 𝄋 (Segno)" }
    \line { "Tu rejoues à partir du Segno jusqu’à voir : To Coda" }
    \line { "Tu sautes vers la Coda, symbole 𝄌 placé plus loin (dernière ligne pour Mission Impossible)" }
    \line { "Tu joues la Coda jusqu'à la fin." }
    \line { " " }
    \line { "La Coda est une fin alternative, un \"bout spécial\" pour conclure le morceau." }
    %\vspace #1
  }
}