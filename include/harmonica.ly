%{
A small file to help when scoring notation for harmonicas.

This file relies heavily on work presented by Bradford Powell in
the following thread;

http://osdir.com/ml/lilypond-user-gnu/2010-04/msg00250.html
%}

\version "2.24.0"

flutter = #(define-event-function (parser location) ()
  #{ :32 #}
)

shake = #(define-event-function (parser location) ()
  #{ :32 #}
)


pull = {
   \once \override Staff.NoteHead.style = #'slash
  }

quartertone =
#(let ((m (make-articulation 'stopped)))
   (set! (ly:music-property m 'tweaks)
      (acons 'font-size 2 (ly:music-property m 'tweaks)))
   m)
slap =
#(let ((m (make-articulation 'flageolet)))
   (set! (ly:music-property m 'tweaks)
      (acons 'font-size -3 (ly:music-property m 'tweaks)))
   m)

dip =
#(let ((m (make-articulation 'upbow)))
   (set! (ly:music-property m 'tweaks)
      (acons 'font-size -3 (ly:music-property m 'tweaks)))
   m)

#(define (NoteEvent? music)
   (equal? (ly:music-property music 'name) 'NoteEvent))

#(define* (blow hole #:optional (bends 0))
  (case bends
    ((0) (markup (#:concat ("+" hole))))
    ((1) (markup (#:concat ("+" hole "'"))))
    ((2) (markup (#:concat ("+" hole "''"))))
    (else (markup "B"))))

#(define* (draw hole #:optional (bends 0))
  (case bends
    ((0) (markup (#:concat ("-" hole))))
    ((1) (markup (#:concat ("-" hole "'"))))
    ((2) (markup (#:concat ("-" hole "''"))))
    ((3) (markup (#:concat ("-" hole "'''"))))
    (else (markup "D"))))

#(define (overblow hole)
   (markup (#:concat ("+" hole "o"))))

#(define (overdraw hole)
   (markup (#:concat ("-" hole "o"))))

#(define (slide hole)
   (markup (#:concat (hole "<"))))

#(define (low-register hole)
   (markup (#:concat (hole "°"))))

%{ Changed by slist:
((7) (draw "2"))
((7) (blow "3"))
%}

#(define (get-diatonic-c-ritcher-tab NoteEvent)
   (case (ly:pitch-semitones (ly:music-property NoteEvent 'pitch))
    ((0) (blow "1"))
    ((1) (draw "1" 1))
    ((2) (draw "1"))
    ((3) (overblow "1"))
    ((4) (blow "2"))
    ((5) (draw "2" 2))
    ((6) (draw "2" 1))
    ((7) (draw "2")) ; can be (draw "2") or (blow "3")
    ((8) (draw "3" 3))
    ((9) (draw "3" 2))
    ((10) (draw "3" 1))
    ((11) (draw "3"))
    ((12) (blow "4"))
    ((13) (draw "4" 1))
    ((14) (draw "4"))
    ((15) (overblow "4"))
    ((16) (blow "5"))
    ((17) (draw "5"))
    ((18) (overblow "5"))
    ((19) (blow "6"))
    ((20) (draw "6" 1))
    ((21) (draw "6"))
    ((22) (overblow "6"))
    ((23) (draw "7"))
    ((24) (blow "7"))
    ((25) (overdraw "7"))
    ((26) (draw "8"))
    ((27) (blow "8" 1))
    ((28) (blow "8"))
    ((29) (draw "9"))
    ((30) (blow "9" 1))
    ((31) (blow "9"))
    ((32) (overdraw "9"))
    ((33) (draw "10"))
    ((34) (blow "10" 2))
    ((35) (blow "10" 1))
    ((36) (blow "10"))
    (else (markup "X"))))

#(define* (get-diatonic-ritcher-tab NoteEvent #:optional (root-semitones 0))
   (let ((semitones (- (ly:pitch-semitones (ly:music-property NoteEvent 'pitch)) root-semitones)))
     (case semitones
       ((0) (blow "1"))
       ((1) (draw "1" 1))
       ((2) (draw "1"))
       ((3) (overblow "1"))
       ((4) (blow "2"))
       ((5) (draw "2" 2))
       ((6) (draw "2" 1))
       ((7) (draw "2")) ; can be (draw "2") or (blow "3")
       ((8) (draw "3" 3))
       ((9) (draw "3" 2))
       ((10) (draw "3" 1))
       ((11) (draw "3"))
       ((12) (blow "4"))
       ((13) (draw "4" 1))
       ((14) (draw "4"))
       ((15) (overblow "4"))
       ((16) (blow "5"))
       ((17) (draw "5"))
       ((18) (overblow "5"))
       ((19) (blow "6"))
       ((20) (draw "6" 1))
       ((21) (draw "6"))
       ((22) (overblow "6"))
       ((23) (draw "7"))
       ((24) (blow "7"))
       ((25) (overdraw "7"))
       ((26) (draw "8"))
       ((27) (blow "8" 1))
       ((28) (blow "8"))
       ((29) (draw "9"))
       ((30) (blow "9" 1))
       ((31) (blow "9"))
       ((32) (overdraw "9"))
       ((33) (draw "10"))
       ((34) (blow "10" 2))
       ((35) (blow "10" 1))
       ((36) (blow "10"))
       (else (markup "X")))))

#(define (get-diatonic-d-ritcher-tab NoteEvent) (get-diatonic-ritcher-tab NoteEvent 2))
#(define (get-diatonic-g-ritcher-tab NoteEvent) (get-diatonic-ritcher-tab NoteEvent 7))
#(define (get-diatonic-a-ritcher-tab NoteEvent) (get-diatonic-ritcher-tab NoteEvent 9))
#(define (get-diatonic-f-ritcher-tab NoteEvent) (get-diatonic-ritcher-tab NoteEvent 5))
#(define (get-diatonic-bb-ritcher-tab NoteEvent) (get-diatonic-ritcher-tab NoteEvent 10))

#(define (get-chromatic-c-solo-tab NoteEvent)
   (case (ly:pitch-semitones (ly:music-property NoteEvent 'pitch))
    ((-12) (blow (low-register "1")))          
    ((-11) (blow (slide (low-register "1"))))  
    ((-10) (draw (low-register "1")))          
    ((-9) (draw (slide (low-register "1"))))   
    ((-8) (blow (low-register "2")))           
    ((-7) (draw (low-register "2")))           
    ((-6) (draw (slide (low-register "2"))))   
    ((-5) (blow (low-register "3")))           
    ((-4) (blow (slide (low-register "3"))))   
    ((-3) (draw (low-register "3")))           
    ((-2) (draw (slide (low-register "3"))))   
    ((-1) (draw (low-register "4")))           

    ((0) (blow "1"))           
    ((1) (slide (blow "1")))   
    ((2) (draw "1"))           
    ((3) (slide (draw "1")))    
    ((4) (blow "2"))           
    ((5) (draw "2"))           
    ((6) (slide (draw "2")))   
    ((7) (blow "3"))           
    ((8) (slide (blow "3")))   
    ((9) (draw "3"))           
    ((10) (slide (draw "3")))  
    ((11) (draw "4"))          

    ((12) (blow "5"))          
    ((13) (slide (blow "5")))   
    ((14) (draw "5"))           
    ((15) (slide (draw "5")))   
    ((16) (blow "6"))           
    ((17) (draw "6"))           
    ((18) (slide (draw "6")))   
    ((19) (blow "7"))           
    ((20) (slide (blow "7")))   
    ((21) (draw "7"))           
    ((22) (slide (draw "7")))  
    ((23) (draw "8"))          

    ((24) (blow "9"))           
    ((25) (slide (blow "9")))    
    ((26) (draw "9"))            
    ((27) (slide (draw "9")))   
    ((28) (blow "10"))           
    ((29) (draw "10"))           
    ((30) (slide (draw "10")))   
    ((31) (blow "11"))           
    ((32) (slide (blow "11")))   
    ((33) (draw "11"))           
    ((34) (slide (draw "11")))  
    ((35) (draw "12"))          

    ((36) (blow "12"))          
    ((37) (slide (blow "12")))  
    ((38) (slide (draw "12")))  
    (else (markup "X"))))


#(define (make-textscript dir txt)
   (make-music 'TextScriptEvent
               'direction dir
               'text txt))

%{ old version:
#(define (old-make-tab-number NoteEvent tuning)
   (make-textscript
     DOWN
     (case tuning
       ((diatonic-c-ritcher) (get-diatonic-c-ritcher-tab NoteEvent))
       ((chromatic-c-solo) (get-chromatic-c-solo-tab NoteEvent))
       (else (diatonic-c-ritcher) (get-diatonic-c-ritcher-tab NoteEvent)))))

 Changed by slist:
New version for multiple notes

#(define (make-tab-number music tuning)
  (if (NoteEvent? music)
      (get-diatonic-c-ritcher-tab music)
      ;; Si c’est un accord ou un ensemble de notes
      (markup
        (#:column
          (map (lambda (m)
                 (if (NoteEvent? m)
                     (get-diatonic-c-ritcher-tab m)
                     empty-markup))
               (ly:music-property music 'elements))))))
%}

%% Symbole affiché à la place du numéro pour une note liée / tenue.
%% Modifiable ici une seule fois : s'applique à toutes les partitions.
#(define tie-hold-markup (markup "~"))

#(define (tab-markup-for-note note tuning)
  (case tuning
    ((diatonic-c-ritcher) (get-diatonic-c-ritcher-tab note))
    ((diatonic-d-ritcher) (get-diatonic-d-ritcher-tab note))
    ((diatonic-g-ritcher) (get-diatonic-g-ritcher-tab note))
    ((diatonic-a-ritcher) (get-diatonic-a-ritcher-tab note))
    ((diatonic-f-ritcher) (get-diatonic-f-ritcher-tab note))
    ((diatonic-bb-ritcher) (get-diatonic-bb-ritcher-tab note))
    ((chromatic-c-solo) (get-chromatic-c-solo-tab note))
    (else (get-diatonic-c-ritcher-tab note))))

%% mode : 'number (numéro normal) ou 'hold (note liée/tenue → symbole)
#(define (make-tab-textscript note tuning mode)
   (make-textscript DOWN
     (if (eq? mode 'hold)
         tie-hold-markup
         (tab-markup-for-note note tuning))))

%% --- Détection des liaisons portées par une note ---
#(define (note-has-tie? note)
   (let loop ((arts (ly:music-property note 'articulations)))
     (cond ((null? arts) #f)
           ((eq? (ly:music-property (car arts) 'name) 'TieEvent) #t)
           (else (loop (cdr arts))))))

%% Renvoie -1 (début de slur), 1 (fin de slur), ou #f
#(define (note-slur-dir note)
   (let loop ((arts (ly:music-property note 'articulations)))
     (cond ((null? arts) #f)
           ((eq? (ly:music-property (car arts) 'name) 'SlurEvent)
            (ly:music-property (car arts) 'span-direction))
           (else (loop (cdr arts))))))

#(define (note-semitones note)
   (let ((p (ly:music-property note 'pitch)))
     (if (ly:pitch? p) (ly:pitch-semitones p) #f)))

%{
#(define (make-tab-numbers EventChord tuning)
   (let ((elts (ly:music-property EventChord 'elements)))
     (map make-tab-number (filter NoteEvent? elts))))

 Changed by slist:
New version for multiple notes
%}

%{ Wrong proposed by Gemini:
#(define (make-tab-numbers EventChord #:optional (tuning 'ignored))
   (let ((elts (ly:music-property EventChord 'elements)))
     (map make-tab-number (filter NoteEvent? elts))))
%}

#(define (append-property! music property element)
     (set! (ly:music-property music property)
                (append! (ly:music-property music property)
		                    (list element)))
				         music)

%% Parcours séquentiel à état : ajoute les numéros de tablature en tenant
%% compte des liaisons.
%%   - note prolongée par une liaison ~ (la précédente portait un ~)  -> symbole
%%   - note sous un slur ( ) ET de même hauteur que la précédente     -> symbole
%%   - sinon                                                          -> numéro
%% La 1re note d'un slur garde son numéro (vraie attaque) ; un silence
%% réinitialise l'état (la note suivante est une attaque fraîche).
#(define (make-tab-adder tuning)
   (lambda (top-music)
     (let ((prev-pitch #f)   ; demi-tons de la note précédente, ou #f
           (prev-tie?  #f)   ; la note précédente portait-elle un ~
           (in-slur?   #f))  ; sommes-nous à l'intérieur d'un slur

       (define (attach-note! note mode)
         (set! (ly:music-property note 'articulations)
               (append (ly:music-property note 'articulations)
                       (list (make-tab-textscript note tuning mode)))))

       (define (process-note! note)
         (let* ((p  (note-semitones note))
                (sd (note-slur-dir note))
                (mode (cond
                        (prev-tie? 'hold)
                        ((and in-slur? prev-pitch p (= p prev-pitch)) 'hold)
                        (else 'number))))
           (attach-note! note mode)
           ;; bornes de slur : mises à jour APRÈS le calcul du mode,
           ;; pour que la note d'ouverture garde son numéro.
           (cond ((eqv? sd -1) (set! in-slur? #t))
                 ((eqv? sd 1)  (set! in-slur? #f)))
           (set! prev-pitch p)
           (set! prev-tie? (note-has-tie? note))))

       (define (process-chord! chord)
         (let ((notes (filter NoteEvent? (ly:music-property chord 'elements))))
           (set! (ly:music-property chord 'elements)
                 (append (ly:music-property chord 'elements)
                         (reverse (map (lambda (n) (make-tab-textscript n tuning 'number))
                                       notes)))))
         (set! prev-pitch #f)
         (set! prev-tie? #f))

       (define (visit m)
         (cond
           ((not (ly:music? m)) #f)
           ((music-is-of-type? m 'event-chord) (process-chord! m))
           ((music-is-of-type? m 'note-event)  (process-note! m))
           ;; silences, skips… : rompent la continuité mélodique
           ((music-is-of-type? m 'rhythmic-event)
            (set! prev-pitch #f)
            (set! prev-tie?  #f))
           (else
            (let ((els (ly:music-property m 'elements)))
              (if (pair? els) (for-each visit els)))
            (let ((el (ly:music-property m 'element)))
              (if (ly:music? el) (visit el))))))

       (visit top-music)
       top-music)))

#(define add-diatonic-c-ritcher-tabs  (make-tab-adder 'diatonic-c-ritcher))
#(define add-diatonic-d-ritcher-tabs  (make-tab-adder 'diatonic-d-ritcher))
#(define add-diatonic-g-ritcher-tabs  (make-tab-adder 'diatonic-g-ritcher))
#(define add-diatonic-a-ritcher-tabs  (make-tab-adder 'diatonic-a-ritcher))
#(define add-diatonic-f-ritcher-tabs  (make-tab-adder 'diatonic-f-ritcher))
#(define add-diatonic-bb-ritcher-tabs (make-tab-adder 'diatonic-bb-ritcher))
#(define add-chromatic-c-solo-tabs    (make-tab-adder 'chromatic-c-solo))

diatonicHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-diatonic-c-ritcher-tabs music))

diatonicDHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-diatonic-d-ritcher-tabs music))

diatonicGHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-diatonic-g-ritcher-tabs music))

diatonicAHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-diatonic-a-ritcher-tabs music))

diatonicFHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-diatonic-f-ritcher-tabs music))

diatonicBbHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-diatonic-bb-ritcher-tabs music))

chromaticHarmonicaTab =
#(define-music-function
  (parser location music)
  (ly:music?)
  (add-chromatic-c-solo-tabs music))
