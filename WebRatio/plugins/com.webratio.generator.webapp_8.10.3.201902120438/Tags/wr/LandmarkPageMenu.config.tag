<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Iterates over all the landmark pages available in the final site view of the page.
		Such pages can be at the site view level, or nested within containers such as areas.
		
		<p><b>Deprecated:</b> use &lt;wr:LandmarkMenu type=&quot;page&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Attribute name="level" required="false">
		<Description>
			<![CDATA[
			Identifies the level in the area hierarchy for which landmark pages should
			be retrieved. Level 1 identifies top-level landmark pages, level 2 identifies landmark
			pages nested inside 1st-level areas, and so on.
			
			<p>When the tag is nested inside other landmark menu tags, the level is ignored,
			since the retrieved landmarks are the direct children of the parent menu current one.</p>
			]]>
		</Description>
	</Attribute>
	<Attribute name="range" required="false">
		<Description>
			<![CDATA[
			A numeric range (e.g., 1-3), which defines a subset of landmark pages; both range
			indices are optional.
			The ordering of landmark pages is defined into the model.
			]]>
		</Description>
	</Attribute>
	<Attribute name="var" required="false">
		<Description>
			<![CDATA[
			The exported variable to hold the current element of the iteration.
			The iteration element is always a top-level Page.
			]]>
		</Description>
	</Attribute>
	<Attribute name="varIndex" required="false">
		<Description>
			The exported variable to hold the current 0-based index of the iteration.
		</Description>
	</Attribute>
	<Attribute name="varCount" required="false">
		<Description>
			The exported variable to hold the total number of iterations.
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
		It must contain the HTML fragment to be repeated for rendering the anchors of the landmark pages. 
		Such HTML fragment must contain a <a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event&gt;</a> tag, which denotes the anchor pointing to  
		each landmark page.
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
      &lt;wr:LandmarkPageMenu level=&quot;1&quot;&gt;
        &lt;td&gt;&lt;wr:Event/&gt;&lt;/td&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!--the character | is used as a separator--&gt;
      &lt;/wr:LandmarkPageMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
	<AssistantInfo hasBrackets="true">
		<Variable name="var" type="Object">The current element of the iteration (wr:LandmarkPageMenu tag)</Variable>
		<Variable name="varIndex" type="Integer">The current index of the iteration (wr:LandmarkPageMenu tag)</Variable>
		<Variable name="varCount" type="Integer">The total number of iterations (wr:LandmarkPageMenu tag)</Variable>
	</AssistantInfo>
</Tag>