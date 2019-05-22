<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		Defines a named layout parameter.
	</Description>
	<Attribute name="name" required="true">
		<Description>
			The unique name of the layout parameter within the layout template.
		</Description>
	</Attribute>
	<Attribute name="label" required="true">
		<Description>
			The name shown the WebRatio IDE in the Layout Parameters dialog.
		</Description>
	</Attribute>
	<Attribute name="type" required="true">
		<Description>
			The parameters type. One of the following types:
			string, enum, boolean, color.
		</Description>
	</Attribute>
	<Attribute name="default">
		<Description>
			The parameter default value.
		</Description>
	</Attribute>
	<Attribute name="values">
		<Description>
			The pipe-separated list of available values in case of enum type.
		</Description>
	</Attribute>
	<Content>
		<p>The description of the parameter.</p>
	</Content>
	<Usage>
		<![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:LayoutParameter&gt;</b> tag. It prints the label 
			of the current attribute.
		</p>
		<source>
	&lt;wr:LayoutParameter label=&quot;Input size&quot; name=&quot;input-size&quot; default=&quot;25&quot;&gt;
	Defines the size of input fields.
	&lt;/wr:LayoutParameter&gt;
		</source>
		]]>
	</Usage>
</Tag>