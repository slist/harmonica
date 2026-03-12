\version "2.24.3"

\header {
  title = "Shenandoah"
  composer = "Traditional"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain" % Mélodie traditionnelle
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
  \key re \major % Tonalité de Ré majeur (fa♯, do♯)
  \time 4/4
  \clef "treble^8"


  \partial 4
  la4 | re re re2~ | re4 mi fad la | la fad2.~ | fad2 re'4 ( dod )
  \break
  si1~ | si4 la si la | fad la2.~ | la2 la | si4 si si2~ |
  \break
  si4 fad la fad | mi re2.~ | re2 mi | fad1~ | fad4 re fad4. si8|
  \break
  la1~ | la2. re,4 | fad fad fad2~ |fad2. mi4 | mi re2.~ | re2. 
  \bar "|."
}
\addlyrics {
  Oh Shen -- an -- doah, I long to hear you. A --
  way you rol -- ling riv -- er, oh Shen -- an -- doah,
  I long to see you. A -- way, I'm bound a --
  way a -- cross the wide Mis -- sour -- i.
  
  Oh Shenandoah,
  I love your daughter,
  Away, you rolling river.
  For her I'd cross,
  Your roaming waters,
  Away, I'm bound away,
  'Cross the wide Missouri.
  
  'Tis seven years,
  Since last I've seen you,
  Away, you rolling river.
  'Tis seven years,
  Since last I've seen you,
  Away, we're bound away,
  'Cross the wide Missouri.
}

accords = \chordmode {
  s4 re1 s s s
  sol s re s sol
  s s s re si:m
  fad:m re sol la:7 re s
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
