\version "2.26.0"

\header {
  title = "Jambalaya"
  subtitle = "(On the Bayou)"
  subsubtitle = "Melody derived from \"Grand Texas\""
  date = "1952"  
  composer = \markup {
    \column {
      "Hank Williams (1923–1953)"
      "likely influenced by"
      "Moon Mullican (1909–1967)"
    }
  }  %poet = ""
  instrument = "Harmonica diatonique en Do (C)"
  enteredby = "Stéphane List"
  source = "https://musescore.com/user/28724592/scores/6368818"
  lyricsLang = #'(en)
  copyrightStatus = "copyrighted" % renouvellement du copyright en 1980 par Sony/ATV Acuff Rose Music
  composerNationality = "us"
  youtube = "https://www.youtube.com/watch?v=A1SFjLOr4QE"
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
  \tempo 4 = 90
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
  %\key fa  \major  % 1b - sib
  %\key sib \major  % 2b - sib, mib
  %\key mib \major  % 3b - sib, mib, lab
  %\key lab \major  % 4b - sib, mib, lab, reb
  %\key reb \major  % 5b - sib, mib, lab, reb, solb
  %\key solb \major % 6b - sib, mib, lab, reb, solb, dob
  %\key dob \major  % 7b - sib, mib, lab, reb, solb, dob, fab

  si4. si8 la4 sol | la2 sol4. mi8 | re4 do2.~ | do4 r4 mi sol | 
  \repeat volta 3 {
    la2 mi4 
    
    \once \override Tie.dash-definition = #'((0 1 0.5 0.5))
     sol8~ sol
    
    \break
    
    \once \override Tie.dash-definition = #'((0 1 0.5 0.5))
    la4.~ la8
    
    sol4 mi | sol ré2.~ | ré4 r4 sol 
    
    \once \override Tie.dash-definition = #'((0 1 0.5 0.5))
    sol8~ sol
    
    \once \override Tie.dash-definition = #'((0 1 0.5 0.5))
    si4.~ si8
    
    si4. si8 | 
    
    \once \override Slur.dash-definition = #'((0 1 0.5 0.5))
    la4 ( sol )
    
    la4. sol8 | 
    \break

    sol4 mi2.~ | mi4 r4 do' do | do4. do8 la4 sol4 | do2 la4 sol | sol re2.~ re4 r4 sol8 sol sol4 | 
    \break
    si4. si8 la4 sol | la2 sol4. mi8 | re4 do2.~ | do4 r4 mi' mi \bar "||" mi8 mi mi mi do4 la |
    \break
    do4. do8 la4 sol | sol ré2.~ | ré4 r4 sol sol | si4. si8 si4 la | sol8 sol4 sol8 la4 sol | sol mi2.~ |
    \break
    mi4 r4 do' do | do2 la4 sol | do2 la4 sol | sol ré2.~ | ré4 r4 sol8 sol sol4 | si4. si8 la4 sol |
    \break
    la2 sol4. mi8 | 
 
  }
  \alternative {
    \volta 1,2 {
      re4 do2.~ | do4 r4 mi sol 
    }
    \volta 3 {
      re4 do2.~ | do2. r4 |
    }
  }
  \bar "|."
}
\addlyrics {
  _ _ _ _ _ _ _ _ _
  Good -- bye, Joe, me
  
  \set ignoreMelismata = ##t   % Un mélisme, c'est quand une seule syllabe est chantée sur plusieurs notes successives.
  got  ta 
  \unset ignoreMelismata
  
  go, __ me oh my oh. __ Me 
  
  \set ignoreMelismata = ##t
  got -- ta 
  \unset ignoreMelismata
  
  go __ pole the
  
  \set ignoreMelismata = ##t
  pi -- rogue
  \unset ignoreMelismata
  
  down the
  bay -- ou. __ My Y -- vonne, the sweet -- est one, me oh my oh. __ Son of a 
  gun, we'll have big fun on the bay -- ou. __ Jam -- ba -- la -- ya and a craw -- fish
  pie and fi -- lé gum -- bo, __ 'cause to -- night I'm gon -- na see my ma cher a -- mi -- o.__
  Pick gui -- tar, fill fruit jar and be gay -- o. __ Son of a gun, we'll have big
  fun on the bay -- ou. __ Thi -- bo -- bay -- ou. __
}

accords = \chordmode {
  s1 s1 s1 s1
  \repeat volta 3 {
    do q
    sol:7 q q q 
    do q q q
    sol:7 q q q
    do q q q
    sol:7 q q q
    do q q q
    sol:7 q q q
  }
  \alternative {
    \volta 1,2 { do q }
    \volta 3 { do q }
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
      \diatonicHarmonicaTab \relative do''' {
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
    \tempo 4 = 90
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
    \tempo 4 = 90
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

\markup {
  \column {
    \vspace #1
    \fill-line { \bold "Commentaires" }
  }
}

\markup {
  \column {
    \line { \bold "À propos des liaisons pointillées" }
    \vspace #0.5
    \line { "Les liaisons pointillées utilisées dans cette transcription indiquent une continuité de phrasé," }
    \line { "notamment dans les passages où un" \bold "mélisme" "fait correspondre plusieurs notes à une même syllabe." }
    \line { "Elles permettent de distinguer visuellement ce phrasé des liaisons de prolongation traditionnelles," }
    \line { "qui indiquent qu'une même note doit être tenue sur plusieurs temps." }
  }
}

% CI-IGNORE-BELOW : lignes de test manuel local, toujours ignorées par la compilation GitHub Actions
\diatoniqueScore
%\chromatiqueScore
%\partitionScore
\midiScore
%\accompagnementMidiScore