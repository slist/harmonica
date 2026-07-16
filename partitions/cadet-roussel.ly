\version "2.24.3"

\header {
  title = "Cadet Roussel"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  composerNationality = "fr"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  %\time 6/8
  %\clef "treble^8"
  \key sol \major % Tonalité de Sol majeur (fa♯)
  %\partial 4 % anacrouse
    
  re,8 mi fad sol4 sol8 sol4 si8 sol4 la8 la si la4 sol8 fad4 mi8 re4
  \break
  re8 mi fad sol4 sol8 sol4 si8 sol4 la8 la si la4 sol8 fad4 mi8 re4
  \break
  la'8 la la la4 si8 do4 re8 do4 la8 la la la4 si8 do4 re8 do4
  \break
  sol4 sol sol8 fad mi re4 sol8 fad mi la4 la8 re,4 fad8 sol4  
  \bar "|."
}
\addlyrics {
 Ca -- det Rous -- sel a trois mai -- sons, Ca -- det Rous -- sel a trois mai -- sons,
 Qui n'ont ni pou -- tres ni che -- vrons, Qui n'ont ni pou -- tres ni che -- vrons:
 C'est pour lo -- ger les hi -- ron -- delles, Que di -- rez vous d'Ca -- det Rous -- sel?
 Ah! Ah! Ah! mais vrai -- ment, Ca -- det Rous -- sel est bon en -- fant.
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
    \tempo 4 = 100
  }
}

\markup {
  \vspace #2
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions

%diatoniqueScore
\chromatiqueScore
\midiScore
