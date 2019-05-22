<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="frame">
	<Description>
		Specifies where the Layout Component or Cell has to be expanded inside its frame.
	</Description>
	<Usage>
		<![CDATA[
		<p>
			The <b>&lt;wr:FrameContent&gt;</b> tag must be placed within a <a href="/Concepts/StyleDefinition/FrameLayout"/>,
			where the dynamic content of the Layout Component or Cell can be placed.
			The exact size of the component content may be unknown a priori, because it depends on 
			the actual data published by the component.   As a consequence, it is a good practice to design the frame so that it 
			can accommodate content of variable horizontal and vertical size.
		</p>
		<p>
			The following example shows the usage of the &lt;wr:FrameContent/&gt; tag.
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