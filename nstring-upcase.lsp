;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Thu Oct  3 21:12:40 2002
;;;; Contains: Tests for NSTRING-UPCASE

(in-package :cl-test)

(deftest nstring-upcase.1
  (let* ((s (copy-seq "a"))
	 (s2 (nstring-upcase s)))
    (values (eqt s s2) s))
  t "A")

(deftest nstring-upcase.2
  (let* ((s (copy-seq "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"))
	 (s2 (nstring-upcase s)))
    (values (eqt s s2) s))
  t
  "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ")  

(deftest nstring-upcase.3
  (let* ((s (copy-seq "0123456789!@#$%^&*()_-+=|\\{}[]:\";'<>?,./ "))
	 (s2 (nstring-upcase s)))
    (values (eqt s s2) s))
  t
  "0123456789!@#$%^&*()_-+=|\\{}[]:\";'<>?,./ ")

(deftest nstring-upcase.6
  (let* ((s (make-array 6 :element-type 'character
			:initial-contents '(#\a #\b #\c #\d #\e #\f)))
	 (s2 (nstring-upcase s)))
    (values (eqt s s2) s))
  t "ABCDEF")

(deftest nstring-upcase.7
  (let* ((s (make-array 6 :element-type 'standard-char
			:initial-contents '(#\a #\b #\7 #\d #\e #\f)))
	 (s2 (nstring-upcase s)))
    (values (eqt s s2) s))
  t "AB7DEF")

;; Tests with :start, :end

(deftest nstring-upcase.8
  (let ((s "abcdef"))
    (loop for i from 0 to 6
	  collect (nstring-upcase (copy-seq s) :start i)))
  ("ABCDEF" "aBCDEF" "abCDEF" "abcDEF" "abcdEF" "abcdeF" "abcdef"))

(deftest nstring-upcase.9
  (let ((s "abcdef"))
    (loop for i from 0 to 6
	  collect 
	  (nstring-upcase (copy-seq s) :start i :end nil)))
  ("ABCDEF" "aBCDEF" "abCDEF" "abcDEF" "abcdEF" "abcdeF" "abcdef"))

(deftest nstring-upcase.10
  (let ((s "abcde"))
     (loop for i from 0 to 4
	   collect (loop for j from i to 5
			 collect (nstring-upcase (copy-seq s)
						 :start i :end j))))
  (("abcde" "Abcde" "ABcde" "ABCde" "ABCDe" "ABCDE")
   ("abcde" "aBcde" "aBCde" "aBCDe" "aBCDE")
   ("abcde" "abCde" "abCDe" "abCDE")
   ("abcde" "abcDe" "abcDE")
   ("abcde" "abcdE")))

(deftest nstring-upcase.order.1
  (let ((i 0) a b c (s (copy-seq "abcdef")))
    (values
     (nstring-upcase
      (progn (setf a (incf i)) s)
      :start (progn (setf b (incf i)) 1)
      :end   (progn (setf c (incf i)) 4))
     i a b c))
  "aBCDef" 3 1 2 3)

(deftest nstring-upcase.order.2
  (let ((i 0) a b c (s (copy-seq "abcdef")))
    (values
     (nstring-upcase
      (progn (setf a (incf i)) s)
      :end   (progn (setf b (incf i)) 4)
      :start (progn (setf c (incf i)) 1))
     i a b c))
  "aBCDef" 3 1 2 3)

  
;;; Error cases

(deftest nstring-upcase.error.1
  (classify-error (nstring-upcase))
  program-error)

(deftest nstring-upcase.error.2
  (classify-error (nstring-upcase (copy-seq "abc") :bad t))
  program-error)

(deftest nstring-upcase.error.3
  (classify-error (nstring-upcase (copy-seq "abc") :start))
  program-error)

(deftest nstring-upcase.error.4
  (classify-error (nstring-upcase (copy-seq "abc") :bad t
				      :allow-other-keys nil))
  program-error)

(deftest nstring-upcase.error.5
  (classify-error (nstring-upcase (copy-seq "abc") :end))
  program-error)

(deftest nstring-upcase.error.6
  (classify-error (nstring-upcase (copy-seq "abc") 1 2))
  program-error)
