\version "2.24.3"

\header {
  title = "Un petit cochon"
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

melodie = {
  \time 4/4
  \clef "treble^8"
  fa8 fa8 fa8 fa8 fa4 do8 fa8 la4 sol4 fa2 fa8 fa8 fa8 fa8 fa4 do8 fa8
  \break
  la4 sol4 fa2 fa8 fa8 fa8 fa8 fa4 do8 fa8 la4 sol4 fa2
  \break
  fa8 fa8 fa8 fa8 sol4 fa4 fa4 sol4 do4 fa,2 fa8 sol fa sol do fa, r4
  \break
  fa4 do fa2 
  \bar "|."
}
\addlyrics {
  Un pe -- tit co -- chon pen -- du au pla -- fond. Ti -- rez -- lui le nez, il donne --
  ra du lait, Ti -- rez  -- lui la queue, il pon -- dra des oeufs,
  Ti -- rez la plus fort il pon -- dra de l'or! Com -- bien en vou -- lez -- vous?
 "1," "2," "3!"
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

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%diatoniqueScore
%\chromatiqueScore
%\midiScore
