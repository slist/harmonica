\version "2.24.3"

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "Gammes Jazz — harmonica diatonique en Do (C)"
  subtitle = "Modes et gammes pour l'improvisation"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  instrument = "Harmonica diatonique en Do (C)"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

\paper {
  markup-system-spacing.basic-distance = #8
  system-system-spacing.basic-distance = #24
}

% Notes en hauteurs absolues (do' = do central, comme sur la tablature de l'harmonica)
melodie = {
  \clef "treble^8"
  \time 4/4

  \sectionTitle "Mode dorien — Ré (3e position)"
  re'4 mi' fa' sol' la' si' do'' re'' do'' si' la' sol' fa' mi' re'2
  \break

  \sectionTitle "Mode mixolydien — Sol (2e position, cross-harp)"
  sol'4 la' si' do'' re'' mi'' fa'' sol'' fa'' mi'' re'' do'' si' la' sol'2
  \break

  \sectionTitle "Mode lydien — Fa"
  fa'4 sol' la' si' do'' re'' mi'' fa'' mi'' re'' do'' si' la' sol' fa'2
  \break

  \sectionTitle "Gamme par tons — Do"
  do'4 re' mi' solb' lab' sib' do'' sib' lab' solb' mi' re' do'2 r2
  \break

  \sectionTitle "Gamme diminuée (ton-demi-ton) — Do"
  do'4 re' mib' fa' solb' lab' la' si' do'' si' la' lab' solb' fa' mib' re' do'1
  \break

  \sectionTitle "Gamme bébop dominante — Sol"
  sol'4 la' si' do'' re'' mi'' fa'' fad'' sol'' fad'' fa'' mi'' re'' do'' si' la' sol'1
  \break

  \bar "|."
}
\addlyrics {
  "Ré" "Mi" "Fa" "Sol" "La" "Si" "Do" "Ré" "Do" "Si" "La" "Sol" "Fa" "Mi" "Ré"
  "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa" "Sol" "Fa" "Mi" "Ré" "Do" "Si" "La" "Sol"
  "Fa" "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa" "Mi" "Ré" "Do" "Si" "La" "Sol" "Fa"
  "Do" "Ré" "Mi" "Sol♭" "La♭" "Si♭" "Do" "Si♭" "La♭" "Sol♭" "Mi" "Ré" "Do"
  "Do" "Ré" "Mi♭" "Fa" "Sol♭" "La♭" "La" "Si" "Do" "Si" "La" "La♭" "Sol♭" "Fa" "Mi♭" "Ré" "Do"
  "Sol" "La" "Si" "Do" "Ré" "Mi" "Fa" "Fa♯" "Sol" "Fa♯" "Fa" "Mi" "Ré" "Do" "Si" "La" "Sol"
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
% SCORE MIDI
% ============================

midiScore =
\score {
  \new Staff {
    \set Staff.midiInstrument = #"harmonica"
    \unfoldRepeats {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 90
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
%\midiScore
