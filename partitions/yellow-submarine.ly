\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Yellow Submarine"
  composer = "John Lennon (1940 – 1980) - Paul McCartney (1942 - )"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "GB"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  \key sol \major % Tonalité de Sol majeur (fa♯)
  \time 4/4
  %\tempo "Andantino rubato" 4 = 80
  \tempo 4 = 106
  %\clef "treble^8"
  %\dynamicUp % forcer toutes les dynamiques au-dessus
  
  %r2 r4
  \partial 4 % anacrouse
  
  si8. do16 | re2~ re8. si16 la8. si16 | sol2. si8. si16 | la8. sol16 mi4~ mi8. mi16 si'8. si16 | la2. si8. do16 |
  %\break
  re2~ re8. si16 la8. si16 | sol2. si8. si16 | la8. sol16 mi4~ mi8. mi16 si'8. si16 | la2. r4 |
  %\break
  re4 re re re8. mi16 | la,8. la16 la8. la16  la4 r4 | la8. la16 la8. la16  la4 r4 | sol8. sol16 sol8. sol16 sol2 |
  %\break
  re'4 re re re8. mi16 | la,8. la16 la8. la16  la4 r4 | la8. la16 la8. la16  la4 r4 | sol8. sol16 sol8. sol16 sol4 si8. do16 |
  %\break
  re2~ re8. si16 la8. si16 | sol2. si8. si16 | la8. sol16 mi4~ mi8. mi16 si'8. si16 | la2. si8. do16 
  %\break
  re2~ re8. si16 la8. si16 | sol2. si8. si16 | la8. sol16 mi2 si'8. si16 | la2 r2 |
  %\break
  re4 re re re8. mi16 | la,8. la16 la8. la16  la4 r4 | la8. la16 la8. la16  la4 r4 | sol8. sol16 sol8. sol16 sol2 |
  %\break
  re'4 re re re8. mi16 | la,8. la16 la8. la16  la4 r4 | la8. la16 la8. la16  la4 r4 | sol8. sol16 sol8. sol16 sol2 |

  \bar "|."
}
\addlyrics {
  In the town where I was born,
  lived a man _ _ who sailed the sea.
  And he told us of his life
  in the land _ _ of sub -- ma -- rines.

  %So we sailed up to the sun
  %Till we found the sea of green
  %And we lived beneath the waves
  %In our yellow submarine

  We all live in a yel -- low sub -- ma -- rine,
  yel -- low sub -- ma -- rine, yel -- low sub -- ma -- rine.
  We all live in a yel -- low sub -- ma -- rine,
  yel -- low sub -- ma -- rine, yel -- low sub -- ma -- rine.

  %And our friends are all on board
  %Many more of them live next door
  %And the band begins to play

  %We all live in a yellow submarine
  %Yellow submarine, yellow submarine
  %We all live in a yellow submarine
  %Yellow submarine, yellow submarine

  %[Full speed ahead, Mr. Parker, full speed ahead!
  %Full speed over here, sir!
  %Action station! Action station!
  %Aye, aye, sir, fire!
  %Heaven! Heaven!]

  As we live a life of ease, % (A life of ease)
  ev' -- ry one of us %(Everyone of us)
  has all we need. %(Has all we need)
  Sky of blue %(Sky of blue)
  and sea of green %(Sea of green)
  In our yel _ -- low %(In our yellow)
  sub -- ma -- rine. %(Submarine, ha, ha)
  
  We all live in a yel -- low sub -- ma -- rine,
  yel -- low sub -- ma -- rine, yel -- low sub -- ma -- rine.
  We all live in a yel -- low sub -- ma -- rine,
  yel -- low sub -- ma -- rine, yel -- low sub -- ma -- rine.

  %We all live in a yellow submarine
  %Yellow submarine, yellow submarine
  %We all live in a yellow submarine
  %Yellow submarine, yellow submarine.
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
    \tempo 4 = 106
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
