;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Tue Jul 27 23:52:20 2004
;;;; Contains: Tests of format with ~& directive

(in-package :cl-test)
(compile-and-load "printer-aux.lsp")

(def-format-test format.&.1
  "~0&" nil "")

(def-format-test format.&.2
  "~&" nil "")

(def-format-test format.&.3
  "X~&" nil #.(concatenate 'string "X" (string #\Newline)))

(def-format-test format.&.4
  "X~%~&" nil #.(concatenate 'string "X" (string #\Newline)))

(deftest format.&.5
  (loop for i from 1 to 100
	for s1 = (make-string (1- i) :initial-element #\Newline)
	for s2 = (format nil (format nil "~~~D&" i))
	unless (string= s1 s2)
	collect i)
  nil)

(deftest format.&.6
  (loop for i from 1 to 100
	for s1 = (concatenate 'string
			      "X"
			      (make-string i :initial-element #\Newline))
	for s2 = (format nil (format nil "X~~~D&" i))
	unless (string= s1 s2)
	collect i)
  nil)

(def-format-test format.&.7
  "~v&" (nil) "")

(def-format-test format.&.8
  "X~v&" (nil) #.(concatenate 'string "X" (string #\Newline)))

(deftest format.&.9
  (loop for i from 1 to 100
	for s1 = (make-string (1- i) :initial-element #\Newline)
	for s2 = (format nil "~V&" i)
	unless (string= s1 s2)
	collect i)
  nil)

(deftest format.&.10
  (loop for i from 1 to (min (- call-arguments-limit 3) 100)
	for s1 = (make-string (1- i) :initial-element #\Newline)
	for args = (make-list i)
	for s2 = (apply #'format nil "~#&" args)
	unless (string= s1 s2)
	collect i)
  nil)

(def-format-test format.&.11
  "X~V%" (0) "X")

(def-format-test format.&.12
  "X~#%" nil "X")

(def-format-test format.&.13
  "X~#%" ('a 'b 'c) #.(let ((nl (string #\Newline)))
			(concatenate 'string "X" nl nl nl))
  3)













