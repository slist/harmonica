\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Help!"
  composer = "John Lennon (1940 – 1980) - Paul McCartney (1942 - )"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "GB"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  
  % Liste des tonalités triées par nombre de # ou b dans l'armure

  % BÉMOLS
  %\key do \major   % 0 - aucune altération
  %\key fa \major   % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  % DIÈSES
  %\key do \major  % 0 - aucune altération
  %\key sol \major % 1# - fa#
  \key re \major  % 2# - fa#, do#
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
  \tempo "Energetic rock" 4 = 95

  % MODÉRÉ
  %\tempo "Moderato"     4 = 100
  %\tempo "Allegretto"   4 = 110
  %\tempo "Allegro"      4 = 120

  % RAPIDE
  %\tempo "Vivace"       4 = 140
  %\tempo "Presto"       4 = 180
  %\tempo "Prestissimo"  4 = 220

  \time 4/4
  
  %\clef "treble^8"
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  %\partial 4 % anacrouse

  
  fad2 r4 r8 mi8 | fad4 mi8 mi~ mi4 re | fad2 \tuplet 3/2 { r4 si,4 re } | fad mi mi8 (re~ re) si | sold'2 r8 si,8 re si | fad'4 mi8 mi~ mi2 | dod'4. (si8 la2) | 
  \break
  %r0
  
  \repeat volta 3 {
    r1 | r4\mp dod,8 dod~ dod4 dod | dod dod8 dod8~ dod4 dod | dod dod8 dod~ dod mi4  dod8~ ( dod2 si8 la4.) | r8 do8 dod do dod4 dod | 
    \break
    dod8 do4 dod8~ dod dod4. | re4 re re8 re4 dod8~ | dod1 | r4 do4 dod dod | dod dod8 dod~ dod dod4. | dod4 dod dod mi8 dod~ ( |
    \break
    dod2 si8 la4. ) | r8 dod8 dod do dod4. do8 | dod8 do dod2 r8 la8 | re4 re re re8 dod~ | dod1 
  }
  \alternative {
    {  }
    {  }
    {  }
  }
  mi4 mi mi mi |
  \break
  mi8 ( re ) re4 dod si | re2 ( dod8 si4.~ | si2 ) dod8 re4 mi8~ | mi4 mi mi mi8 mi~ | mi4 re dod8 si4 re8~ (  | re2 dod8 si4.~ | si1 ) 

  % TODO : gérer les 3 répétitions
  % gérer des paroles différentes selon l'alternative

  \bar "|."
}
\addlyrics {
  Help! I need some -- bo -- dy Help! Not just a -- ny bo -- dy Help! you know I need some -- one, help!
  When I was youn -- ger, so much youn -- ger than to -- day I ne -- ver need -- ded
  a -- ny bo -- dy's help in a -- ny way But now these days are gone I'm not so self -- as -- sured
  Now _ I find I've changed my mind And o -- pened up the doors Help me if you
  can I'm fee -- ling down And I do ap -- pre -- ci -- ate you be -- ing 'round
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
    \tempo 4 = 95
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
%\chromatiqueScore
%\midiScore
