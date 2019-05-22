<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|field|event|comp" nestable="true">
	<Description>
		Prints the name of the style class, if defined, to use for rendering an element.
	</Description>
	<Attribute name="context" required="false">
		<Description>
			<![CDATA[
			The context variable holding the element whose style class
			should be printed. If not specified, the variable exported by the nearest
			surrounding <code>wr:Iterate</code> tag is used. If also not inside a
			<code>wr:Iterate</code> tag, the target element of the enclosing template
			is used.
			]]>
		</Description>
	</Attribute>
</Tag>