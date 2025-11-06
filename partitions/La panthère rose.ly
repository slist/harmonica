\version "2.24.0"

% From http://frans.free.fr/lilypond/lapanthererose.pdf
% http://frans.free.fr/lilypond/lapanthererose.ly
% Version de Lilypond mise à jour avec: convert-ly -e lapanthererose.ly

\header {
  title = "La panthère rose"
  composer = "Henry Mancini"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \clef treble
  \key e \minor
  \tempo "Moderately slow swing" 4 = 110
  \partial 16 \relative c'{
    dis16( |
    \repeat volta 2 {
      e4\staccato) r8. fis16( g4-.) r8. dis16(
      e8.-.) fis16( g8.-.) c16( b8.-.) e,16( g8.-.) b16\(
      bes2( \tuplet 3/2 { bes8) a8 g8 } \tuplet 3/2 { e8 d8 e8( }
      e2.)\) r8. dis16(
      e4-.) r8. fis16( g4-.) r8. dis16(
      e8.-.) fis16( g8.-.) c16( b8.-.) g16( b8.-.) e16
      ees1(
      ees2.)( ees8) r16 dis,16
      e4-. r8. fis16( g4-.) r8. dis16(
      e8.-.) fis16( g8.-.) c16( b8.-.) e,16( g8.-.) b16\(
      bes2( \tuplet 3/2 { bes8) a8 g8 } \tuplet 3/2 { e8 d8 e8( }
      e1)\)
      r4 e'8. d16 b8. a16 g8. e16
      bes'16\accent( a8.) bes16->( a8.) bes16->( a8.) bes16->( a8.) }
    \alternative {
      { \tuplet 3/2 { g8 e8 d8 } e8 e8( e2)(
        e2.) r8. dis16 }
      { \tuplet 3/2 { g8 e8 d8 } e8 e8( e2)
        \tuplet 3/2 { g8 e8 d8 } e8 e8( e2)
        \tuplet 3/2 { g8 e8 d8 } e8 e8( e2)(e1)  \bar "|."}
    }
  }
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab {
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
      \chromaticHarmonicaTab {
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
      \melodie
  }
  \midi {
    \tempo 4 = 110
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
