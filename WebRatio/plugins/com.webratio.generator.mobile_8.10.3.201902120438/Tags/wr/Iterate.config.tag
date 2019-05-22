<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="attr|cell|field|frame|event|screen|comp">
	<Description>
		<![CDATA[
		Iterates over a series of elements, in the order defined in the model.
		
		<p>Roughly equivalent to the following template:
		<pre>
		[% for (&lt;var&gt; in &lt;context&gt;.selectNodes("&lt;select&gt;")) { %]
			...
		[% } %]
		</pre></p>
		]]>
	</Description>
	<Attribute name="var" required="true">
		<Description>
			Name of the exported variable holding the current element of the iteration.
		</Description>
	</Attribute>
	<Attribute name="varIndex" required="false">
		<Description>
			Name of the exported variable holding the 0-based index of the current iteration.
			If not specified, the name 'index' is used.
		</Description>
	</Attribute>
	<Attribute name="context" required="true">
		<Description>
			The variable holding the element over which to iterate.
		</Description>
	</Attribute>
	<Attribute name="select" required="true">
		<Description>
			XPath applied to the context variable to select the elements over which
			to iterate. 
		</Description>
	</Attribute>
	<Attribute name="range" required="false">
		<Description>
			A numeric range (e.g., 1-3), which defines the subset of elements
			over which to iterate. Both range indices are optional and, if not specified,
			default to the very first and the very last element.
			If not specified, all elements are iterated.
		</Description>
	</Attribute>
	<Parents>
		<Iterate/>
	</Parents>
	<Content>
		<![CDATA[
		Template fragment that should be evaluated for each iteration.
		
		<p>Most tags used within the body will automatically refer to the variable exported by
		this tag. For example, a common case is using <code>wr:Label</code> and <code>wr:Value</code>,
		without a context variable, to print the label and value of each iterated element.</p>
		]]>
	</Content>
	<AssistantInfo hasBrackets="true">
		<Variable name="var" type="Element">The current element of the iteration (wr:Iterate tag)</Variable>
		<Variable name="varIndex" defaultValue="index" type="Integer">The current index of the iteration (wr:Iterate tag)</Variable>
	</AssistantInfo>
</Tag>