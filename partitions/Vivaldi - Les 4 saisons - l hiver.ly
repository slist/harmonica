\version "2.24.3"
\header {
  title = "Concerto No. 4 en Fa mineur, op.8, RV 297 - Les 4 saisons"
  subtitle = "L'hiver (L'inverno - Winter)"
  subsubtitle = "2° Mouvement"
  
  % Ce concerto est divisé en trois mouvements
  % - Allegro non molto
  % - Largo (cette partition)
  % - Allegro
  
  composer = \markup {
    \column {
      \line { 
        \with-url #"https://fr.wikipedia.org/wiki/Vivaldi" 
        "Antonio Lucio Vivaldi (1678 - 1741)"
      }
      %\line { \epsfile #X #5 #"uk-flag.eps" }  % must be local EPS
        %convert images/gb.png images/gb.eps   # using ImageMagick
    }
  }
  
  
    %composer = \markup { "🇬🇧 Georg Friedrich Haendel" }

%  composer = "Georg Friedrich Händel (Haendel) (1685 - 1759)"
  %opus = "HWV 437"
  arranger = ""
  %instrument = "Harmonica chromatique"
  copyrightStatus = "public-domain"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = \relative do'' {
  \tempo "Largo" 4 = 50
  %\time 3/4
  
  % FR
  \key sol \major % fa♯
  %\key re \major % fa♯, do♯
  %\key la \major % fa♯, do♯, sol♯
  %\key mi \major % fa♯, do♯, sol♯, ré♯
  
  %\key fa \major  % Si♭ --> try to \transpose fa sol
  %\key sib \major % Si♭, Mi♭
  
  % La méthode suivante fonctionne mais ajoute une mesure au compteur...
  %\dynamicUp
  %s1 \mf  % skip: note fantôme qui occupe une durée mais n'imprime rien, permet de placer le mezzo-forte sans note
  %\bar "" % Supprime la barre de la mesure
  
  
  %\once \override Score.RehearsalMark.self-alignment-X = #LEFT
  %\once \override Score.RehearsalMark.break-visibility = #end-of-line-invisible
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.extra-offset = #'(0 . -4)
  \mark \markup { \dynamic "mf" }
  
  sol8 re'16 do si8 la16 sol la8 re, r8 re |
  \break
  do'16 si la sol fad8 do' do \trill si r8 si |
  %\break
  la si16 do re8 mi16 fad sol,8 la16 si do8 re16 mi |
  %\break
  fad,8 sol16 la si8 do16 re mi,8 fad16 sol la8 si16 sol |
  \break
  fad4~ fad16 re dod re la'4~ la16 re, dod re |
  \break
  si'4~ si16 re, dod re dod'4~ dod16 la sol la |
  %\break
  
  % 7ème mesure 
  
  re8 re, r re' re16 dod si la sol fad mi re |
  \break
  mi4. \trill re8 re4. r8 |
  
  re8 la'16 sol fad8 mi16 re mi8 la r la |
  
  sol16 fad mi re dod8 sol' sol \trill fad r re |
  \break
  do'16 si la sol fad8 do' do \trill si r si |
  
  mi, fad16 sol la8 si16 do fad,8 sol16 la si8 do16 re |
  \break
  sol,8 la16 si do8 re16 mi fad,4 r8 fad16 sol |
  \break
  la16 fad mi re si'16 do re si la8 re, r fad16 \p sol |
  la16 fad mi re si' do re si la8 re, r la'16 \mf re |
  si8 la16 sol fad8. \trill sol16 sol2 ~ |
  sol1 ~ \> \! | % decrescendo ou diminuendo (souvent appelé un "hairpin" en anglais)
  
  %\mf sol1\>
  %\once \override DynamicText.transparent = ##t
  %\pp
  
  sol4 \pp \fermata r4 r2 | 

  \bar "|."  
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
% SCORE CHROMATIQUE
% ============================

chromatiqueScore = 
\score {
  <<
    \new Staff { 
      \chromaticHarmonicaTab \relative do' {
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
    \tempo 4 = 50
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

