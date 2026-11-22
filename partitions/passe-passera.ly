\version "2.24.4"

\header {
  title = "Passe-passera"
  category = "Comptine"
  composer = "Traditionnel"
  instrument = "Harmonica diatonique en Ré (D)"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))
#(define compile-partition (ly:get-option 'compile-partition))

melodie = {
  \time 3/4
  \clef "treble^8"
  \key sol \major
  \tempo 4 = 100

  sol4 sol fad8 mi |
  \time 2/4
  ré4 sol8 sol | la la sol la | si4 sol |
  \time 3/4
  \break
  sol4 sol fad8 mi |  
  \time 2/4
  ré4 sol8 sol | la la mi fad | sol4 mi8 sol |
  \break
  si4 la | si mi,8 sol | sol4 fad | mi mi8 si' | si4 la | si mi,8 sol |
  \break
  sol4 fad | mi mi8 si' | si4 la | si mi,8 sol | sol4 fad |
  \break
  mi4 mi8 si' | si4 la | si mi,8 sol | sol4 fad | mi r4 
  \bar "|."
}
\addlyrics {
  "Pass'" "pass'" pas -- se -- ra, la der -- niè -- re la der -- niè -- re,
  "Pass'" "pass'" pas -- se -- ra, la der -- niè -- re res -- te -- ra "qu'est-ce" "qu'elle"
  a donc fait, la "p'tite" hi -- ron -- "delle !" Elle nous a vo -- lé trois "p'tits"
  grains de blé, Nous "l'at" -- tra -- pe -- rons, la "p'tite" hi -- ron --
  delle, nous lui don -- ne -- rons trois "p'tits" coups "d'bâ" -- ton.
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
      \diatonicDHarmonicaTab \relative do''' {
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
        \clef "treble"
        \melodie
      }
    }
  >>
  \layout { }
}

% ============================
% SCORE PARTITION (sans tablature harmonica)
% ============================

partitionScore =
\score {
  <<
    \new ChordNames {
      \accords
    }
    \new Staff {
      \relative do'' {
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
    \unfoldRepeats \relative do'' {
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
#(if compile-partition
     (ly:parser-include-string "\\partitionScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))


\markup {
  \column {
    \vspace #1
    \fill-line { \bold "Commentaires" }
  }
}

\markup {
  \column {
    \bold "Danse"
    \vspace #0.5
    \fill-line {
      \wordwrap {
        Les enfants se placent deux par deux, face à face,
        et lèvent les bras en se tenant les mains pour former
        un pont. En commençant par le dernier couple, les autres
        enfants passent successivement sous le pont au rythme
        de la chanson. À la fin du morceau, les enfants qui
        forment le pont abaissent leurs bras pour retenir
        celui qui passe. L'enfant ainsi attrapé joue le rôle
        de l'hirondelle et reçoit trois petites tapes.
      }
    }
  }
}

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
%\chromatiqueScore
\midiScore
