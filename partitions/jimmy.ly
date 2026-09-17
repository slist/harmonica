\version "2.24.3"

\header {
  title = "Jimmy"
  %subtitle = ""
  %subsubtitle = ""
  date = "2007"  
  composer = "Moriarty"
  poet = "Adam Roberts, Arthur B. Gillette"
  %instrument = "Harmonica diatonique en Ré (D)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/27899818/scores/25045141"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted"
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=lnbl94GZ6TM"
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
  \time 4/4
  %\tempo 4 = 80
  \clef "treble^8"
  %\clef "treble_8"

  %\key sol \major % Sol majeur (un dièse : fa♯)
  % \key re \major % Ré majeur (fa♯, do♯)
  %\key sib \major  % Si♭ (Si♭, Mi♭)


  % BÉMOLS
  %\key do  \major  % 0 - aucune altération
  %\key fa  \major  % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  \key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  mib,8 fa ( fa reb reb4 )  fa8. reb16 

  %\partial 4. % 3 croches = 1.5 noire
  %r4. % avec "partial", le compte des mesures est pas bon :-<
  %la8 re fad  | la4. la8 fad8 re | si4. la8 sol fad | la2.~ | la4. la8 re fad |
  %\break
  %la4. la8 fad re | si4. la8 sol fad | la2.~ | la4. la8 si re |
  %\break
  %mi4. re8 mi fad | mi re4. si8 la | la2.~ | la4. la8 si re |
  %\break
  %mi4. re8 mi fad | mi re4. si8 la | la'2~ la8 si | la2 re,8 dod |
  %\break
  %re2 re8 dod | re2 re8 dod | re4. re8 re dod | re4 sol4. fad8 |
  %\break
  %re2 re8 dod | re2 si8 la | si2~ si8 la16 si | la2 re8 dod |
  %\break
  %si4. dod8 re4 | dod re mi  | fad4. sol8 fad mi | re2 re8 dod |
  %\break
  %si4 dod re | mi re4. dod8 | re2.~ | re4.
  \bar "|."
}
\addlyrics {
  Jim -- my, won't you 
  please come home?
  Where the grass is green and the buffaloes roam
  Come see Jimmy, your uncle Jim
  And your auntie Jim and your cousin Jim
  Come home Jimmy 'cause you need a bath
  And your grandpa Jimmy is still gone daft
  Now there's Buffalo Jim and Buffalo Jim
  There's Jim Buffalo now da-didn't you know?
  Jim, Jimmy, Jimmy it's your last cigarette
  And there's buffalo piss, it's all kind of wet
  Jambo Jimmy you'd better hold your nose
  All roads lead to roam with the buffaloes
  And the buffaloes used to say, "Be proud of your name"
  The buffaloes used to say, "Be what you are"
  The buffaloes used to say, "Roam where you roam"
  The buffaloes used to say, "Do what you do"
  Hey, you've gotta have a wash but you can't clean your name
  You're now called Jimmy, you'll be Jimmy just the same
  The keys are in the bag in the chest by the door
  One of Jimmy's friends has taken the floor
  Jimmy, won't you please come home?
  Where the grass is green and the buffaloes roam
  Dear old Jimmy, you've forgotten you're young
  But you can't ignore the buffalo song
  And the buffaloes used to say, "Be proud of your name"
  The buffaloes used to say, "Be what you are"
  The buffaloes used to say, "Roam where you roam"
  The buffaloes used to say, "Do what you do"
  If you remember you're unknown
  The buffalo land will be your home
  If you remember you're unknown
  Buffalo land will be your home
  If you remember you're unknown
  Buffalo land will be your home
  If you remember you're unknown
  Buffalo land will be your home
}

accords = \chordmode {
  % r2. Ca écrit "N.C.". s = skip, r = rest
  %s2. re sol re s
  %re sol mi:m la:7
  %mi:m sol re s
  %sol mi:m la s
  %re mi:m7 re:5/fad sol
  %re si:m mi:m la:7
  %sol la si:m re:7
  %sol la:7 re re
}

% ============================
% SCORE DIATONIQUE
% ============================

diatoniqueScore = 
\score {
  <<
    \new ChordNames {
      \accords
    }
    \new Staff { 
      \diatonicDHarmonicaTab \relative do''' {
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
      \chromaticHarmonicaTab \relative do''' {
        \melodie
      }
    }
  >>
  \layout { }
}

% ============================
% SCORE PARTITION (sans tablature harmonica)
% ============================

partitionScore =
\score {
  <<
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
      \relative do''' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \accords
    }
  >>

  \midi {
    \tempo 4 = 80
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
      \set Staff.midiMinimumVolume = #0.5
      \set Staff.midiMaximumVolume = #0.5
      \relative do''' {
        \melodie
      }
    }

    % Accords joués au piano
    \new Staff {
      \set Staff.midiInstrument = #"acoustic grand"
      \accords
    }
  >>

  \midi {
    \tempo 4 = 80
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
%\diatoniqueScore
\chromatiqueScore
\midiScore
%\accompagnementMidiScore
