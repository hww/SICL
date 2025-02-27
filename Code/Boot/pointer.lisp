(cl:in-package #:sicl-boot)

(defparameter *ersatz-object-table*
  (make-hash-table :test #'eq))

(defun host-char-to-target-code (char)
  #+sb-unicode
  (char-code char)
  #-sb-unicode
  (if (eql char #\Newline)
      10  ; ASCII 10, LF
      (let ((position (position char " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")))
        (if (not (null position))
            (+ 32 position)
            #xfffd)))) ; U+FFFD REPLACEMENT CHARACTER

(defun compute-pointer (object)
  (typecase object
    ((integer 0 #.(1- (expt 2 62)))
     (values (ash object 1) '()))
    ((integer #.(- (expt 2 62)) -1)
     (values (ash (logand object #.(1- (expt 2 63))) 1)))
    (character
     (values (+ (ash (host-char-to-target-code object) 5) #x00011) '()))
    (otherwise
     (let ((result (gethash object *ersatz-object-table*)))
       (if (not (null result))
           result
           (etypecase object
             (cons
              (let* ((address (sicl-allocator:allocate-dyad))
                     (result (+ address 1)))
                (setf (gethash object *ersatz-object-table*) result)
                (values result
                        (list (cons address (car object))
                              (cons (+ address 8) (cdr object))))))
             (string
              (let* ((ms (env:fdefinition (env:client *e5*) *e5* 'make-string))
                     (sa (env:fdefinition (env:client *e5*) *e5* '(setf aref)))
                     (ersatz-string (funcall ms (length object))))
                (loop for i from 0 below (length object)
                      do (funcall sa (aref object i) i))
                (multiple-value-bind (result work-list-items)
                    (compute-pointer ersatz-string)
                  (setf (gethash object *ersatz-object-table*) result)
                  (remhash ersatz-string *ersatz-object-table*)
                  (values result work-list-items))))
             (symbol
              (let* ((mi (env:fdefinition (env:client *e5*) *e5* 'make-instance))
                     (ersatz-symbol
                       (funcall mi
                                :name (symbol-name object)
                                ;; FIXME: Pass a package object.
                                :package nil)))
                (multiple-value-bind (result work-list-items)
                    (compute-pointer ersatz-symbol)
                  (setf (gethash object *ersatz-object-table*) result)
                  (remhash ersatz-symbol *ersatz-object-table*)
                  (values result work-list-items))))
             (header
              (let* ((header-address (sicl-allocator:allocate-dyad))
                     (rack (slot-value object '%rack))
                     (rack-size (length rack))
                     (rack-address (sicl-allocator:allocate-chunk rack-size))
                     (rack-pointer (+ rack-address 7))
                     (fun (env:fdefinition (env:client *e5*) *e5* 'trace-prefix))
                     (prefix-size (funcall fun object))
                     (result (+ header-address 5))
                     (header-item (cons header-address
                                        (slot-value object '%class)))
                     (rack-items
                       (loop for i from 0 below prefix-size
                             for address from rack-address by 8
                             collect (cons address (aref rack i)))))
                ;; Set the rack slot in the header to point to the rack.
                (setf (sicl-memory:memory-unsigned (+ header-address 8) 64)
                      rack-pointer)
                (values result (cons header-item rack-items))))))))))

(defun pointer (object)
  (multiple-value-bind (result work-list-items)
      (compute-pointer object)
    ;; The work list is an association list where the CAR of each
    ;; element is an address (i.e. a fixnum) and the CDR is an ersatz
    ;; object that should be written to that address.
    (let ((work-list work-list-items))
      (loop until (null work-list)
            do (destructuring-bind (address . object)
                   (pop work-list)
                 (multiple-value-bind (result work-list-items)
                     (compute-pointer object)
                   (setf work-list (append work-list-items work-list))
                   (setf (sicl-memory:memory-unsigned address 64) result)))))
    result))
