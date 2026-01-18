\version "2.24.3"

\header {
  title = "Petit Papa Noël"
  composer = "Henri Martinet (1906-1983) & Raymond Vincy (1912-1973)"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain" % ? Chanson de Noël française créée en 1946
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 4/4
  \key sol \major % fa♯

  \partial 4 % La note levée est une noire, ce serait "\partial 8" pour une anacrouse de la durée d'une croche
  re4 | sol sol sol la | sol2 r4 sol8 la | si4 si si do |
  %\break
  si2 r4 la4 | sol4. sol8 sol sol fad mi | re2. re8 re | sol2 sol8 sol fad sol |
  %\break
  la2. re,4 | sol4 sol sol la | sol2 r4 sol8 la | si4 si si do |
  %\break
  si2. la4 | sol4. sol8 sol sol fad mi | re2. re8 re | sol2 sol8 sol la la |
  %\break
  sol2. r4 | mi8 mi mi mi mi4 mi8 fad | sol4. mi8 mi4 re | sol8 sol sol sol sol4 fad8 sol |
  %\break
  la2. r4 | sib8 sib sib sib sib4 la8 sib | do4. la8 sol4 fa4 | sib sib8 sib do4 do8 do |
  %\break
  re2 r4 re,4 | sol4 sol sol la | sol2. sol8 la | si4 si si do |
  %\break
  si2. la4 | sol4. sol8 sol sol fad mi | re2. re8 re | sol2 sol8 sol la la |
  %\break
  sol2. re4 | mi sol la do | re1 
  \bar "|."
}
\addlyrics {
  %C'est la belle nuit de Noël
  %La neige étend son manteau blanc
  %Et les yeux levés vers le ciel
  %À genoux, les petits enfants
  %Avant de fermer les paupières
  %Font une dernière prière.

  Pe -- tit pa -- pa No -- ël,
  Quand tu des -- cen -- dras du ciel,
  Av -- ec des jou -- ets par mil -- liers,
  N'ou -- blie pas mon pe -- tit sou -- lier.

  Mais av -- ant de par -- tir,
  Il fau -- dra bien te cou -- vrir,
  De -- hors tu dois a -- voir si froid,
  C'est un peu à  cau -- se de moi.

  Il me tar -- de tant que le jour se lè -- ve,
  Pour voir ce que tu m'as appor -- té,
  Tous les beaux jou -- joux que je vois en rê -- ve,
  Et que je t'ai com -- man -- dés.

  Pe -- tit pa -- pa No -- ël,
  Quand tu des -- cen -- dras du ciel,
  Av -- ec des jou -- ets par mil -- liers,
  N'ou -- blie pas mon pe -- tit sou -- lier.

  Pe -- tit pa -- pa No -- ël!

  Le marchand de sable est passé,
  Les enfants vont faire dodo,
  Et tu vas pouvoir commencer,
  Avec ta hotte sur le dos
  Au son des cloches des églises,
  Ta distribution de surprises.

  Petit papa Noël,
  Quand tu descendras du ciel
  Avec des jouets par milliers,
  N'oublie pas mon petit soulier.
  Si tu dois t'arrêter,
  Sur les toits du monde entier
  Tout ça avant demain matin,
  Mets toi vite, vite en chemin.

  Et quand tu seras sur ton beau nuage,
  Viens d'abord sur notre maison
  Je n'ai pas été tous les jours bien sage,
  Mais j'en demande pardon.

  Petit papa Noël,
  Quand tu descendras du ciel,
  Avec des jouets par milliers,
  N'oublie pas mon petit soulier.
  Petit papa Noël.
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
    \tempo 4 = 100
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


\pageBreak

\markup {
  \column {
    \vspace #1
    \fill-line { \bold "Commentaires" }
    \vspace #1
    \bold "Anacrouse"
    \vspace #0.5
    \fill-line {
      \wordwrap {
        L’anacrouse est une note (ou un groupe de notes) qui précède le premier temps fort de la première mesure.
        Dans Petit Papa Noël, la syllabe “Pe–” arrive avant le premier temps fort, et la syllabe “–tit” tombe sur le temps 1.
      }
    }
    \vspace #0.5
    \wordwrap {
      L'anacrouse (musicologie) ou la note levée, c’est la ou les notes qui arrivent avant le premier temps fort d’un morceau.
    }
  }
}