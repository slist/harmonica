\version "2.24.3"

\header {
  title = "Frere Jacques"
  tagline = ##f
}


%Source: https://www.petiteguitare.fr/partition-frere-jacques/


\include "harmonica.ly"
\include "style.ly"

Morceau = {
  \time 4/4
  c4 d e c | c d e c |
  \break
  e f g2 | e4 f g2 |
  \break
  g8. a16 g8 f e4 c | g'8. a16 g8 f e4 c |
  \break
  c g c2 | c4 g c2
  \bar ":|."
}
\addlyrics {
  Frè -- re Jac -- ques, Frè -- re Jac -- ques,
  dor -- mez -- vous, dor -- mez -- "vous ?"
  Son -- nez les ma -- ti -- nes, son -- nez les ma -- ti -- "nes !"
  Ding, daing, "dong !" Ding, daing, "dong !" 
}

%Some words may need explanation - a bobtail nag is a horse that has had its tail 'docked' (cut short) and a 'bay' is a brown horse with a black mane and tail.


\markup {
  \column {
    \vspace #4
    \fontsize #4 "Harmonica diatonique"
    \vspace #4
  }
}
%{
\diatonicHarmonicaTab \relative c'' {
  \Morceau
}

\pageBreak

\markup {
  \column {
    \vspace #4
    \fontsize #4 "Harmonica chromatique"
    \vspace #4
  }
}
%}
\chromaticHarmonicaTab \relative c'' {
  \Morceau
}

\score {
  \new Staff {
    \set Staff.midiInstrument = #"harmonica"
    \chromaticHarmonicaTab \relative c'' {
      \Morceau
    }
  }
  \midi {
    \tempo 4 = 90
  }
}
