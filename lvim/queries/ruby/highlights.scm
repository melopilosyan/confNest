;; extends

; In `{ key: :val }` matches the `key`
(hash_key_symbol) @property.symbol

; In `hash[:key]` matches the `key`
(element_reference (simple_symbol) @property.symbol)

; In `def foo(bar: nil)` matches the `bar` keyword parameter
(keyword_parameter (identifier) @constant.macro.keyword.parameter)

; In `foo(bar: "B")` matches the `bar` keyword argument
(argument_list (_ (hash_key_symbol) @constant.macro.keyword.argument))
