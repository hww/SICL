(cl:in-package #:sicl-mir-to-lir)

(defgeneric mir-to-lir (client mir))

(defun find-lexical-locations (enter-instruction)
  (let ((result (make-hash-table :test #'eq))
        (location 0))
    (flet ((maybe-register-datum (datum)
             (when (and (or (typep datum 'cleavir-ir:lexical-location)
                            (typep datum 'cleavir-ir:raw-integer))
                        (null (gethash datum result)))
               (setf (gethash datum result) location)
               (incf location))))
      (cleavir-ir:map-instructions-arbitrary-order
       (lambda (instruction)
         (loop for input in (cleavir-ir:inputs instruction)
               do (maybe-register-datum input))
         (loop for output in (cleavir-ir:outputs instruction)
               do (maybe-register-datum output)))
       enter-instruction))
    result))

(defun entry-point-input-p (input)
  (typep input 'sicl-hir-to-mir:entry-point-input))

(defmethod mir-to-lir (client mir)
  (loop with worklist = (list mir)
        until (null worklist)
        do (let* ((enter-instruction (pop worklist))
                  (lexical-locations (find-lexical-locations enter-instruction)))
             (save-arguments enter-instruction)
             (move-return-address enter-instruction)
             (cleavir-ir:map-instructions-arbitrary-order
              (lambda (instruction)
                (let ((entry (find-if #'entry-point-input-p
                                      (cleavir-ir:inputs instruction))))
                  (unless (null entry)
                    (push (sicl-hir-to-mir:enter-instruction entry)
                          worklist)))
                (process-instruction instruction lexical-locations))
              enter-instruction))))
