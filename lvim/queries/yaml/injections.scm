;; extends

((block_mapping_pair
  value: (flow_node
           (plain_scalar
             (string_scalar) @injection.content)
           ) @_str)
  (#lua-match? @_str "<%%.*%%>")
  (#set! injection.language "eruby")
)

((block_mapping_pair
  value: (flow_node [
           (double_quote_scalar)
           (single_quote_scalar)
         ] @injection.content) @_str)
  (#lua-match? @_str "<%%.*%%>")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "eruby")
 )
