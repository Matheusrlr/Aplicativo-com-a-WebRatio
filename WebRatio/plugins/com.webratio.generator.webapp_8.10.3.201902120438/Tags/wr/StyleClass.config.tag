<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|field|event|comp" nestable="true">
	<Description>
		Prints the name of the style class, if defined, to use for rendering an element.
	</Description>
	<Attribute name="context" required="false">
		<Description>
			The context variable whose style class will be printed out.
		</Description>
	</Attribute>
	<Usage>
		<![CDATA[
		<source>
		&lt;a class=&quot;aClass &lt;wr:StyleClass context=&quot;aLink&quot;/&gt;&quot; href=&quot;#&quot;&gt;Link&lt;/a&gt;
		</source>
		]]>
	</Usage>
</Tag>