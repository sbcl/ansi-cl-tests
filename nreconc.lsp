;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat Apr 19 22:38:12 2003
;;;; Contains: Tests of NRECONC

(in-package :cl-test)

(deftest nreconc.1
  (let* ((x (list 'a 'b 'c))
	 (y (copy-tree '(d e f)))
	 (result (nreconc x y)))
    (and (equal y '(d e f))
	 result))
  (c b a d e f))

(deftest nreconc.2
  (nreconc nil 'a)
  a)

(deftest nreconc.order.1
  (let ((i 0) x y)
    (values
     (nreconc (progn (setf x (incf i)) (copy-list '(a b c)))
	      (progn (setf y (incf i)) (copy-list '(d e f))))
     i x y))
  (c b a d e f) 2 1 2)

(deftest nreconc.error.1
  (classify-error (nreconc))
  program-error)

(deftest nreconc.error.2
  (classify-error (nreconc nil))
  program-error)

(deftest nreconc.error.3
  (classify-error (nreconc nil nil nil))
  program-error)

(deftest nreconc.error.4
  (classify-error (nreconc (cons 'a 'b) (list 'z)))
  type-error)
