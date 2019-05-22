<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="cell">
	<Description>
		<![CDATA[
		Renders the output of a cell element. Valid cell elements are Layout Component, Layout Field,
		Layout Event, Layout Attribute, Grid and Sub Page.
		
		<p>The rendering is dictated by the element layout template, with leading/trailing 
		whitespace removed from fields/events/attributes and with the addition of any compatible
		built-in behaviors.</p>
		
		<p>Some example of behavior code are:
		<ul>
			<li>HTML code enabling AJAX features such as selective refresh,</li>
			<li>server-side test for an attached Visibility Condition.</li>
		</ul>
		The additional code is included only when compatible with the page output type set
		by <code>wr:Page</code>. For example, AJAX features are included only in pages
		whose output is HTML or XHTML.</p>
		
		<p>About Visibility Conditions support, only the rendered cell element is subject to
		the condition. To also affect the element surroundings use the <code>wr:Visible</code> tag.</p>
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
	<Usage>
		<![CDATA[ 
		<p>
			The following example uses this tag for printing all Layout Components of a Cell.
		</p>
		<source>
	&lt;wr:Iterate var=&quot;component&quot; context=&quot;cell&quot; select=&quot;.//layout:Component&quot;&gt;
		&lt;div&gt;
			&lt;wr:Element/&gt;
		&lt;/div&gt;
	&lt;/wr:Iterate&gt;
	    </source>
	]]>	
	</Usage>
</Tag>