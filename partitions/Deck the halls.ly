\version "2.24.3"

\header {
  title = "Deck the halls"
  %composer = ""
  lyricsLang = #'(en)
  copyrightStatus = "public-domain" % Mélodie galloise traditionnelle (XVIe siècle)
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Pour avoir la première phrase entièrement sur une ligne.
% Supprime l'indentation de la première ligne.
\paper {
  indent = 0\mm
}


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \key d \major % Tonalité de Ré majeur (fa♯, do♯)
  \time 4/4

  a4. g8 fis4 e | d e fis d | e8 fis g e  fis4. e8 | d4 cis d2 |
  \break
  a'4. g8 fis4 e | d e fis d | e8 fis g e  fis4. e8 | d4 cis d2 |
  \break
  e4. fis8 g4 e | fis4. g8 a4 fis4 | fis8 g a4 b8 cis d4 | cis4 b a2 |
  \break
  a4. g8 fis4 e | d e fis d | b'8 b b b a4. g8 | fis4 e d2 |
  
  \bar "|."
}

\addlyrics {
  Deck the halls with boughts of ho -- ly, fa la la la la, la la la la.
  'Tis the sea -- son to be jol -- ly, fa la la la la, la la la la.
  Don we now our gay ap -- par -- el, fa la la la la, la la la la.
  Troll the an -- cient youle -- tide car -- ol. Fa la la la la, la la la la.
}


% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c'' {
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
      \chromaticHarmonicaTab \relative c'' {
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
    \chromaticHarmonicaTab \relative c'' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 100
  }
}

% ============================
% COMPILATION SÉPARÉE
% ============================

% Pour générer la version diatonique :
% lilypond -dcompile-diatonique <fichier.ly>

% Pour générer la version chromatique :
% lilypond -dcompile-chromatique <fichier.ly>

% Pour générer le fichier midi :
% lilypond --formats=midi -dcompile-midi <fichier.ly>

% Inclusion conditionnelle des scores

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

