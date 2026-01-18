\version "2.24.3"

\header {
  title = "Mission Impossible"
  composer = "Gustav Anderson (1920-1989) ou Lalo Schifrin (1932-)"
  copyrightStatus = "copyrighted"
  tagline = ##f
}

% From: https://www.free-scores.com/PDF_FR/anderson-gustav-mission-impossible-89474.pdf

\include "harmonica.ly"
%\include "lilypond-book-preamble.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\markup {
  \column {
    \vspace #0.5
    \fill-line {
      \wordwrap {
        Votre mission, si toutefois vous l’acceptez, consiste à interpréter ce morceau à l’harmonica.
        Attention : cette partition s’autodétruira dans cinq minutes…
        Bonne chance !
      }
    }
    \vspace #1
  }
}

% Que signifie “To Coda” ?
% “To Coda” (→ vers la coda) est une indication de navigation musicale.
% Elle signifie :
% « Sautez à la section marquée Coda » lorsque vous atteignez ce point dans la partition.
%En pratique :
%Tu joues normalement jusqu’à une indication D.S. al Coda (Dal Segno al Coda) ou D.C. al Coda (Da Capo al Coda).
%Tu reprends depuis le signe (Segno = le gros 'S' barré avec 2 petits points).
%Quand tu arrives à “To Coda”, tu sautes directement à la partie marquée “Coda”.
%C’est un peu comme un “téléporteur musical” entre deux endroits.

coda = \mark \markup { \musicglyph #"scripts.coda" }

melodie = {
  \time 5/4
  \tempo "Allegro molto" 4 = 170
  
  \compressEmptyMeasures
  \override MultiMeasureRest.expand-limit = 3
  \set Score.proportionalNotationDuration = #(ly:make-moment 1 1)
  R1*5/4*4
  \unset Score.proportionalNotationDuration
  
  % Base de durée courte pour espacement proportionnel → plus serré
  %\override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/32)
  % Espacement général entre notes (staff-spaces)
  %\override SpacingSpanner.spacing-increment = #0.8
  % Optionnel : notation proportionnelle selon durée réelle
  % \set Score.proportionalNotationDuration = #(ly:make-moment 1/16)
  
  \bar "||"
  \mark \markup { \musicglyph #"scripts.segno" }
  
  do8\f ( la mi2. ) r4 | do'8( la mib2. ) r4 | do'8( la re,2. ) r4 | do'8-- re-. r4 r4 r2 |
  %\break
  la4^\marcato\mf r8 la4^\marcato r8 do4^\marcato re^\marcato | la4^\marcato r8 la4^\marcato r8 sol4^\marcato sold4^\marcato \bar "||" do8\f^\markup { \box "A" } ( la sold'2. ) r4 | do,8( la sol'2.) r4 | do,8( la fad'2.) r4 |
  
  % un marcato indique qu’il faut jouer la note avec un accent fort et bref.
  
  %\break
  fa8-- mi8-. r4 r4 r2 | \bar "||" fa8\f ( re la2. ) r4 | fa'8 ( re lab2. ) r4 | fa'8 ( re sol,2. ) r4 | fa'8-- sol8-. r4 r4 r2 \bar "||" 
  %\break
  do,8\f^\markup { \box "B" } ( la sold'2. ) r4 | do,8 ( la sol'2. ) r4 | do,8 ( la fad'2. ) r4 \mark \markup { \bold "To Coda" } \bar "||"
  
  fa8-- mi8-. r8 mi4^\marcato r8 fa4^\marcato sol4^\marcato | mi4^\marcato\f r8 mi4^\marcato r8 fa4^\marcato sol4^\marcato |
  %\break
  mi4^\marcato r4 r4 r2 |
  
  \compressEmptyMeasures
  \override MultiMeasureRest.expand-limit = 1
  \set Score.proportionalNotationDuration = #(ly:make-moment 1 1)
  R1*5/4*2
  \unset Score.proportionalNotationDuration
  
  la,4^\marcato\mp r8 la4^\marcato r8 do4^\marcato dod^\marcato \bar "||" re2.\f~^\markup { \box "C" } re8 fa, la re | dod2.~ dod8 fa, la re |
  %\break
  do2.~ do8 si do si | sib la r8 re4^\marcato r8 fa4^\marcato sol4^\marcato | re4^\marcato r8 re4^\marcato r8 do8^\marcato la ( do dod ) \bar "||" re2.~ re8 mi re la |
  %\break
  dod2. ( dod8 ) re dod re | do2. ( dod8 ) si do si | sib la r8 la4^\marcato r8 do8^\marcato re ( fa fad ) \bar "||" sol2.~^\markup { \box "D" } sol8 sib, ( re sol ) |
  %\break
  fad2.~ fad8 sib, re fad | fa2. ( fad8 ) mi fa mi | mib re r8  sol,4^\marcato r8  sib4^\marcato do^\marcato \bar "||" re2.~ re8 mi re la |
  %\break
  dod2. ( dod8 ) dod re dod | do2. ( dod8) dod si sol | sib8 la r8 mi'4^\marcato r8 fa4^\marcato sol4^\marcato \bar "||" la4^\marcato r4 r4 r2\mark \markup { \bold "D.S. al Coda" } | r1 r4 \bar "||"
  %\break
  % Coda section
  \coda 
  la,4^\marcato r8 la4^\marcato r8 sib4^\marcato do^\marcato | si^\marcato r4 r4 sol'8 la4.~ | la2.~ la2
  
  %do si | sib la r8 la4^\marcato r8 do8^\marcato
  
  %do^\markup \center-align "Si vous acceptez cette mission, vous devez continuer..."
  %   do^\markup "Si vous acceptez cette mission, vous devez continuer..."


  
  %do do do do do \mark \markup { \musicglyph #"scripts.coda" \hspace #0.5 \italic "To Coda" }
  %\break

  %do do do do do  \mark \markup{\musicglyph #"scripts.coda"} do do do do do 
  %\break
  %do do do do do  \mark \markup { \italic "D.S. al Coda" } do do do do do 
  %\break
  %do do do do do  \mark \markup{\musicglyph #"scripts.coda"} do do do do do 
  %\break

  \bar "|."
}
\addlyrics {
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
    \tempo 4 = 170
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

%\pageBreak

\markup {
  \column {
    \vspace #1
    \fill-line { \bold "Commentaires" }
  }
}

\markup {
  \column {
    \bold "Indications de nuances"
    \vspace #0.5
    \fill-line {
      \wordwrap {
        Les lettres telles que « p », « mp », « f » ou « ff » sont appelées indications de nuances.
        Elles précisent l’intensité avec laquelle chaque note ou passage doit être joué.
        Ces indications aident l’interprète à donner une expression musicale plus précise et vivante.
      }
    }
    %  \vspace #1
  }
}

\markup {
  \column {
    %   \vspace #1
    %   \bold "Indications de nuances"
    \vspace #0.5
    \line {       "   • pp = pianissimo : très doux" }
    \line {       "   • p = piano : doux" }
    \line { \bold "   • mp" " = mezzo-piano : moyennement doux" }
    \line { \bold "   • mf = mezzo-forte : moyennement fort" }
    \line { \bold "   • f" " = forte : fort" }
    \line {       "   • ff = fortissimo : très fort" }
    \line {       "   • sfz = sforzando : accent fort et soudain" }
    \vspace #1
  }
}

\markup {
  \column {
    \bold "À propos du marcato (^)"
    \wordwrap {
      Le chapeau pointu au-dessus d'une note indique un marcato.
      La note doit être jouée fortement accentuée et détachée,
      plus marquée qu'un simple accent. Cela attire l'attention
      sur la note et donne du caractère au phrasé musical.
      Combinez-le avec la dynamique pour obtenir l'effet expressif souhaité.
    }
    \vspace #1
  }
}

\markup {
  \column {
    \vspace #1
    \bold "Les chemins musicaux : Segno, D.S. al Coda, Coda"
    \vspace #0.5
    \line { "Tu joues normal… jusqu’à lire : D.S. al Coda (= Dal Segno à la Coda)" }
    \line { "Tu reviens au symbole 𝄋 (Segno)" }
    \line { "Tu rejoues à partir du Segno jusqu’à voir : To Coda" }
    \line { "Tu sautes vers la Coda, symbole 𝄌 placé plus loin (dernière ligne pour Mission Impossible)" }
    \line { "Tu joues la Coda jusqu'à la fin." }
    \line { " " }
    \line { "La Coda est une fin alternative, un \"bout spécial\" pour conclure le morceau." }
    %\vspace #1
  }
}