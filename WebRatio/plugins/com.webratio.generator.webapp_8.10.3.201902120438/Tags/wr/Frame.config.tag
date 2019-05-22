<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="cell|comp">
	<Description>
		Prints out the frame layout for a Layout Component or a Cell, if defined.
	</Description>
	<Content>
		<![CDATA[
		Template fragment that should be enclosed in the printed frame.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
			The following example demonstrates the usage of the <b>&lt;wr:Frame&gt;</b> tag. 
			It prints the frame defined for a Layout Component.
		</p>
		<source>
	&lt;c:if test=&quot;${not(empty &lt;wr:Id context=&quot;component&quot;/&gt;) and (&lt;wr:Id context=&quot;component&quot;/&gt;.dataSize gt 0)}&quot;&gt;
		&lt;wr:Frame&gt;
			&lt;c:forEach items=&quot;${&lt;wr:Id context=&quot;component&quot;/&gt;.data}&quot; var=&quot;current&quot; varStatus=&quot;status&quot;&gt;
				...
			&lt;/c:forEach&gt;
		&lt;/wr:Frame&gt;
	&lt;/c:if&gt;
        </source>
        ]]>
	</Usage>
</Tag>