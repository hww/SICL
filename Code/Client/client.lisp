(cl:in-package #:sicl-client)

(defclass sicl (trucler-reference:client)
  ())

(defclass x86-64 () ())

(defclass sicl-x86-64 (sicl x86-64) ())
