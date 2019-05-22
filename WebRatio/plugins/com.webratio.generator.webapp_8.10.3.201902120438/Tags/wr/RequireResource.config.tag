<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" createWithBody="false" templateTypes="attr|cell|field|frame|grid|event|page|comp">
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
		
		<p>In addition, resource requirement may be controlled at runtime, via the <code>condition</code>
		attribute. Even when the <code>wr:RequireResource</code> tag is located in executed template
		code, the requirement may be halted if the condition specified by the <code>condition</code>
		attribute does not hold at runtime.</p>
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
	<Attribute name="condition">
		<Description>
			<![CDATA[
			Runtime condition for making the resource requirement effective.<br/>
			If not specified, the resource requirement is always effective at runtime.
			
			<p>The value must be the name of a variable available in the runtime page context. When
			generating a JSP page, this is actually the JSP <code>pageContext</code>.<br/>
			If the variable contains a boolean <code>true</code> value, the condition is verified and
			the resource requirement is effective.</p>
			]]>
		</Description>
	</Attribute>
	<Usage>
		<![CDATA[
		<p>
			The following example declares the dependency of the template from version
			1.7.2 or greater of resource <code>jquery</code> and any version of
			resource <code>jquery-ui</code>.
		</p>
		<source>
	&lt;wr:RequireResource ref=&quot;jquery:1.7.2,jquery-ui&quot;/&gt;
		</source>
		<p>
			The next example uses a JSP page context variable to decide whether to make the requirement
			for resource <code>acme-scripts</code> depending on a request parameter.
		</p>
		<source>
	&lt;% pageContext.setAttribute(&quot;myCondition&quot;, request.getParameter(&quot;useScripts&quot;) != null); %&gt;
	&lt;wr:RequireResource ref=&quot;acme-scripts&quot; condition=&quot;myCondition&quot;/&gt;
		</source>
		]]>
	</Usage>
</Tag>