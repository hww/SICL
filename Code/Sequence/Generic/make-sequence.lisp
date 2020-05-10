(cl:in-package #:sicl-sequence)

(declaim (inline make-sequence/null))
(defun make-sequence/null (length &key initial-element)
  (declare (ignore initial-element))
  (check-type length (eql 0))
  '())

(declaim (inline make-sequence/list))
(defun make-sequence/list (length &key (initial-element nil initial-element-p))
  (if (not initial-element-p)
      (make-list length)
      (make-list length :initial-element initial-element)))

(declaim (inline make-sequence/vector))
(defun make-sequence/vector (element-type length &key (initial-element nil initial-element-p))
  (check-type length integer)
  (if (not initial-element-p)
      (make-array length :element-type element-type)
      (make-array length :element-type element-type :initial-element initial-element)))

(defun make-sequence (result-type length &key (initial-element nil initial-element-p))
  (macrolet ((call (sequence-constructor &rest args)
               `(if (not initial-element-p)
                    (,sequence-constructor ,@args)
                    (,sequence-constructor ,@args :initial-element initial-element))))
    (flet ((fail ()
             (error "Not a recognizable sequence type specifier: ~S"
                    result-type)))
      (case result-type
        ((null)
         (make-sequence/null length))
        ((cons list)
         (call make-sequence/list length))
        ((vector simple-vector)
         (call make-sequence/vector 't length))
        ((bit-vector simple-bit-vector)
         (call make-sequence/vector 'bit length))
        ((string simple-string)
         (call make-sequence/vector 'character length))
        ((base-string simple-base-string)
         (call make-sequence/vector 'base-char length))
        ;; Now for the slow path.
        (otherwise
         (let ((sequence
                 (cond
                   ((subtypep result-type '(not sequence))
                    (error "Not a sequence type specifier: ~S"
                           result-type))
                   ((subtypep result-type 'list)
                    (if (subtypep result-type 'null)
                        (make-sequence/null length)
                        (call make-sequence/list length)))
                   ((subtypep result-type 'vector)
                    (let* ((vector-class (or (find result-type *vector-classes* :test #'subtypep)
                                             (fail)))
                           (element-type (array-element-type (class-prototype vector-class))))
                      (call make-sequence/vector element-type length)))
                   (t
                    (let ((class (and (symbolp result-type)
                                      (find-class result-type nil))))
                      (if (not class)
                          (fail)
                          (call make-sequence-like (class-prototype class) length)))))))
           (unless (typep sequence result-type)
             (error "Cannot create a sequence of type ~S and length ~S."
                    result-type length))
           sequence))))))

(define-compiler-macro make-sequence (&whole form result-type length &rest rest &environment env)
  (unless (and (constantp result-type)
               (member (length rest) '(0 2)))
    (return-from make-sequence form))
  (let* ((type (simplify-sequence-type-specifier (eval result-type)))
         (class (and (symbolp type) (find-class type nil env))))
    (cond ((not class) form)
          ((eql class (find-class 'null))
           `(make-sequence/null ,length ,@rest))
          ((or (eql class (find-class 'cons))
               (eql class (find-class 'list)))
           `(make-sequence/list ,length ,@rest))
          ((subtypep class 'vector)
           (let ((element-type (array-element-type (class-prototype class))))
             `(make-sequence/vector ',element-type ,length ,@rest)))
          ((subtypep class 'sequence)
           `(make-sequence-like ',(class-prototype class) ,length ,@rest))
          (t form))))

