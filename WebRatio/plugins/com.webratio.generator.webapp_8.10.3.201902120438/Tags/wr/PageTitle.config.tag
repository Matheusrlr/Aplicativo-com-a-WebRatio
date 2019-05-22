<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Prints the title of the page. 
		Useful within the HTML &lt;title&gt; tag.
		<p><b>Deprecated:</b> use &lt;wr:Label context=&quot;page&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Usage>
		<![CDATA[
		<p>
			The <b>&lt;wr:PageTitle&gt;</b> tag is used to print the name of the page currently being generated. A 
			common usage is inserting it inside the &lt;title&gt; HTML tag, 
			so that the page name appears in the title bar of the browser.
		</p>
		<source>
	&lt;head&gt;
		&lt;title&gt;&lt;wr:PageTitle/&gt;&lt;/title&gt;
	&lt;/head&gt;
		</source>
		]]>
  </Usage>
</Tag>