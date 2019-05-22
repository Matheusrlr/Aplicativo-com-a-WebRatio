<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Defines the header part of the generated page. The header usually contains 
		meta-information about the entire page.
		
		<p>Depending on the page type attribute, this may also generate structure code.
		For instance, an output HTML page may have the head tags generated.
		The page type attribute can be generated, for example, through the wr:Page tag.</p>
		
		<p><b>Deprecated:</b> use standard HTML &lt;head&gt; tag instead.</p>
		]]>
	</Description>
	<Usage>
		<![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:PageHead&gt;</b> tag.
		</p>
		<source>
	&lt;wr:Page type=&quot;HTML5&quot;/&gt;
	&lt;html&gt;
	&lt;wr:PageHead&gt;
		&lt;title&gt;&lt;wr:PageTitle/&gt;&lt;/title&gt;
		&lt;meta http-equiv=&quot;content-type&quot; content=&quot;text/html; charset=utf-8&quot;&gt;
	&lt;/wr:PageHead&gt;
	&lt;/html&gt;
		</source>
		]]>
	</Usage>
</Tag>