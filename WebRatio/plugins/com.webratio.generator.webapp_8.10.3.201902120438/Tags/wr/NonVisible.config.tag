<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page|attr|cell|field|frame|grid|event|comp">
	<Description>
		<![CDATA[
		Shows its contents if an element is <b>not</b> visible.
		
		<p>An element&apos;s visibility is determined by its visibility condition(s),
		its visibility policy and also by other factors (e.g. special AJAX events 
		that lack a presentation).</p>
		]]>
	</Description>
	<Attribute name="context" required="false">
		<Description>
			<![CDATA[
			The variable used to locate the element whose visibility should be tested.
			If undefined, the nearest surrounding tag having 
			one of the following types is searched: 
			&lt;wr:Iterate&gt;, &lt;wr:LandmarkOperationMenu&gt;,
			&lt;wr:LandmarkPageMenu&gt;, &lt;wr:LandmarkAreaMenu&gt;,
			&lt;wr:LandmarkMenu&gt;, &lt;wr:LandmarkAreaLink&gt;,
			&lt;wr:LandmarkPageLink&gt;, &lt;wr:LandmarkOperationLink&gt;,
			&lt;wr:LandmarkEvent&gt;, &lt;wr:PageEvents&gt;.
			If a non-existing or empty variable is specified, the tag is ignored
			and the contents are rendered.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context variable to select the
			element whose visibility should be tested. If undefined,
			the context element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="position">
		<Description>
			Name (or a comma-separated list of names) of page context 
			variables representing the current instance for a set-oriented 
			view component (e.g. SimpleList).
		</Description>
	</Attribute>
	<Content>
	    <![CDATA[ 
		Any HTML markup.
		]]>
	</Content>
	<Usage>
	    <![CDATA[ 
		<p>The following example shows how the <b>&lt;wr:NonVisible&gt;</b> tag can be used
		together with <b>&lt;wr:Visible&gt;</b> to render an alternative piece of HTML
		when a component is not visible.</p>
		<source>
&lt;wr:Visible context=&quot;articleText&quot;&gt;
  &lt;div&gt;
    &lt;wr:Value context=&quot;articleText&quot;/&gt;
  &lt;/div&gt;
&lt;/wr:Visible&gt;
&lt;wr:NonVisible&gt;
  To view this article you must be &lt;a href=&quot;login.do&quot;&gt;logged in&lt;/a&gt;.
&lt;/wr:NonVisible&gt;
		</source>
		]]>
	</Usage>
</Tag>