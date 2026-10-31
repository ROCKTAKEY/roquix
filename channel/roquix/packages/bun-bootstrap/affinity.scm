;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2026 ROCKTAKEY <rocktakey@gmail.com>
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.

(define-module (roquix packages bun-bootstrap affinity)
  #:export (call-with-limited-cpu-affinity))

(define (call-with-limited-cpu-affinity jobs thunk)
  "Call THUNK with this process restricted to at most JOBS CPUs.

Child processes inherit the restricted affinity.  Restore the original mask
when THUNK returns or raises an exception."
  (unless (and (integer? jobs) (positive? jobs))
    (error "CPU affinity job count must be a positive integer" jobs))
  (let* ((original (getaffinity 0))
         (limited (bitvector-copy original)))
    (let loop ((cpu 0)
               (remaining jobs))
      (when (< cpu (bitvector-length limited))
        (if (bitvector-bit-set? limited cpu)
            (if (positive? remaining)
                (loop (+ cpu 1) (- remaining 1))
                (begin
                  (bitvector-clear-bit! limited cpu)
                  (loop (+ cpu 1) remaining)))
            (loop (+ cpu 1) remaining))))
    (dynamic-wind
      (lambda ()
        (setaffinity 0 limited))
      thunk
      (lambda ()
        (setaffinity 0 original)))))
