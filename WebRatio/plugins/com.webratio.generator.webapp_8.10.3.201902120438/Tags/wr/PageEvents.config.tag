<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page">
	<Description>
		Iterates over all non-contextual events departing from the current page.
	</Description>
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
		It must contain the HTML fragment to be repeated for rendering the anchors of the non-contextual 
		events. Such HTML fragment must contain an <code>wr:Event</code> tag, which denotes the anchor pointing 
		to the destination reached by each non-contextual event.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
			The use of the <code>wr:PageEvents</code> tag is similar to the use of the 
			<a href="/Reference/GenerationTagsReference/GenerationTags/LandmarkMenu">&lt;wr:LandmarkMenu&gt;</a>.
			The only difference is that there is no distinction between current and non-current anchors,
			because such difference makes no sense for non-contextual events. For example, the following markup
			places non-contextual events vertically in an HTML table:
		</p>
		<source>
	&lt;table&gt;
		&lt;wr:PageEvents&gt;
			&lt;tr&gt;
				&lt;td&gt;
					&lt;wr:Event/&gt;
				&lt;/td&gt;
			&lt;/tr&gt;
		&lt;/wr:PageEvents&gt;
	&lt;/table&gt;
		</source>
    ]]>
	</Usage>
</Tag>