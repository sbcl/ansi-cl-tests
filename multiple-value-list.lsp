;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Mon Feb 17 06:38:07 2003
;;;; Contains: Tests of MULTIPLE-VALUE-LIST

(in-package :cl-test)

(deftest multiple-value-list.1
  (multiple-value-list 'a)
  (a))

(deftest multiple-value-list.2
  (multiple-value-list (values))
  nil)

(deftest multiple-value-list.3
  (multiple-value-list (values 'a 'b 'c 'd 'e))
  (a b c d e))

(deftest multiple-value-list.4
  (multiple-value-list (values (values 'a 'b 'c 'd 'e)))
  (a))

(deftest multiple-value-list.5
  (multiple-value-list (values 'a))
  (a))

(deftest multiple-value-list.6
  (multiple-value-list (values 'a 'b))
  (a b))

(deftest multiple-value-list.7
  (not
   (loop
    for i from 0 below (min multiple-values-limit 100)
    for x = (make-list i :initial-element 'a)
    always (equal x (multiple-value-list (values-list x)))))
  nil)


(deftest multiple-value-list.order.1
  (let ((i 0))
    (values (multiple-value-list (incf i)) i))
  (1) 1)

#|
(deftest multiple-value-list.error.1
  (classify-error (multiple-value-list))
  program-error)

(deftest multiple-value-list.error.2
  (classify-error (multiple-value-list 'a 'b))
  program-error)
|#

(deftest multiple-value-list.error.1
  (classify-error (funcall (macro-function 'multiple-value-list)))
  program-error)
  
(deftest multiple-value-list.error.2
  (classify-error (funcall (macro-function 'multiple-value-list)
			   '(multiple-value-list nil)))
  program-error)

(deftest multiple-value-list.error.3
  (classify-error (funcall (macro-function 'multiple-value-list)
			   '(multiple-value-list nil)
			   nil nil))
  program-error)