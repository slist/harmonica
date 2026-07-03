\version "2.24.3"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

\header {
  title = "O sole mio!"
  composer = "E. di Capua (1865-1917)"
  poet = "G. Capurro (1879–1920)"
  lyricsLang = #'(it)
  copyrightStatus = "public-domain"
  composerNationality = "it"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

melodie = {
  %\key re \major % Tonalité de Ré majeur (fa♯, do♯)
  %\key fa \major % Tonalité de Fa majeur (sib♯)
  \key sol \major % Tonalité de Sol majeur (fa♯)
  \time 2/4
  %\tempo 4 = 80
  \tempo "Andantino." 4 = 84
  %\clef "treble^8"
  %r8 sol' sol fad | re2 | re8 fad fad mi | do2 | do8 fad fad mi |
  %\break
  \dynamicUp % forcer toutes les dynamiques au-dessus
  %r2 r r |
  r8 re\p do si | la4 sol | 
  %\break
  sol8 la si sol | fad4 mi~ | mi8 fad sol la | fad mi mi4~ | mi8 fad sol la |
  %\break
  mi (re) re4~ | re8 re' do si | la~ la sol4 | sol8 la si sol | fad4 mi~ |
  %\break
  mi8 do'\<^\markup { cresc. } si la\! | re si la sol | la4. si8 | \tuplet 3/2 { la16 (si la) } sol4.~ | sol8 sol'\mf sol fad |
  %\break
  re4 re~ | re8 fad fad mi | do2~ | do8 fad fad mi | do4 do~ | do8 la si do |
  %\break
  re2~ | re4 r8 re\f | mib2~ | mib8 do sol' mib | re4 re~ |
  %\break
  re8 si\p la sol | re'2~ | re8 si la8.\fermata fad16 | sol2~ | sol8 r8 r4 |
  \bar "|."
}
\addlyrics {
  %"" "" "" "" "" "" "" "" "" "" "" "" ""
  Che bel -- la co -- sa
  'na iur -- na -- ta'e so -- le, n'a -- ria se -- re -- na dop -- po 'na tem -- pe -- sta!
  Pe' ll'a -- ria fre -- sca pa -- re già 'na fe -- sta -- 
  Che bel -- la co -- sa 'na iur -- na -- ta'e so -- le. Ma n'a -- tu
  so -- le cchiù bel -- lo,ohi -- nè, 'o so -- le mi -- o sta nfron -- te_a
  te, 'o so -- -- -le'o so -- le mi -- o
  -- sta nfron -- te_a te, sta nfron -- te_a te!
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
    \tempo 4 = 84
  }
}

% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
%\diatoniqueScore
%\chromatiqueScore
%\midiScore
