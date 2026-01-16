\version "2.24.0"

\header {
  title = "Ah! Les Crocodiles"
  lyricsLang = #'(fr)
  copyrightStatus = "public-domain"
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
  \time 2/4
  %\tempo 4 = 80

  %\clef "treble_8" % "treble^8" "treble_8"
  \key f \major  % Définit l'armure avec si♭
  %\key d \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key g \major % Tonalité de Sol majeur (fa♯)
  
  f4 f8. a16 | c4. bes8 | a [ g a bes ] | a4 g |
  \break
  g g8. a16 | g4. g8 | a8 [ g a b ] | c2 |
  \break
  f,4 f8. a16 | c4. bes8 | a [ g a bes ] | a4 g |
  \break
  g g8. a16 | g4. g8 | a8 [ g a b ] | c2 |
  \break
  f,8 [ a a a ] | f8 [ a a a ] | f8 [ a a a ] | bes4 g |
  \break
  e8 [ g g g ] | e [ g g g ] | c [bes a g ] | a2 |
  \break
  f8 [ a a a ] | f8 [ a a a ] | f8 [ a a a ] | bes4 g |
  \break
  e8 [ g g g ] | e [ g g g ] | c [bes a g ] | f2 
  \bar "|."
}
\addlyrics {
  Un cro -- co -- dile s'en al -- lant à la guer -- re
  di -- sait a -- dieu à ses pe -- tits en -- fants,
  traî -- nant la queue, la queue dans la pous -- siè -- re
  il s'en al -- lait com -- battre les é -- lé -- phants.
  
  Ah les cro -- co -- co, les cro -- co -- co, les cro -- co -- di -- les
  sur les bords du Nil ils sont par -- tis n'en par -- lons plus
  Ah les cro -- co -- co, les cro -- co -- co, les cro -- co -- di -- les
  sur les bords du Nil ils sont par -- tis n'en par -- lons plus.
}

%{
2. Il fredonnait une marche militaire
Dont il mâchait les mots à grosses dents,
Quand il ouvrait la gueule tout entière
On croyait voir ses ennemis dedans

3. Il agitait sa grand' queue à l'arrière
Comm' s'il était d'avance triomphant
Les animaux devant sa mine altière
Dans les forêts s'enfuyaient tout tremblants

4. Un éléphant parut et sur la terre
Se prépara un combat de géants
Mais près de là, courait une rivière
Le crocodile s'y jeta subitement

5. Et tout rempli d'une crainte salutaire
S'en retourna vers ses petits enfants
Notre éléphant d'une trompe plus fière
Voulut alors accompagner ce chant
%}

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
      \chromaticHarmonicaTab \relative c' {
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

#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

