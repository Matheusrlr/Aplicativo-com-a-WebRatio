<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="page">
	<Description>
		<![CDATA[
		Defines the type of the generated page.
		
		<p>Depending on the type attribute, this may also generate an actual declarations.
		For instance, an output HTML page may have its DOCTYPE generated.</p>
		
		<p>The specified type is taken as an indication of the language that the template author is
		writing in the "literal text" part of the template. Other generation tags may use this
		information to generate code that is coherent with the authored code or to make assumptions
		about the capabilities of the cilents that will consume the page.</p>
		]]>
	</Description>
	<Attribute name="type" required="true">
		<Description>
			<![CDATA[
			Name identifying the type of the generated page.
			
			<p>The built-in types are summarized in the following list, grouped by language family
			(and the related media type).</p>
			
			<ul>
				<li>
					HTML (text/html)
					<ul>
						<li><code>HTML5</code> - HTML 5.0</li>
						<li><code>HTML4</code> - HTML 4.01 Strict</li>
						<li><code>HTML4_TRANSITIONAL</code> - HTML 4.01 Transitional</li>
					</ul>
				</li>
				<li>
					XHTML (application/xml+html)
					<ul>
						<li><code>XHTML5</code> - XHTML 5.0</li>
						<li><code>XHTML1</code> - XHTML 1.0 Strict</li>
						<li><code>XHTML1_TRANSITIONAL</code> - XHTML 1.0 Transitional</li>
					</ul>
				</li>
			</ul>
			]]>
		</Description>
	</Attribute>
	<Usage>
		<![CDATA[
		<p>      
			The following example uses the tag to declare an HTML5 page. The tag is placed at the very start
			of the file so that the <code>DOCTYPE</code> is output in the correct place.
		</p>
		<source>
	&lt;wr:Page type=&quot;HTML5&quot;/&gt;
	&lt;html&gt;
		&lt;head&gt;
			&lt;!-- head content --&gt;
		&lt;/head&gt;
		&lt;body&gt;
			&lt;!-- body content --&gt;
		&lt;/body&gt;
	&lt;/html&gt;
		</source>
		]]>
	</Usage>
</Tag>