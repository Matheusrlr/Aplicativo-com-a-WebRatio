<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp" nestable="true">
	<Description>
		Outputs the URL for a specific Layout Event.
	</Description>
	<Attribute name="context">
		<Description>
			<![CDATA[
			The variable used to locate the &lt;layout:Event&gt; whose
			URL should be printed out. If undefined, the nearest surrounding
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
			Optional XPath applied to the context variable to select the
			Layout Event whose URL should be printed out. If undefined, the context
			element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="position">
		<Description>
			The name (or a comma-separated list of names) of page context 
			variables representing the current instance for a set-oriented 
			view component (e.g. SimpleList).
		</Description>
	</Attribute>
	<Attribute name="escapeXml">
		<Description>
			If set to true (default behaviour) the resulting URL is XML-escaped.
		</Description>
	</Attribute>
	<Parents>
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
		  The following example shows how to display landmark area events inside an HTML map:
		</p>
		<source>
  &lt;MAP name=&quot;Map&quot;&gt;
    &lt;wr:LandmarkAreaLink position=&quot;1&quot;&gt;
      &lt;AREA shape=&quot;RECT&quot; coords=&quot;44,74,129,98&quot; href=&quot;&lt;wr:URL/&gt;&quot;&gt;&lt;/AREA&gt;
    &lt;/wr:LandmarkAreaLink&gt;
    &lt;wr:LandmarkAreaLink position=&quot;2&quot;&gt;
      &lt;AREA shape=&quot;RECT&quot; coords=&quot;130,74,268,99&quot; href=&quot;&lt;wr:URL/&gt;&quot;&gt;&lt;/AREA&gt;
    &lt;/wr:LandmarkAreaLink&gt;
  &lt;/MAP&gt;
		</source>
    ]]>
	</Usage>
</Tag>