\version "2.26.0"

\header {
  title = "The Parting Glass"
  subtitle = "Scottish Traditional Song"
  %subsubtitle = ""
  %date = ""
  composer = "Traditional"
  %poet = ""
  instrument = "Harmonica diatonique en Sib (Bb) played in 3rd position"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/28724592/scores/6357254"
  lyricsLang = #'(en)
  copyrightStatus = "public-domain"
  composerNationality = "gb" % ou SCO ?
  youtube = "https://www.youtube.com/watch?v=chOiVoScz8A"
}

\include "../include/harmonica.ly"
\include "../include/style.ly"

\language "français"

% Options de compilation personnalisées
#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))
#(define compile-partition (ly:get-option 'compile-partition))

melodie = {
  %\time 3/4
  \tempo 4 = 112
  %\clef "treble^15"
  %    \ottava #2

  \clef "treble^8"
  %\clef "treble_8"

  % DIESE
  %\key sol \major % Sol majeur (un dièse : fa♯)
  %\key re \major % Ré majeur (fa♯, do♯)
  %\key la \major % La majeur (trois dièses : fa♯, do♯, sol♯)
  %\key mi \major % Mi majeur (quatre dièses : fa♯, do♯, sol♯, ré♯)
  %\key si \major % Si majeur (cinq dièses : fa♯, do♯, sol♯, ré♯, la♯)
  %\key fad \major % Fa♯ majeur (six dièses : fa♯, do♯, sol♯, ré♯, la♯, mi♯)
  %\key dod \major % Do♯ majeur (sept dièses : fa♯, do♯, sol♯, ré♯, la♯, mi♯, si♯)


  % BÉMOLS
  %\key do  \major  % 0 - aucune altération
  \key fa  \major  % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  \repeat volta 3 {
    \partial 4 % anacrouse
    la'8 ( sol ) | fa4 ré ré do8 ré | fa4 fa sol fa8 (sol ) | la4 la la8 (sol) fa (sol) |
    %\break
    la4 do do la8 ( sol ) | fa4 re re do8 ( re ) | fa4 fa sol fa8 ( sol ) |
    %\break
    la4 re do8 ( la ) sol ( la ) | fa4 ré ré\fermata do'4 | do8 (la) do (ré) do4 do |
    %\break
    do8 (la) do (ré) do4. la8 | sib4 la la8 (sol) fa (sol) | la4 do, do la'8 (sol) |
    %\break
    fa4 ré ré do8 (ré) | fa4 fa sol fa8 (sol) | la4 ré do8 (la) sol (la) | fa4 ré ré\fermata
  }
  \bar ":|."
}
\addlyrics {
  Oh, all the mon -- ey that e're I had, I've spent it in good
  com -- pan -- y. And all the harm that e're I've done, A
  las 'twas done to none but me. And all I've done for
  want of wit To mem -- 'ry now I can't re -- call. So
  fill to me the part -- ing glass. Good night and joy be with you all.
}
\addlyrics {
  If I had mon -- ey e -- nough to spend, And lei -- sure time to
  sit a while, There is a fair maid in the town Who
  sore -- ly has my heart be -- guiled Her ros -- y cheeks and
  ru -- by lips I own she has my heart in thrall. So
  fill to me the part -- ing glass. Good night and joy be with you all.
}
\addlyrics {
  Oh, all the com -- rades that e'er I had, They're sor -- ry for my
  going a -- way. And all the sweet -- "hearts that" e'er I had, They'd
  wish me one more day to stay. But since it falls un -- to my lot
  That I should go and you should not,
  I'll gent -- ly rise and soft -- ly call,
  Good night and joy be with you all.
}

% TODO : check si c'est des s ou q qu'il faut faire
accords = \chordmode {
  \repeat volta 3 {
    s4 re2:m sib fa/la do fa sib 
    la:m do re:m sib fa/la do
    fa4 sib fa/la do ré:m s4 s s fa2 do/mi
    ré:m la:m sol:m fa/la sib do:7
    ré:m sib fa/la do fa4 sib fa/la do ré:m s s
  }
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \accords
    }
    \new Staff { 
      \diatonicBbHarmonicaTab \relative do''' {
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
      \set chordChanges = ##t
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

% ===========================================
% SCORE PARTITION (sans tablature harmonica)
% ===========================================

partitionScore =
\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \accords
    }
    \new Staff {
      \relative do''' {
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
  <<
    % Noms des accords sur la partition
    \new ChordNames {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \unfoldRepeats \relative do'' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \unfoldRepeats \accords
    }
  >>

  \midi {
    \tempo 4 = 112
  }
}

accompagnementMidiScore =
\score {
  <<
    % Noms des accords sur la partition
    \new ChordNames {
      \accords
    }

    % Mélodie
    \new Staff {
      \set Staff.midiInstrument = #"harmonica"
      \set Staff.midiMinimumVolume = #0.25
      \set Staff.midiMaximumVolume = #0.25
      \unfoldRepeats \relative do'' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \unfoldRepeats \accords
    }
  >>

  \midi {
    \tempo 4 = 112
  }
}


% Inclusion conditionnelle des scores
#(if compile-diatonique
     (ly:parser-include-string "\\diatoniqueScore"))
#(if compile-chromatique
     (ly:parser-include-string "\\chromatiqueScore"))
#(if compile-partition
     (ly:parser-include-string "\\partitionScore"))
#(if compile-midi
     (ly:parser-include-string "\\midiScore"))

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
%\chromatiqueScore
%\partitionScore
\midiScore
%\accompagnementMidiScore