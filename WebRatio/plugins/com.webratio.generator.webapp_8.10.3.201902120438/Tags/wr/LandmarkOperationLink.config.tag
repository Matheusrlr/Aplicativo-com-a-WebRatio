<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Locates the top-level landmark action or floating event having a specific
		ordering number. A nested &lt;wr:Event/&gt; tag allows rendering an individual anchor
		pointing to the element.
		
		<p><b>Deprecated:</b> use &lt;wr:LandmarkEvent type=&quot;operation&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Attribute name="position" required="true">
		<Description>
			Represents the sequence number (starting with 0) of the landmark action or
			floating event, based on the order defined into the model.
		</Description>
	</Attribute>
	<Content>
		<![CDATA[
		Any HTML markup, which must contain a <a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event&gt;</a> tag, 
		denoting the anchor pointing to the top-level landmark action or floating event with the given sequence number.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
		  The following example demonstrates the tag usage:
		</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;td&gt;
        &lt;wr:LandmarkEvent position=&quot;1&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkEvent&gt;
      &lt;/td&gt;
      &lt;td&gt;
        &lt;wr:LandmarkEvent position=&quot;2&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkEvent&gt;
      &lt;/td&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
</Tag>