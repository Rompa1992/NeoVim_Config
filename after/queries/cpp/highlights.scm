; extends

; Give 'void' its own highlight group so it can be coloured separately from int/float
((primitive_type) @type.void
  (#eq? @type.void "void")
  (#set! priority 110))

; Give 'const' its own highlight group so it can be coloured separately from static/constexpr
((type_qualifier) @keyword.const
  (#eq? @keyword.const "const")
  (#set! priority 110))

; Give 'static' its own group so it can match 'delete' instead of the other modifiers
((storage_class_specifier) @keyword.static
  (#eq? @keyword.static "static")
  (#set! priority 110))

; Access specifiers get their own group: public, private, protected
(["public" "private" "protected"] @keyword.access
  (#set! priority 110))

; constexpr gets its own group so it can share const's colour
("constexpr" @keyword.constexpr
  (#set! priority 110))

; Give 'inline' its own group so it can share const's colour instead of the other modifiers
((storage_class_specifier) @keyword.inline
  (#eq? @keyword.inline "inline")
  (#set! priority 110))

; static_assert gets its own group instead of the built-in function colour
("static_assert" @keyword.static_assert
  (#set! priority 110))
