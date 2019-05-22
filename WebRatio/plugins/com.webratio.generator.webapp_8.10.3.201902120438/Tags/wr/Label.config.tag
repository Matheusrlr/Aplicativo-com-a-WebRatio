<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		Prints the label of an element.
	</Description>
	<Attribute name="context" required="false">
		<Description>
			<![CDATA[
			The variable used for locating the element whose label should
			be printed, If undefined, the nearest surrounding 
			tag having one of the following types is searched: 
			&lt;wr:Iterate&gt;, &lt;wr:LandmarkOperationMenu&gt;,
			&lt;wr:LandmarkPageMenu&gt;, &lt;wr:LandmarkAreaMenu&gt;,
			&lt;wr:LandmarkMenu&gt;, &lt;wr:LandmarkAreaLink&gt;,
			&lt;wr:LandmarkPageLink&gt;, &lt;wr:LandmarkOperationLink&gt;,
			&lt;wr:LandmarkEvent&gt;, &lt;wr:PageEvents&gt;
			]]>
		</Description>
	</Attribute>
	<Attribute name="select" required="false">
		<Description>
			Optional XPath applied to the context element to select the
			element whose label should be printed. If undefined, the context
			element itself is selected.
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
			The following example demonstrates the usage of the <b>&lt;wr:Label&gt;</b> tag. It prints the label 
			of the current attribute.
		</p>
		<source>
  &lt;table&gt;
    &lt;wr:Iterate var=&quot;attr&quot; context=&quot;component&quot; select=&quot;layout:Attribute&quot;&gt;
      &lt;tr&gt;
        &lt;td&gt;
          &lt;wr:Label/&gt;
        &lt;/td&gt;
      &lt;/tr&gt;
    &lt;/wr:Iterate&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>