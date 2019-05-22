<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page">
	<Description>
		<![CDATA[
		Locates the top-level landmark element having a specific ordering number.
		A nested &lt;wr:Event/&gt; tag allows rendering an individual anchor pointing to the element.
		]]>
	</Description>
	<Attribute name="position" required="true">
		<Description>
			Represents the sequence number (starting with 0) of the landmark element, based on the order
			defined into the model.
		</Description>
	</Attribute>
	<Attribute name="type" required="false">
		<Description>
			<![CDATA[
			The type of landmark elements to take into account when choosing the one to render
			(by means of its position). If unspecified, all landmark elements are taken into
			account.
			
			<p>Possible values are:
			<ul>
			<li><code>area</code> - matching Area elements</li>,
			<li><code>operation</code> - matching Action and floating event elements</li>,
			<li><code>page</code> - matching top-level Page elements</li>.
			</ul></p>
			]]>
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
		Any HTML markup, which must contain a
		<a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event&gt;</a> tag, 
		denoting the anchor pointing to the top-level landmark element with the given sequence number.
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