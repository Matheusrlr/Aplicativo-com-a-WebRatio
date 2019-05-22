<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="page">
	<Description>
		Outputs the title of the current landmark element of the nearest
		surrounding landmark iteration.
	</Description>
	<Parents>
		<LandmarkOperationMenu/>
		<LandmarkPageMenu/> 
		<LandmarkAreaMenu/>
		<LandmarkMenu/> 
	</Parents>
	<Usage>
		<![CDATA[
		<p>
		The following example demonstrates the tag usage:
		</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkAreaMenu level=&quot;1&quot;&gt;
        &lt;wr:Current&gt;
          &lt;td&gt;&lt;wr:LandmarkTitle/&gt;&lt;/td&gt;
        &lt;/wr:Current&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!--the character | is used as a separator--&gt;
      &lt;/wr:LandmarkAreaMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>