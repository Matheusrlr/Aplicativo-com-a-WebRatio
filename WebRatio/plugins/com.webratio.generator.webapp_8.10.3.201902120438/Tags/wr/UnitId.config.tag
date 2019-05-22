<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="comp" nestable="true" deprecated="true">
	<Description>
		<![CDATA[
		Outputs the unique identifier of a Layout Component.
		Useful within JSP tags which need to reference the bean of the view component.
		<p><b>Deprecated:</b> use &lt;wr:Id context=&quot;component&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Usage>
		<![CDATA[
		<source>
  &lt;c:forEach items=&quot;${&lt;wr:Id context=&quot;component&quot;/&gt;.data}&quot; var=&quot;current&quot; varStatus=&quot;status&quot;&gt;
    ....
  &lt;/c:forEach&gt;
		</source>
		]]>
	</Usage>
</Tag>