<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="cell|field|comp">
	<Description>
		<![CDATA[
		Renders the error occurred in validating a Layout Field at runtime.
		
		<p>The rendering is dictated by the field layout template (invoked in "error" mode),
		with leading/trailing whitespace removed and with the addition of any compatible
		built-in behaviors.</p>
		]]>
	</Description>
	<Attribute name="context">
		<Description>
			<![CDATA[
			The variable used for locating the element whose error should 
			be printed. If not specified, the variable exported by the nearest
			surrounding <code>wr:Iterate</code> tag is used.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context variable to select the
			element whose error should be printed.
			If not specified, the context element itself is selected.
		</Description>
	</Attribute>
	<Parents>
		<Iterate/>
	</Parents>
</Tag>