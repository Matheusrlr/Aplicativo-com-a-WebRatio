<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		<![CDATA[
		Iterates over a list of elements.
		
		<p>Equivalent to the following scriptlet:
		<pre>
		[% for (&lt;var&gt; in &lt;context&gt;.selectNodes("&lt;select&gt;")) { %]
			...
		[% } %]
		</pre></p>
		]]>
	</Description>
	<Attribute name="var" required="true">
		<Description>
			The exported variable to hold the current element of the iteration.
		</Description>
	</Attribute>
	<Attribute name="varIndex" required="false">
		<Description>
			The exported variable to hold the current 0-based index of the iteration.
			If omitted the default name is index.
		</Description>
	</Attribute>
	<Attribute name="context" required="true">
		<Description>
			The context variable where the iteration takes place.
		</Description>
	</Attribute>
	<Attribute name="select" required="true">
		<Description>
			The XPath expression identifying the elements to iterate on.
		</Description>
	</Attribute>
	<Attribute name="range" required="false">
		<Description>
			A numeric range (e.g., 1-3), which defines the subset of elements
			to iterate on; both range indices are optional.
			The ordering of the elements is defined into the model.
		</Description>
	</Attribute>
	<Parents>
		<LandmarkOperationMenu/>
		<LandmarkPageMenu/>
		<LandmarkAreaMenu/>
		<LandmarkMenu/>
		<LandmarkAreaLink/>
		<LandmarkPageLink/>
		<LandmarkOperationLink/>
		<LandmarkEvent/>
		<PageEvents/>
		<Iterate/>
	</Parents>
	<Content>
		<![CDATA[
		Any HTML markup, that normally can contain the &lt;wr:Label/&gt; and the wr:Value tags that permit to
		print the label and the value of the current element.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:Iterate&gt;</b> tag. It iterates and
			prints the values of component attributes.
		</p>
		<source>
  &lt;table&gt;
    &lt;wr:Iterate select=&quot;layout:Attribute&quot;&gt;
      &lt;tr&gt;
        &lt;td&gt;
          &lt;wr:Label/&gt;
        &lt;/td&gt;
        &lt;td&gt;
          &lt;wr:Value/&gt;
        &lt;/td&gt;
      &lt;/tr&gt;
    &lt;/wr:Iterate&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
	<AssistantInfo hasBrackets="true">
		<Variable name="var" type="Element">The current element of the iteration (wr:Iterate tag)</Variable>
		<Variable name="varIndex" defaultValue="index" type="Integer" >The current index of the iteration (wr:Iterate tag)</Variable>
	</AssistantInfo>
</Tag>