\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Rythme Charleston — harmonica diatonique en Do (C)"
  subtitle = ""
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Do (C)"
}

% Source : https://www.harmonica.com/wp-content/uploads/2020/01/charleston-rhythm.png

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = \relative {
  \clef "treble^8"
  \time 4/4
  \tempo 4 = 140

  %\sectionTitle "Rythme Charleston"
  %sol4. sol8 r4 r4
  %\break
  
  \sectionTitle "12 - Bar Blues Rythm Chords Harmonica"
  \relative sol' {
    <sol si re>4. <sol si re>8 r4 r4  | <sol si re>4. <sol si re>8 r4 r4 |
    <sol si re>4. <sol si re>8 r4 r4  | <sol si re>4. <sol si re>8 r4 r4 |
    \break
    
    <do mi sol>4. <do mi sol>8 r4 r4 | <do mi sol>4. <do mi sol>8 r4 r4 |
    <sol si re>4. <sol si re>8 r4 r4 | <sol si re>4. <sol si re>8 r4 r4 |
    \break
    
    ré'4. ré8 r4 r4 | <do mi sol>4. <do mi sol>8 r4 r4
    <sol si re>4. <sol si re>8 r4 r4 | <sol si re>4. <sol si re>8 r4 r4 |
  }
  \bar "|."
}

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

midiScore =
\score {
  \new Staff {
    \set Staff.midiInstrument = #"harmonica"
    \melodie
  }
  \midi { }
}

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
\midiScore