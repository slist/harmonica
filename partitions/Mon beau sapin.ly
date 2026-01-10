\version "2.24.3"

\header {
  title = "Mon beau sapin"
  subtitle = "O Tannenbaum"
  composer = "Ernst Anschütz (1780 - 1861)"
  tagline = ##f
}

%Source:
%notes: http://harmonicacomte.blogspot.com/search/label/pour%20d%C3%A9buter
%rythme et paroles: https://www.petiteguitare.fr/mon-beau-sapin/

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\layout {
  \context {
    \Lyrics
    \override LyricText.font-size = #+1
    \override LyricHyphen.minimum-distance = #0.5
    \override LyricSpace.minimum-distance = #0.6
  }
}

\paper {
  markup-system-spacing.basic-distance = #20 % Espace entre titre et première portée
  system-system-spacing.basic-distance = #20 % Espace entre les portées
}

melodie = {
  \time 3/4
  \tempo 4 = 80 % Caractère : Andante (calme, chantant)
  
  r2 r8 g'8 | c8. c16 c4. d8 | e8. e16 e4. 
  \break
  e8 | d e f4 b, | d c
  \break
  r8 g'8 | g e a4. g8 | g f f4. 
  \break
  f8 | f d g4. f8 | f e e4
  \break
  r8 g,8 | c8. c16 c4. d8 | e8. e16 e4.
  \break
  e8 d e f4 b, | d c  r4
  \bar "|."
}
\addlyrics {
  Mon beau sa -- pin, roi des fo -- rêts, que j'ai -- me ta ver -- du -- re!
  Quand par l'hi -- ver bois et gué -- rets sont dé -- pouil -- lés de leurs at -- traits
  Mon beau sa -- pin, roi des fo -- rêts, tu gar -- des ta pa -- ru -- re.
}

%{
2. Toi que Noël Planta chez nous,
au saint anniversaire,
joli sapin, comme ils sont doux
Et tes bonbons et tes joujoux.
Toi que Noël planta chez nous
par les mains de ma mère.

3. Mon beau sapin, tes verts sommets,
et leur fidèle ombrage,
de la foi qui ne ment jamais,
de la constance et de la paix.
Mon beau sapin, tes verts sommets,
m’offrent la douce image.
%}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new Staff { 
      \diatonicHarmonicaTab \relative c' {
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
    \relative c' {
      \melodie
    }
  }
  \midi {
    \tempo 4 = 80
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
