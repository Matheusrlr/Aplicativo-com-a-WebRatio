<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="grid">
	<Description>
		<![CDATA[
        Renders the output of a Cell.
		
		<p>The rendering is dictated by the cell layout template, with
		the addition of any compatible built-in behaviors.</p>
		
		<p>Some example of behavior code are:
		<ul>
			<li>HTML code enabling AJAX features such as selective refresh,</li>
			<li>server-side test for an attached Visibility Condition.</li>
		</ul>
		The additional code is included only when compatible with the page output type set
		by <code>wr:Page</code>. For example, AJAX features are included only in pages
		whose output is HTML or XHTML.</p>
		
		<p>About Visibility Conditions support, only the rendered cell is subject to
		the condition. To also affect the cell surroundings use the <code>wr:Visible</code> tag.</p>
		]]>
	</Description>
	<Attribute name="context" required="true">
		<Description>
			<![CDATA[The context variable referencing a &lt;layout:Cell&gt; element.]]>
		</Description>
	</Attribute>
	<Parents>
		<Grid/>
		<Iterate/>
	</Parents>
	<Usage>
		<![CDATA[  
		<p>
			The cell is the location where the dynamic content can be placed. 
			The <b>&lt;wr:Cell&gt;</b> tag marks such location in the <a href="/Concepts/StyleDefinition/GridLayout"/>.
		</p>
		<p>
			Each grid layout should include at least one cell so that the components can be 
			placed into it.
		</p>
		<p>
			The following example demonstrate a piece of HTML for laying out the
			cells and their contents. 
		</p>
		<source>
  &lt;table&gt;
    &lt;wr:Iterate var=&quot;row&quot; context=&quot;grid&quot; select=&quot;layout:Row&quot;&gt;
      &lt;tr&gt;
        &lt;wr:Iterate context=&quot;row&quot; select=&quot;layout:Cell&quot;&gt;
             &lt;td&gt;
               &lt;wr:Cell context=&quot;cell&quot;/&gt;
             &lt;/td&gt;
           &lt;/wr:Iterate&gt;
      &lt;/tr&gt;
    &lt;/wr:Iterate&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>