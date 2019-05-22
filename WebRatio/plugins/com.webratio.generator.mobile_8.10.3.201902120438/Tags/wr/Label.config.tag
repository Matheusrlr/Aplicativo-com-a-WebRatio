<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|event|screen|comp">
	<Description>
		Prints the label of an element or a fixed message.
		The resulting text is always localized.
	</Description>
	<Attribute name="context" required="false">
		<Description>
			<![CDATA[
			The variable used for locating the element whose label should
			be printed. If not specified, the variable exported by the nearest
			surrounding <code>wr:Iterate</code> tag is used.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context element to select the
			element whose label should be printed.
			If not specified, the context element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="key" required="false">
		<Description>
			The key of the application message that should be printed.
		</Description>
	</Attribute>
	<Parents>
		<Iterate/>
	</Parents>
</Tag>