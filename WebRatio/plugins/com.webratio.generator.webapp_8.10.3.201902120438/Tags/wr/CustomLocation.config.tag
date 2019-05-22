<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="page">
	<Description>
		<![CDATA[
		Renders the output of a Custom Location, identified by its user-defined name.
		
		<p>The rendering is dictated by the custom location cell layout template,
		with leading/trailing whitespace removed and with the addition of any compatible
		built-in behaviors.</p>
		
		<p>Some example of behavior code are:
		<ul>
			<li>HTML code enabling AJAX features such as selective refresh,</li>
			<li>server-side test for an attached Visibility Condition.</li>
		</ul>
		The additional code is included only when compatible with the page output type set
		by <code>wr:Page</code>. For example, AJAX features are included only in pages
		whose output is HTML or XHTML.</p>
		
		<p>About Visibility Conditions support, only the rendered custom location is subject to
		the condition. To also affect the location surroundings use the <code>wr:Visible</code> tag.</p>
		]]>
	</Description>
	<Attribute name="name" required="true">
		<Description>
			A name that uniquely identifies a custom location. This name is used in the
			WebRatio IDE for referring to the custom location.
		</Description>
	</Attribute>
	<Attribute name="usedInHead" required="false">
		<Description>
			If set to true, signals that the custom location is being rendered
			inside a HTML document HEAD section. The default is false.
		</Description>
	</Attribute>
	<Usage>
		<![CDATA[
		<p>
			Custom locations permit the designer to freely distribute components and sub-pages inside 
			the <a href="/Concepts/StyleDefinition/PageLayout"/>.
		</p>
		<p>
			A custom location is identical to a cell of the main grid; it can host a single component, 
			a set of components, a sub-page, or a sub-grid.
		</p>
		<p>
			All custom locations must have a value of the attribute name unique for the page layout, 
			which is used to reference the custom location.
		</p>
		]]>
	</Usage>
</Tag>