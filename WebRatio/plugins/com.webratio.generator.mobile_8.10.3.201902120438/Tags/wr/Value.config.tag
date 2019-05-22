<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|event|screen|comp">
	<Description>
		<![CDATA[
		Renders the value of a Layout Attribute, Layout Field or Layout Event.
		
		<p>The rendering is dictated by the element layout template (invoked in "value" mode),
		with leading/trailing whitespace removed and with the addition of any compatible
		built-in behaviors.</p>
		]]>
	</Description>
	<Attribute name="context" required="false">
		<Description>
			<![CDATA[
			The variable used to locate the element whose value should be printed.
			If not specified, the variable exported by the nearest
			surrounding <code>wr:Iterate</code> tag is used.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context variable to select the
			element whose value should be printed.
			If not specified, the context element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="item" required="false">
		<Description>
			For attribute values, the name of the runtime view variable
			containing the attribute property.. 
			If unspecified, the string 'current' is used.
		</Description>
	</Attribute>
	<Attribute name="position" required="false">
		<Description>
			The name (or a comma-separated list of names) of runtime view 
			variables representing the current instance for a set-oriented 
			view component (e.g. SimpleList).
			If not specified, the default is '$index'.
		</Description>
	</Attribute>
	<Attribute name="type" required="false">
		<Description>
			The HTML rendering to use: anchor (the default) or button.
		</Description>
	</Attribute>
	<Attribute name="class" required="false">
		<Description>
			The CSS class to use for layout.
		</Description>
	</Attribute>
	<Parents>
		<Iterate/>
	</Parents>
</Tag>