<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Locates the top-level landmark area having a specific ordering number.
		A nested &lt;wr:Event/&gt; tag allows rendering an individual anchor pointing to the area.
		
		<p><b>Deprecated:</b> use &lt;wr:LandmarkEvent type=&quot;area&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Attribute name="position" required="true">
		<Description>
			Represents the sequence number (starting with 0) of the landmark area, based on the order
			defined into the model.
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
		Any HTML markup, which must contain a <a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event&gt;</a> tag, denoting the anchor pointing to 
		the top-level area with the given sequence number.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
		  This tag is used when the anchors of the top-level landmark areas should be displayed in a custom 
		  way, which cannot be expressed using the iteration implied by the 
		  <a href="/Reference/GenerationTagsReference/GenerationTags/LandmarkAreaMenu">&lt;wr:LandmarkAreaMenu&gt;</a> tag.
		</p>
		<p>
		  As an example, let us assume six landmark areas, to be placed in two rows. 
		  The following tags in the HTML page layout do the job.
		</p>
    <source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;td&gt;
        &lt;wr:LandmarkAreaLink position=&quot;1&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkAreaLink&gt;
      &lt;/td&gt;
      &lt;td&gt;
        &lt;wr:LandmarkAreaLink position=&quot;3&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkAreaLink&gt;
      &lt;/td&gt;
      &lt;td&gt;
        &lt;wr:LandmarkAreaLink position=&quot;5&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkAreaLink&gt;
      &lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;td&gt;
        &lt;wr:LandmarkAreaLink position=&quot;2&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkAreaLink&gt;
      &lt;/td&gt;
      &lt;td&gt;
        &lt;wr:LandmarkAreaLink position=&quot;4&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkAreaLink&gt;
      &lt;/td&gt;
      &lt;td&gt;
        &lt;wr:LandmarkAreaLink position=&quot;6&quot;&gt;
          &lt;wr:Event /&gt;
        &lt;/wr:LandmarkAreaLink&gt;
      &lt;/td&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
    </source>
		]]>
	</Usage>
</Tag>