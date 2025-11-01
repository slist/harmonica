\version "2.24.3"

\header {
  title = "Mon beau sapin"
  instrument = "Harmonica en C"
  composer = "Tonton Stéphane"
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

melodie = {
  \time 3/4
  r2 r8 g'8
  c8. c16 c4. 
  d8 e8. e16 e4. 
  e8 d e f4 b, d c 
  r8
  g'8 g e a4. 
  g8 g f f4. 
  f8 f d g4. 
  f8 f e e4
  r8
  g,8
  c8. c16 c4.
  d8 e8. e16 e4.
  e8 d e f4 b, d c
  r8
  \bar "|."
}
\addlyrics {
  Mon beau sa -- pin, roi des fo -- rêts, que j'ai -- me ta ver -- du -- re!
  Quand par l'hi -- ver bois et gué -- rets sont dé -- pouil -- lés de leurs at -- traits
  Mon beau sa -- pin, roi des fo -- rêts, tu gar -- des ta pa  -- ru -- re.
}

%{
2. Toi que Noël Planta chez nous,
au saint anniversaire,
joli sapin, comme ils sont doux
Ee tes bonbons et tes joujoux.
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
    \relative c'' {
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

