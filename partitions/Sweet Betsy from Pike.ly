\version "2.24.3"

\header {
  title = "Sweet Betsy from Pike"
  composer = "Traditional"
  poet = "Traditional"
  arranger = "Traditional American folk song"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  % Traditional American folk song, 19th century (California Gold Rush era)
  % Popularized in the 20th century by Johnny Cash (1932–2003)
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\layout {
  \context {
    \Lyrics
    \override LyricText.font-size = #-1
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #20 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #20 % Espace entre les portées
}

melodie = {
  \time 3/4
  \clef "treble^8"
  \tempo "Allegretto" 4 = 108
  \key re \major
  
  \partial 4 % anacrouse
  re8 re | re4 fad la | la sol mi | mi re dod | re2 re4 |
  \break
  re fad la | re re re | dod la la | la2 la4 |
  \break
  re re re | dod la fad | sol la si | la r4 mi |
  \break
  fad fad fad | la sol fad8 mi | mi4 re dod | re r4 re8 mi |
  \break
  fad4 fad4. fad8 | la4 sol fad | mi re4. dod8 | re2
  \bar "|."
}
\addlyrics {
  Did you ev -- er hear tell of Sweet Bet -- sy from Pike, who
  crossed the wide moun -- tains with her lov -- er Ike. With
  two yoke of cat -- tle, and one spot -- ted hog, a
  tall Shang -- hai roos -- ter and an old yel -- low dog. Sing -- ing
  too -- ra -- li -- oo -- ra --li -- oo -- ra -- li -- aye.
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
      \diatonicHarmonicaTab \relative do''' {
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
    \tempo 4 = 108
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

%diatoniqueScore
%\chromatiqueScore
%\midiScore
