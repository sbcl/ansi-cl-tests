;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat May 17 09:16:20 2003
;;;; Contains: Tests of MAKE-LOAD-FORM

(in-package :cl-test)

;;; These tests are just of MAKE-LOAD-FORM itself; tests of file compilation
;;; that depend on MAKE-LOAD-FORM will be found elsewhere.

(defclass make-load-form-class-01 () (a b c))

(deftest make-load-form.1
  (handler-case
   (progn (make-load-form (make-instance 'make-load-form-class-01))
	  :bad)
   (error () :good))
  :good)

(defstruct make-load-form-struct-02 a b c)

(deftest make-load-form.2
  (handler-case
   (progn (make-load-form (make-make-load-form-struct-02)) :bad)
   (error () :good))
  :good)

(define-condition make-load-form-condition-03 () (a b c))

(deftest make-load-form.3
  (handler-case
   (progn (make-load-form (make-condition 'make-load-form-condition-03) :bad))
   (error () :good))
  :good)

;;; Make sure these errors are due to the method, not due to lack of
;;; methods

(deftest make-load-form.4
  (let* ((obj (make-instance 'make-load-form-class-01))
	 (fun #'make-load-form)
	 (methods (compute-applicable-methods fun (list obj))))
     (notnot-mv methods))
  t)

(deftest make-load-form.5
  (let* ((obj (make-make-load-form-struct-02))
	 (fun #'make-load-form)
	 (methods (compute-applicable-methods fun (list obj))))
    (notnot-mv methods))
  t)

(deftest make-load-form.6
  (let* ((obj (make-condition 'make-load-form-condition-03))
	 (fun #'make-load-form)
	 (methods (compute-applicable-methods fun (list obj))))
    (notnot-mv methods))
  t)

(deftest make-load-form.7
  (let* ((obj (make-instance 'make-load-form-class-01))
	 (fun #'make-load-form)
	 (methods (compute-applicable-methods fun (list obj nil))))
    (notnot-mv methods))
  t)

(deftest make-load-form.8
  (let* ((obj (make-make-load-form-struct-02))
	 (fun #'make-load-form)
	 (methods (compute-applicable-methods fun (list obj nil))))
    (notnot-mv methods))
  t)

(deftest make-load-form.9
  (let* ((obj (make-condition 'make-load-form-condition-03))
	 (fun #'make-load-form)
	 (methods (compute-applicable-methods fun (list obj nil))))
    (notnot-mv methods))
  t)
  
(deftest make-load-form.10
  (macrolet
      ((%m (&environment env)
	   (let* ((obj (make-instance 'make-load-form-class-01))
		  (fun #'make-load-form)
		  (methods (compute-applicable-methods fun (list obj env))))
	     (notnot-mv methods))))
    (%m))
  t)

(deftest make-load-form.11
  (macrolet
      ((%m (&environment env)
	   (let* ((obj (make-make-load-form-struct-02))
		  (fun #'make-load-form)
		  (methods (compute-applicable-methods fun (list obj env))))
	     (notnot-mv methods))))
    (%m))
  t)

(deftest make-load-form.12
  (macrolet
      ((%m (&environment env)
	   (let* ((obj (make-condition 'make-load-form-condition-03))
		  (fun #'make-load-form)
		  (methods (compute-applicable-methods fun (list obj env))))
	     (notnot-mv methods))))
    (%m))
  t)

;;; User-defined methods

(defclass make-load-form-class-04 ()
  ((a :initarg :a) (b :initarg :b) (c :initarg :c)))

(defmethod make-load-form ((obj make-load-form-class-04)
			   &optional (env t))
  (declare (ignore env))
  (let ((newobj (gensym)))
    `(let ((,newobj (allocate-instance (find-class 'make-load-form-class-04))))
       ,@(loop for slot-name in '(a b c)
	      when (slot-boundp obj slot-name)
	      collect `(setf (slot-value ,newobj ',slot-name)
			     ',(slot-value obj slot-name)))
       ,newobj)))

(deftest make-load-form.13
  (let* ((obj (make-instance 'make-load-form-class-04))
	 (obj2 (eval (make-load-form obj))))
    (values
     (eqt (class-of obj2) (class-of obj))
     (map-slot-boundp* obj2 '(a b c))))
  t (nil nil nil))

(deftest make-load-form.14
  (let* ((obj (make-instance 'make-load-form-class-04 :a 1 :b '(a b c) :c 'a))
	 (obj2 (eval (make-load-form obj))))
    (values
     (eqt (class-of obj2) (class-of obj))
     (map-slot-boundp* obj2 '(a b c))
     (map-slot-value obj2 '(a b c))))
  t
  (t t t)
  (1 (a b c) a))

(deftest make-load-form.15
  (let* ((obj (make-instance 'make-load-form-class-04 :b '(a b c) :c 'a))
	 (obj2 (eval (make-load-form obj nil))))
    (values
     (eqt (class-of obj2) (class-of obj))
     (map-slot-boundp* obj2 '(a b c))
     (map-slot-value obj2 '(b c))))
  t
  (nil t t)
  ((a b c) a))

;;; Other error tests

(deftest make-load-form.error.1
  (classify-error (make-load-form))
  program-error)

(deftest make-load-form.error.2
  (classify-error
   (let ((obj (make-instance 'make-load-form-class-04 :b '(a b c) :c 'a)))
     (make-load-form obj nil nil)))
  program-error)

