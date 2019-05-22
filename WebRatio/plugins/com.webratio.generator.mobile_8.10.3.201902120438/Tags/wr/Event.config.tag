<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|event|screen|comp">
	<Description>
		<![CDATA[
		Renders the output of a Layout Event.
		
		<p>The rendering is dictated by the event layout template, with leading/trailing whitespace
		removed and with the addition of any compatible built-in behaviors.</p>
		]]>
	</Description>
	<Attribute name="context">
		<Description>
			<![CDATA[
			The variable used to locate the element to lay out.
			If not specified, the variable exported by the nearest
			surrounding <code>wr:Iterate</code> tag is used.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context element for selecting
			the actual element to lay out.
			If not specified, the context element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="position">
		<Description>
			The name (or a comma-separated list of names) of runtime view 
			variables representing the current instance for a set-oriented 
			view component (e.g. SimpleList).
			If not specified, the default is '$index'.
		</Description>
	</Attribute>
	<Attribute name="type">
		<Description>
			The HTML rendering to use: anchor (the default) or button.
		</Description>
	</Attribute>
	<Attribute name="class">
		<Description>
			The CSS class to use for layout.
		</Description>
	</Attribute>
	<Parents>
		<Iterate/>
	</Parents>
</Tag>