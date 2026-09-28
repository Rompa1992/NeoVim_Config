; extends

; Give 'void' its own highlight group so it can be coloured separately from int/float
((primitive_type) @type.void
  (#eq? @type.void "void")
  (#set! priority 110))

; Give 'const' its own highlight group so it can be coloured separately from static/constexpr
((type_qualifier) @keyword.const
  (#eq? @keyword.const "const")
  (#set! priority 110))
