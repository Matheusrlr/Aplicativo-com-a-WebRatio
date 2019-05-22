<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" createWithBody="false" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		<![CDATA[
		Renders the output of a Layout Event or a landmark menu element.
		
		<p>For a <i>Layout Event</i> element (found standalone or in a Layout Component), the rendering is dictated
		by its layout template, with leading/trailing whitespace removed and with the addition of any
		compatible built-in behaviors.</p>
		
		<p>For a <i>landmark menu</i> element (found inside a landmark menu parent tag), the rendering depends
		on the tag contents.</p>
		
		<p>Some example of behavior code are:
		<ul>
			<li>HTML code enabling AJAX features such as selective refresh,</li>
			<li>server-side test for an attached Visibility Condition.</li>
		</ul>
		The additional code is included only when compatible with the page output type set
		by <code>wr:Page</code>. For example, AJAX features are included only in pages
		whose output is HTML or XHTML.</p>
		
		<p>About Visibility Conditions support, only the rendered event is subject to the condition.
		To also affect the event surroundings use the <code>wr:Visible</code> tag.</p>
		]]>
	</Description>
	<Attribute name="context">
		<Description>
			<![CDATA[
			The variable used to locate the &lt;layout:Event&gt; being
			rendered. If undefined, the nearest surrounding tag having 
			one of the following types is searched: 
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
			event to render. If undefined, the context element itself is selected.
		</Description>
	</Attribute>
	<Attribute name="position">
		<Description>
			the name (or a comma-separated list of names) of page context 
			variables representing the current instance for a set-oriented 
			view component (e.g. SimpleList).
		</Description>
	</Attribute>
	<Attribute name="type">
		<Description>
			The HTML rendering to use: anchor (the default) or button.
		</Description>
	</Attribute>
	<Attribute name="class">
		<Description>
			The CSS class to use for layout.
		</Description>
	</Attribute>
	<Parents>
		<Iterate/>
		<LandmarkOperationMenu/>
		<LandmarkPageMenu/> 
		<LandmarkAreaMenu/>
		<LandmarkMenu/> 
		<LandmarkAreaLink/> 
		<LandmarkPageLink/> 
		<LandmarkOperationLink/> 
		<LandmarkEvent/> 
		<PageEvents/> 
	</Parents>
	<Content>
		<![CDATA[
		If the tag is standalone, i.e. it does not have a body, the tag itself prints (if required)
		the event visibility condition and the HTML anchor. If the tag surrounds a non-empty
		body (<b>only</b> in Page templates), only the event visibility condition (if any) is printed, and 
		it is up to the body content to print the HTML anchor, possibly with wr:URL and wr:Label tags. 
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>The following example demonstrates the tag usage in standalone mode:</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkPageMenu level=&quot;1&quot;&gt;
        &lt;td&gt;&lt;wr:Event/&gt;&lt;/td&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!--the character | is used as a separator--&gt;
      &lt;/wr:LandmarkPageMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		<p>The following example demonstrates the tag usage with a body content, that is to be used <b>only</b> in 
		page layout templates:</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkPageMenu level=&quot;1&quot;&gt;
        &lt;wr:Event&gt;
          &lt;td&gt;
            &lt;a href=&quot;&lt;wr:URL/&gt;&quot;&gt;&lt;wr:Label/&gt;&lt;/a&gt;
          &lt;/td&gt;
        &lt;/wr:Event&gt;
      &lt;/wr:LandmarkPageMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>