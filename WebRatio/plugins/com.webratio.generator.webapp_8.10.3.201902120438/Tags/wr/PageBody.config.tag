<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Defines the body part of the generated page. The body usually contains the actual 
		visible part of the page.
		
		<p>Depending on the page type attribute, this may also generate structure code.
		For instance, an output HTML page may have the body tags generated.
		The page type attribute can be generated, for example, through the wr:Page tag.</p>
		
		<p><b>Deprecated:</b> use standard HTML &lt;body&gt; tag instead.</p>
		]]>
	</Description>
	<Usage>
		<![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:PageBody&gt;</b> tag.
		</p>
		<source>
	&lt;wr:Page type=&quot;HTML5&quot;/&gt;
	&lt;html&gt;
		&lt;wr:PageBody&gt;
		&lt;wr:PageForm&gt;
		&lt;wr:Grid/&gt;
		&lt;/wr:PageForm&gt;
		&lt;/wr:PageBody&gt;
	&lt;/html&gt;      
		</source>
		]]>
	</Usage>
</Tag>