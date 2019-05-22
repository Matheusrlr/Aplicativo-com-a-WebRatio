<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" createWithBody="false" templateTypes="attr|cell|field|frame|grid|event|screen|comp">
	<Description>
		<![CDATA[
		Declares that a set of resources is required by the enclosing template or just a part of it.
		
		<p>To be valid, the referenced resources have to be compatible with those available
		to the template, as declared in the Style Project descriptor file.</p>
		
		<p>When the tag is used standalone, the requirement applies to the entire template. Otherwise,
		the requirement applies only to the template fragment enclosed in the tag.</p>
		
		<p>A <code>wr:RequireResource</code> tag, even when valid, is effective only when located in
		<i>executed</i> template code. This enables controlling the requirement of resources at
		generation-time, for example by enclosing the tag in an <code>if</code> script block.</p>
		]]>
	</Description>
	<Attribute name="ref" required="true">
		<Description>
			<![CDATA[
			Comma-separated list of references to the resources to require.
			
			<p>Each reference is composed by a resource name, optionally followed by a colon
			(<code>:</code>) and the range of versions to require.</p>
			
			<p>The exact syntax is: <i>identifier</i>[<code>:</code>[<i>minVer</i>][<code>-</code><i>maxVer</i>]].
			Identifiers are strings of letters, digits, hyphen and underscore.
			Versions are dot-separated strings, with each part containing digits and letters.</p>
			]]>
		</Description>
	</Attribute>
</Tag>