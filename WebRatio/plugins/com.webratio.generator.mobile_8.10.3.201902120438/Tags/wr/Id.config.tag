<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|event|screen|comp" nestable="true">
	<Description>
		<![CDATA[
		Prints the unique identifier of an interaction model element.
		
		<p>Note that for <i>layout elements</i>, the identifier refers to the corresponding <i>interaction
		model element</i>. Since an interaction model element can be associated with multiple layout elements,
		an identifier may not be unique if used in a template.
		For addressing such a case, use the <code>getLayoutId</code> function.</p>
		]]>
	</Description>
	<Attribute name="context" required="true">
		<Description>
			The variable used to locate the element whose identifier
			should be printed out.
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context variable to select the
			element whose identifier should be printed. If undefined, the
			context element itself is selected.
		</Description>
	</Attribute>
</Tag>