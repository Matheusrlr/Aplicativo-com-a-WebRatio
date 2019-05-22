<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="cell">
	<Description>
		<![CDATA[
		Renders the output of a cell element. Valid cell elements are Layout Component, Layout Field,
		Layout Event, Layout Attribute, Fragment and Grid.
		
		<p>The rendering is dictated by the element layout template, with leading/trailing 
		whitespace removed from fields/events/attributes and with the addition of any compatible
		built-in behaviors.</p>
		]]>
	</Description>
	<Attribute name="context" required="false">
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
	<Parents>
		<Iterate/>
	</Parents>
</Tag>