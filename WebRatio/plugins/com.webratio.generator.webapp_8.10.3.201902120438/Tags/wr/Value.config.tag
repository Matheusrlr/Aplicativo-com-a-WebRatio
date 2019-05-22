<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		<![CDATA[
		Renders the value of a Layout Attribute, Layout Field or Layout Event.
		
		<p>The rendering is dictated by the element layout template (invoked in "value" mode),
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
		
		<p>About Visibility Conditions support, only the rendered element value is subject to
		the condition. To also affect the value surroundings use the <code>wr:Visible</code> tag.</p>
		]]>
	</Description>
	<Attribute name="context" required="false">
		<Description>
			<![CDATA[
			The variable used to locate the element whose value should be printed.
			If undefined, the variable exported by the nearest
			surrounding &lt;wr:Iterate&gt; tag is used.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context variable to select the
			element whose value should be printed. If undefined, the context
			element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="item" required="false">
		<Description>
			For attribute values, the name of the JavaBean whose
			property will be printed. 
			If unspecified, the string 'current' is used.
		</Description>
	</Attribute>
	<Attribute name="position" required="false">
		<Description>
			The name (or a comma-separated list of names) of page context 
			variables representing the current instance for a set-oriented 
			view component (e.g. SimpleList).
		</Description>
	</Attribute>
	<Attribute name="type" required="false">
		<Description>
			The HTML rendering to use: anchor (the default) or button.
		</Description>
	</Attribute>
	<Attribute name="class" required="false">
		<Description>
			The CSS class to use for layout.
		</Description>
	</Attribute>
	<Parents>
		<LandmarkOperationMenu/>
		<LandmarkOperationMenu/>
		<LandmarkPageMenu/>
		<LandmarkAreaMenu/> 
		<LandmarkMenu/>
		<LandmarkAreaLink/>
		<LandmarkPageLink/>
		<LandmarkOperationLink/> 
		<LandmarkEvent/>
		<PageEvents/>
		<Iterate/>
	</Parents>
	<Usage>
		<![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:Value&gt;</b> tag. It prints the label 
			of the current attribute.
		</p>
		<source>
	&lt;table&gt;
		&lt;wr:Iterate var=&quot;attr&quot; context=&quot;component&quot; select=&quot;layout:Attribute&quot;&gt;
		  &lt;tr&gt;
			&lt;td&gt;
			  &lt;wr:Value/&gt;
			&lt;/td&gt;
		  &lt;/tr&gt;
		&lt;/wr:Iterate&gt;
	&lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>