(ns clj.core
  (:gen-class))

(def max-line-length 80)

;; regex for matching whitespace
(def tabs #"\t+")
(def comma-space #",[^ ]")
(def operator-space #"(\w(\+|\-|\*|\<|\>|\=)\w)|(\w(\=\=|\<\=|\>\=)\w)")
(def comment-line #"^\s*\/\*.*\*\/\s*$")
(def open-comment-space #"\/\*[^ *\n]")
(def close-comment-space #"[^ *]\*\/")
(def paren-curly-space #"\)\{")
(def c-plus-plus-comment #"\/\/")
(def semi-space #";[^ \s]")

(defn check-line [filename line n]
  (if (re-find tabs line)
      (print (format "File: %s, line %d: [TABS]:\n%s", filename, n, line)))
  (if (> (count line) max-line-length)
      (print (format "File: %s, line %d: [TOO LONG (%s CHARS)]:\n%s\n", filename, n, (str (count line)), line)))
  (if (re-find open-comment-space line)
      (print (format "File: %s, line: %d: [PUT SPACE AFTER OPEN COMMENT]:\n%s\n", filename, n, line)))
  (if (re-find close-comment-space line)
      (print (format "File: %s, line: %d: [PUT SPACE AFTER CLOSE COMMENT]:\n%s\n", filename, n, line)))
  (if (re-find paren-curly-space line)
      (print (format "File: %s, line: %d: [PUT SPACE BETWEEN ) AND {]:\n%s\n", filename, n, line)))
  (if (re-find c-plus-plus-comment line)
      (print (format "File: %s, line: %d: [DON'T USE C++ COMMENTS]:\n%s\n", filename, n, line)))
  (if (re-find semi-space line)
      (print (format "File: %s, line: %d: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n%s\n", filename, n, line)))
  (if (re-find operator-space line)
    (if (not (re-find comment-line line))
      (print (format "File: %s, line: %d: [PUT SPACE AROUND OPERATORS]:\n%s\n", filename, n, line))))
  (if (re-find comma-space line)
    (print (format "File: %s, line: %d: [PUT SPACE AFTER COMMA]:\n%s\n", filename, n, line))))

(use 'clojure.java.io)
(defn test-file [file]
  (with-open [rdr (reader file)]
    (doseq [line (line-seq rdr)]
      (println (count (line-seq rdr))))))

; Define a global counter i to keep track of the line number
(def i (atom 0))

(use 'clojure.java.io)
(defn check-file [file]
  (with-open [rdr (reader file)]
    (doseq [line (line-seq rdr)]
      ; Increment the counter
      (check-line file line (swap! i inc)))))

(defn -main [& args]
  (def usage "usage: c_style_check filename1 [filename2 ...]")
  (if (empty? *command-line-args*)
    (do
      (println usage)
      (System/exit 0))
    (doseq [arg *command-line-args*]
      (check-file arg))))

(-main)
