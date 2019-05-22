<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="attr|cell|field|frame|event|screen|comp">
	<Description>
		Defines a parameter that can be used to modify the behavior of the
		enclosing layout template.
	</Description>
	<Attribute name="name" required="true">
		<Description>
			<![CDATA[
			Unique name of the parameter within the template.
			Use to access the template in code from the <code>params</code> map.
			]]>
		</Description>
	</Attribute>
	<Attribute name="label" required="true">
		<Description>
			Name displayed to the user in the WebRatio IDE.
		</Description>
	</Attribute>
	<Attribute name="type" required="true">
		<Description>
			Type of parameter value.
			
			<p>Possible values are:
			<ul>
			<li><code>string</code></li>,
			<li><code>enum</code></li>,
			<li><code>boolean</code></li>,
			<li><code>color</code></li>.
			</ul></p>
		</Description>
	</Attribute>
	<Attribute name="default" required="false">
		<Description>
			Default value used when the parameter is not specified.
		</Description>
	</Attribute>
	<Attribute name="values" required="false">
		<Description>
			For parameters of the <code>enum</code> type, list of possible
			parameter values separated by pipe (<code>|</code>).
		</Description>
	</Attribute>
	<Content>
		<p>Full human-readable description of the parameter. Displayed in the WebRatio IDE.</p>
	</Content>
</Tag>