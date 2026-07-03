\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Timber"
  composer = "Pitbull (1981 – ) - Kesha (1987 - )"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "GB"
  instrument = "Harmonica en E"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  %\key sol \major % Tonalité de Sol majeur (fa♯)
  \time 4/4
  %\tempo "Andantino rubato" 4 = 80
  \tempo 4 = 130
  %\clef "treble^8"
  \dynamicUp % forcer toutes les dynamiques au-dessus
  
  %r2 r4
  %\partial 4 % anacrouse
  
  %\mark \markup \box "Intro"
  r2 r8 sold8\mf si16 si8. | si4 r4. fad'8 red16 ( dod si8) | red fad~ fad2 r4 | fad2. red16 ( dod si8 ) |
  \break
  sold8 si4. r8 sold8 si16 si8. |
  %\mark \markup \box "Chorus"
  si4 r4. fad'8 red16 ( dod si8) | red fad~ fad2 r4 | fad2. red16 ( dod si8 ) |
  \break
  sold8 si4. r8 sold8 si16 si8. | si4 r4. fad'8 red16 ( dod si8) | red fad~ fad2 r4 | fad2. red16 ( dod si8 ) |
  \break
  sold8 si4. r8 fad'8 r16 red8. | %\mark \markup \box "Interlude" 
  si4 r4. fad'8 red16 ( dod si8) | red fad~ fad2 r4 | fad2. red16 ( dod si8 ) |
  \break

  sold8 si4. % To confirm
  
  \bar "|."
}
\addlyrics {


  %So we sailed up to the sun
  %Till we found the sea of green
  %And we lived beneath the waves
  %In our yellow submarine
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
      %\set Staff.instrumentName = "Harmonica en E"
      \diatonicEHarmonicaTab \relative do'' {
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
    \tempo 4 = 130
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
\chromatiqueScore
\midiScore
