(cl:in-package #:asdf-user)

(defsystem :sicl-hash-table-base
  :serial t
  :components
  ((:file "packages")
   (:file "hash-table-defclass")
   (:file "generic-functions")
   (:file "make-hash-table")))
