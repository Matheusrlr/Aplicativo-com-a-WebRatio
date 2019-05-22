<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		Prints the localized string associated with a given key.
	</Description>
	<Attribute name="key" required="true">
		<Description>
			The key whose associated localized label has to be printed.
			If the current page is not localized, the key itself is printed.
		</Description>
	</Attribute>
	<Usage>
		<![CDATA[
		<p>
			The following example shows how to use the tag <b>&lt;wr:LocalizationString&gt;</b> to localize an HTML anchor.
		</p>
		<source>
	&lt;td colspan=&quot;2&quot;&gt;
		&lt;a href=&quot;&quot;&gt;
			&lt;wr:LocalizationString key=&quot;name&quot;/&gt;
		&lt;/a&gt;
	&lt;/td&gt;
		</source>
		<p>
			The WebRatio IDE makes it possible to associate the key name with different labels for different 
			locales.
		</p>
		]]>
	</Usage>
</Tag>