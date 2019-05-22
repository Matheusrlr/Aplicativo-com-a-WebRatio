<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="frame" deprecated="true">
	<Description>
		<![CDATA[
		Prints the title of the frame context element.
		
		<p><b>Deprecated:</b> use &lt;wr:Label context=&quot;element&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Usage>
		<![CDATA[
		<p>
			The <b>&lt;wr:FrameTitle&gt;</b> tag is used to print the name of the Layout Component or Cell
			currently being generated. A common usage is inserting it inside the <a href="/Concepts/StyleDefinition/FrameLayout"/>.
		</p>
		<p>
			The following example shows the usage of the wr:FrameTitle tag.
		</p>
		<source>
	&lt;table style=&quot;border: 2px solid #cc0000; font-size:12px&quot; height=&quot;200px&quot; width=&quot;200px&quot;&gt;
		&lt;tr&gt;
			&lt;td align=&quot;center&quot;&gt;
				&lt;b style=&quot;color: #cc0000&quot;&gt;&lt;wr:FrameTitle/&gt;&lt;/b&gt;
			&lt;/td&gt;
		&lt;/tr&gt;
		&lt;tr&gt;
			&lt;td valign=&quot;top&quot; align=&quot;center&quot;&gt;
				&lt;wr:FrameContent/&gt;
			&lt;/td&gt;
		&lt;/tr&gt;
	&lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>