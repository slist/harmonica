\version "2.24.3"

\header {
  title = "Blowin' In The Wind"
  instrument = "Harmonica en C"
  composer = "Bob Dylan" % May 24, 1941 -
  tagline = ##f
}

\include "harmonica.ly"
\include "style.ly"


% Options de compilation personnalisées

#(define compile-diatonique (ly:get-option 'compile-diatonique))
#(define compile-chromatique (ly:get-option 'compile-chromatique))
#(define compile-midi (ly:get-option 'compile-midi))

melodie = {
%  \key g \major % Tonalité de Sol majeur (fa♯)
  \time 4/4
  %\key ees \major % Tonalité de Mi♭ majeur (si♭, mi♭, la♭)
  %\tempo "Moderato"
  
  g2 g4 g | a2 g4 f | g2 e4 ( d ) | c2.
  e4 | g2. g4 a2 g4 f g1
  \break
  
  %bes2 bes4 bes | c2  bes4 aes | bes2 g4 f | ees2.
  

 %{

https://youtu.be/vWwgrjjIMXA?si=sVVqQMQUMc4FRMzB

6   6 6  -6    6   -5  6  5 -4  4 
How many roads must a man walk down 
 5  6   6   -6   6 -5  6 
Before you call him a man? 
 5  -5   6  6 6  -6    
Yes ’n’ how many seas  
 6  -5   6   5 -4  4 
Must a white dove sail 
5  6    6    -5   -5  5   -4 
Before she sleeps in the sand? 
 5  -5   6   6 6  -6    
Yes 'n' how many times  
 6   -5   6   6   -5    4 
Must the cannon balls fly 
5  6      6    -6 6 -5    6 
Before they're forever  banned? 
 5  -5 -5    5   -4     
The answer, my friend,  
-4 5  5    5  -4   4 
Is blowin' in the wind, 
 5  -5 -5   5 -4  -4  4  -3   4 
The answer is blowin' in the wind.


 %}


  \bar "|."
}
\addlyrics {
How man -- y roads must a man walk down
Be -- fore you call him a man?
How many seas must a white dove sail
Before she sleeps in the sand?
Yes, and how many times must the cannonballs fly
Before they're forever banned?
The answer, my friend, is blowin' in the wind
The answer is blowin' in the wind
Yes, and how many years must a mountain exist
Before it is washed to the sea?
And how many years can some people exist
Before they're allowed to be free?
Yes, and how many times can a man turn his head
And pretend that he just doesn't see?
The answer, my friend, is blowin' in the wind
The answer is blowin' in the wind
Yes, and how many times must a man look up
Before he can see the sky?
And how many ears must one man have
Before he can hear people cry?
Yes, and how many deaths will it take 'til he knows
That too many people have died?
The answer, my friend, is blowin' in the wind
The answer is blowin' in the wind
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
    \tempo 4 = 140
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

