\version "2.24.3"

\header {
  title = "Cartographie de l'Harmonica en Do (C)"
  subtitle = "Étude complète des notes, altérations, gammes"
  opus = "Op. 1"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en C"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

\layout {
  \context {
    \Lyrics
    %\override LyricText.font-size = #-1
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #8 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #24 % Espace entre les portées
}

melodie = {
  \clef "treble^8"
  
  \sectionTitle "Notes soufflées de 1 à 10 (-2 = +3)"
  do mi sol do mi sol do mi sol do
  \break
  
  \sectionTitle "Notes aspirées de 1 à 10"
  re,,, sol si re fa la si re fa la  
  \break

  \sectionTitle "Altérations"
  reb,,, solb fa sib la lab reb mi lab si mib re solb fa si sib
  \break

  \sectionTitle "Toutes les notes"
  do,,, reb re mib mi fa solb sol lab la sib si
  do    reb re mib mi fa solb sol lab la sib si
  do    reb re mib mi fa solb sol lab la sib si do
  
  \pageBreak

  \sectionTitle "Gamme pentatonique majeure de Do"
  do,,, re mi sol la
  do    re mi sol la
  do    re mi sol la do
  \break
  
  \sectionTitle "Gamme pentatonique mineure de Do"
  do,,, mib fa sol sib 
  do    mib fa sol sib 
  do    mib fa sol sib do
  \break

  \sectionTitle "Gamme pentatonique blues de Do"
  do,,, mib fa solb sol sib
  do    mib fa solb sol sib
  do    mib fa solb sol sib do
  \break

  \sectionTitle "Gamme mixolydienne de Do"
  do,,, re mi fa sol la sib
  do    re mi fa sol la sib
  do    re mi fa sol la sib do
  
  \pageBreak

  \sectionTitle "Gamme pentatonique mineure de Mi"
  mi,,, sol la si re
  mi    sol la si re
  mi    sol la si re mi
  \break

  \sectionTitle "Gamme pentatonique blues de Mi"
  mi,,, sol la sib si re
  mi    sol la sib si re
  mi    sol la sib si re mi
  \break

  \bar "|."
}
\addlyrics {
  \override LyricText.font-size = #1  % Augmente la taille (0 est la taille normale)
  Do Mi Sol Do Mi Sol Do Mi Sol Do
  "Ré" Sol Si "Ré" Fa La Si "Ré" Fa La
  "Ré♭" Sol♭ Fa Si♭ La La♭ "Ré♭" Mi La♭ Si Mi♭ "Ré" Sol♭ Fa Si Si♭
  
  Do "Ré♭" "Ré" Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si
  Do "Ré♭" "Ré" Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si
  Do "Ré♭" "Ré" Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si Do
    
  % penta majeure de Do
  Do "Ré" Mi Sol La
  Do "Ré" Mi Sol La
  Do "Ré" Mi Sol La Do
  
  % penta mineure de Do
  Do Mi♭ Fa Sol Si♭ 
  Do Mi♭ Fa Sol Si♭ 
  Do Mi♭ Fa Sol Si♭ Do
  
  % penta blues de do
  Do Mi♭ Fa Sol♭ Sol Si♭
  Do Mi♭ Fa Sol♭ Sol Si♭
  Do Mi♭ Fa Sol♭ Sol Si♭ Do
  
  % mixolidienne de Do
  Do "Ré" Mi Fa Sol La Si♭
  Do "Ré" Mi Fa Sol La Si♭
  Do "Ré" Mi Fa Sol La Si♭ Do
  
  % penta mineure de Mi
  Mi Sol La Si "Ré"
  Mi Sol La Si "Ré"
  Mi Sol La Si "Ré" Mi

  % penta blues de Mi
  Mi Sol La Si♭ Si "Ré"
  Mi Sol La Si♭ Si "Ré"
  Mi Sol La Si♭ Si "Ré" Mi
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative do' {
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
    \relative do' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 100
  }
}

\diatoniqueScore
\midiScore
