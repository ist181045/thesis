#lang racket
(require "../core/entities-declaration.rkt"
         "../mathematical-module/geometric-restrictions.rkt"
         "../core/dispatcher.rkt"
         "../core/communication.rkt")
;(time-apply sleep '(0.1))
;(displayln (current-seconds))
;(displayln (current-inexact-milliseconds))
;(displayln (current-milliseconds))
;(displayln (current-process-milliseconds 'subprocesses))

(define (benchmark-dispatcher e1 e2 [times 1000])
  (displayln "# new benchmark")
  (define seq (stream->list (in-range 0 times 1)))
  (collect-garbage)
  (time (for ([i seq])
          (intersection-dispatcher e1 e2)))
  (collect-garbage)
  (time (for ([i seq])
          (intersection e1 e2))))

(define l-l
  (list (cons (new-line  (new-point 7 10) (new-point 7 -10)) (new-line  (new-point 0 5) (new-point 15 5)))
        (cons (new-line  (new-point 1 0) (new-point 3 0)) (new-line  (new-point 1 1) (new-point 3 1)))))
(define c-l
  (list (cons (new-circle  (new-point 0 0) 1) (new-line  (new-point -5 0) (new-point 5 0))) ;'((1 0) (-1 0))
        (cons (new-circle  (new-point 0 0) 1) (new-line  (new-point -5 1) (new-point 5 1))) ;'((0 1))
        (cons (new-circle  (new-point 0 0) 0.5) (new-line  (new-point -5 1) (new-point 5 1)))))
(define c-c
  (list (cons (new-circle  (new-point 0 0) 1) (new-circle  (new-point 0 0) 2))
        (cons (new-circle  (new-point 0 0) 10) (new-circle  (new-point 1 0) 1.5))
        (cons (new-circle  (new-point 100 0) 1) (new-circle  (new-point 10 0) 2))
        (cons (new-circle  (new-point 1 -2) 3) (new-circle  (new-point 1 -2) 3))
        (cons (new-circle  (new-point 0 0) 1) (new-circle  (new-point 0 2) 1)) ;'(tangent 0 . 1)) ;tagente
        (cons (new-circle  (new-point 0 0) 1.5) (new-circle  (new-point 1 0) 1.5)) ;'(intersections (0.5 . 1.414213562373095) 0.5 . -1.414213562373095))
        (cons (new-circle  (new-point 0 0) 1.5) (new-circle  (new-point 1 0) 1)) ;'(intersections (1.125 . 0.9921567416492215) 1.125 . -0.9921567416492215))
        (cons (new-circle  (new-point 0 0) 1.5) (new-circle  (new-point 1 1) 1)))) ;'(intersections (0.13070549283526772 . 1.4942945071647322) 1.4942945071647322 . 0.13070549283526772))

(displayln "### Time for start-maxima ###")
(time (start-maxima))
(displayln "### intersection-line-line ###")
(for ([i l-l])
  (benchmark-dispatcher (car i) (cdr i)))
(displayln "### intersection-circle-line ###")
(for ([i c-l])
  (benchmark-dispatcher (car i) (cdr i)))
(displayln "### intersection-circle-circle ###")
(for ([i c-c])
  (benchmark-dispatcher (car i) (cdr i)))
