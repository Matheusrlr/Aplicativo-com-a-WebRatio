<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="page">
	<Description>
	     <![CDATA[
		 Renders an HTML &lt;base/&gt; element with an href attribute pointing to the
         absolute location of the enclosing JSP page. This tag is only valid when
         nested inside a head tag body. The presence of this tag allows the browser
         to resolve relative URL&apos;s to images, CSS stylesheets  and other resources
         in a manner independent of the URL used to call the ActionServlet.
         ]]>
	</Description>
	<Usage>
	    <![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:BaseURI&gt;</b> tag. 
		</p>
		<source>
  &lt;head&gt;
    &lt;wr:BaseURI/&gt;
  &lt;/head&gt;
    </source>
	]]>
	</Usage>
</Tag>