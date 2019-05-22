<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="cell|field|comp">
	<Description>
		<![CDATA[
		Renders the error occurred in validating a Layout Field at runtime.
		
		<p>The rendering is dictated by the field layout template (invoked in "error" mode),
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
		
		<p>About Visibility Conditions support, only the rendered field error is subject to
		the condition. To also affect the error surroundings use the <code>wr:Visible</code> tag.</p>
		]]>
	</Description>
	<Attribute name="context">
		<Description>
			<![CDATA[
			The variable used for locating the element whose error should 
			be printed. If undefined, the variable exported by the nearest
			surrounding &lt;wr:Iterate&gt; tag is used.
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context variable to select the
			element whose error should be printed. If undefined, the context
			element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="item">
		<Description>
			The name of the JavaBean whose
			property will be printed. 
			If unspecified, the string 'current' is used.
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
			The following example demonstrates the usage of the <b>&lt;wr:FieldError&gt;</b> tag.
		</p>
		<source>
	&lt;wr:Iterate var=&quot;field&quot; context=&quot;component&quot; select=&quot;layout:Field&quot;&gt;
		&lt;td valign=&quot;middle&quot; nowrap=&quot;nowrap&quot; class=&quot;verdana1&quot;&gt;
			&lt;wr:Value/&gt;
		&lt;/td&gt;
		&lt;td class=&quot;verdana1bluebold&quot;&gt;
			&lt;wr:FieldError/&gt;
		&lt;/td&gt;
	&lt;/wr:Iterate&gt;
		</source>
		]]>
	</Usage>
</Tag>