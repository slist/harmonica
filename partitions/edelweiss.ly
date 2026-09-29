\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))
#(define compile-partition (ly:get-option 'compile-partition))

\header {
  title = "Edelweiss"
  subtitle = "The Sound of Music (1959)"
  
  poet = "Oscar Hammerstein II (1895–1960)"
  composer = "Richard Rodgers (1902–1979)"
  
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  
  poetNationality = "US"
  composerNationality = "US"
  
  instrument = "Harmonica diatonique en Sib (Bb)"
  
  date = "1959"
  youtube = "https://www.youtube.com/watch?v=8bL2BCiFkTk"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  \time 3/4
  \key sib \major % Si♭, Mi♭
  \tempo "Moderato" 4 = 100
  \clef "treble^8"
  
  
  re'2 fa4 | do'2. | sib2 fa4 | mib2. | re2 re4 | re mib fa | sol2. | fa |
  \break
  re2 fa4 | do'2. | sib2 fa4 | mib2. | re2 fa4 | fa sol la | sib2. | sib2. |
  \break
  do4. fa,8 fa4 | la sol fa | re2 fa4 | sib2. sol2 sib4 | do2 sib4 | la2. | fa2. |
  \break
  re2 fa4 | do'2. sib2 fa4 | mib2. | re2 fa4 | fa sol la | sib2. | sib\fermata |  
  \bar "|."
}
\addlyrics {
  E -- del -- weiss, E -- del -- weiss, Ev -- 'ry morn -- ing you greet me.
  Small and white, Clean and bright, You look hap -- py to meet me.
  Blos -- som of snow, may you bloom and grow, Bloom and grow for -- ev -- er.
  E -- del -- weiss, E -- del -- weiss. Bless my home -- land for -- ev -- er.
}

accords = \chordmode {
  sib fa:7 sib mib sib sol:m7 do:m7 fa:7
  sib fa:7 sib mib sib fa:7 sib s
  fa:7 s sib s mib do fa fa:7
  sib fa:m6 mib mib:m sib fa:7 sib
  
}
accordsenglish = \chordmode { % en anglais
%  bb f7 bb eb bb gm7 cm7 f7
%  bb f7 bb eb bb f7 bb
%  f7 f7 bb eb c f f7
%  bb Fm6 Eb Ebm Bb F7 Bb
 
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore =
\score {
  <<
    \new ChordNames {
      \accords
    }
    \new Staff {
      %\set Staff.instrumentName = "Harmonica en E"
      %\diatonicEHarmonicaTab \relative do''' {
      \diatonicBbHarmonicaTab \relative do'' {
        \melodie
      }
    }
  >>
  \layout {
    %indent = 2.5\cm
  }
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
% SCORE PARTITION (sans tablature harmonica)
% ============================

partitionScore =
\score {
  <<
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
  <<
    % Noms des accords sur la partition
    \new ChordNames {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \relative do' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \accords
    }
  >>

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

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
%\chromatiqueScore
\midiScore
