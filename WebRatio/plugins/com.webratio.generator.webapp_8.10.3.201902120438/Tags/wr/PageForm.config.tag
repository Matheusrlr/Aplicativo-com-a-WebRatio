<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page">
	<Description>
		<![CDATA[
		Renders a global wrapper to support functionality of the generated page at runtime. Typically,
		an HTML form is included if the page contains at least one form-based view component.
		
		<p>Usually nested immediately inside the HTML &lt;body&gt;.</p>
		]]>
	</Description>
	<Attribute name="multipart" required="false">
		<Description>
			If true (default), the enctype form attribute of the form is set to multipart/form-data. 
			If false, the enctype form attribute is omitted.
		</Description>
	</Attribute>
	<Attribute name="fieldFocusScript" required="false">
		<Description>
			If true (default), the first input field receives focus upon entering the page;
			hidden fields, disabled fields and submit buttons never receive focus.
			If false, no element is focused.
		</Description>
	</Attribute>
	<Attribute name="ignoreStyleId" required="false">
		<Description>
			If true, the styleId form attribute is not added to the rendered HTML 
			form tag (useful for XHTML pages).
			If false (default), the styleId form attribute is added to the to the 
			rendered HTML form tag.
		</Description>
	</Attribute>
	<Content>
		<![CDATA[
		It must contain the HTML fragment to be surrounded by the global support wrapper and form.
		This typically means that all visible/interactive code of the generated page should be placed
		inside the content.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>The following example shows the usage of <b>&lt;wr:PageForm&gt;</b> tag.</p>
		<source>
  &lt;body&gt;
    &lt;wr:PageForm&gt;
      &lt;table cellspacing=&quot;1&quot; cellpadding=&quot;2&quot; border=&quot;0&quot; bgcolor=&quot;#354463&quot; width=&quot;520&quot;&gt;
        &lt;tr&gt;        
        &lt;wr:LandmarkAreaMenu level=&quot;0&quot;&gt;
          &lt;wr:Current&gt;
            &lt;td bgcolor=&quot;#999999&quot; class=&quot;small&quot; align=&quot;center&quot;&gt;&lt;wr:Event/&gt;&lt;/td&gt;
          &lt;/wr:Current&gt;
          &lt;wr:NonCurrent&gt;
            &lt;td bgcolor=&quot;#CCCCCC&quot; class=&quot;small&quot; align=&quot;center&quot;&gt;&lt;wr:Event/&gt;&lt;/td&gt;
          &lt;/wr:NonCurrent&gt;
          &lt;/wr:LandmarkAreaMenu&gt;
        &lt;/tr&gt;
        &lt;tr&gt;        
        &lt;wr:LandmarkPageMenu level=&quot;0&quot;&gt;
          &lt;wr:Current&gt;
            &lt;td bgcolor=&quot;#999999&quot; class=&quot;small&quot; align=&quot;center&quot;&gt;&lt;wr:Event/&gt;&lt;/td&gt;
          &lt;/wr:Current&gt;
          &lt;wr:NonCurrent&gt;
            &lt;td bgcolor=&quot;#CCCCCC&quot; class=&quot;small&quot; align=&quot;center&quot;&gt;&lt;wr:Event/&gt;&lt;/td&gt;
          &lt;/wr:NonCurrent&gt;
          &lt;/wr:LandmarkPageMenu&gt;
        &lt;/tr&gt;
      &lt;/table&gt;   
     
	 &lt;wr:Grid/&gt;
      
    &lt;/wr:PageForm&gt;
  &lt;/body&gt;
		</source>
		]]>
	</Usage>
</Tag>