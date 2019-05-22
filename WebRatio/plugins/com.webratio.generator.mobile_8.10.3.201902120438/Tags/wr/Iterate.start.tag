#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def select = tag["select"]
def var = tag["var"]
def context = tag["context"]
def varIndex = tag["varIndex"] ?: "index"

$$[% 
def _items$$= _wr_tag_index $$ = safeSubList($$= context $$.selectNodes("$$= select $$"), "$$= tag.range $$")
for ($$= var $$ in _items$$= _wr_tag_index $$) { 
	def $$= varIndex $$ = _items$$= _wr_tag_index $$.indexOf($$= var $$)
%]