<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" createWithBody="false" templateTypes="page">
	<Description>
		Renders a navigation bar, a sequence of anchors pointing
		to the areas enclosing the generated page. An optional body
		can be provided for customizing the rendering of each step.
	</Description>
	<Attribute name="class">
		<Description>
			<![CDATA[
			The CSS class applied to the &lt;span&gt; tag 
			containing the navigation bar. Ignored when a body
			is specified.
			]]>
		</Description>
	</Attribute>
	<Attribute name="separator">
		<Description>
			Test used as a separator between the anchors.
			Ignored when a body is specified.
		</Description>
	</Attribute>
	<Attribute name="linkClass">
		<Description>
			The CSS class applied to the anchors leading to the 
			areas enclosing the generated page. Ignored when a body
			is specified.
		</Description>
	</Attribute>
	<Content>
		<![CDATA[
		If the tag is standalone, i.e. it does not have a body, a sequence of anchors is printed, separated
		by the specified separator and with the specified CSS classes applied. If a non-empty body is
		specified, it is up to the body content to print each anchor, using a combination of 
		<a href="Event">&lt;wr:Event&gt;</a>, <a href="Label">&lt;wr:Label&gt;</a> and <a href="URL">&lt;wr:URL&gt;</a> tags.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>This tag is used to produce a navigation bar, which displays the path of areas that enclose the 
		currently visualized page. The navigation bar is especially useful in projects with nested areas, 
		because it allows the user to see the names of the areas leading to the currently visualized page, 
		and to jump to the default page of each enclosing area with a single click.</p>
		
		<p>The images show an example of a site view comprising multiple nested areas and an example of 
		rendition of the navigation bar for such site view.
		<table border="none">
			<row>
				<cell valign="top" image="true">
					<img src="/Images/MultipleNestedAreas.png" alt="Multiple nested areas"/>
				</cell>
			</row>
			<row>
				<cell valign="top" image="true">
					<img src="/Images/MultipleNestedAreasRendition.png" alt="Multiple nested areas rendition"/>
				</cell>
			</row>
		</table></p>
		]]>
	</Usage>
</Tag>