<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page" deprecated="true">
	<Description>
		<![CDATA[
		Iterates over all the landmark areas available in the final site view of the page.
		Such areas can be at the site view level, or nested within containers such as other areas.
		
		<p><b>Deprecated:</b> use &lt;wr:LandmarkMenu type=&quot;area&quot;/&gt; instead.</p>
		]]>
	</Description>
	<Attribute name="level" required="false">
		<Description>
			<![CDATA[
			Identifies the level in the area hierarchy for which landmark areas should
			be retrieved. Level 1 identifies top-level landmark areas, level 2 identifies landmark
			areas nested inside 1st-level areas, and so on.
			
			<p>When the tag is nested inside other landmark menu tags, the level is ignored,
			since the retrieved landmarks are the direct children of the parent menu current one.</p>
			]]>
		</Description>
	</Attribute>
	<Attribute name="range" required="false">
		<Description>
			<![CDATA[
			A numeric range (e.g., 1-3), which defines a subset of landmark areas; both range
			indices are optional.
			The ordering of landmark areas is defined into the model.
			]]>
		</Description>
	</Attribute>
	<Attribute name="var" required="false">
		<Description>
			<![CDATA[
			The exported variable to hold the current element of the iteration.
			The iteration element is always an Area.
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
		It must contain the HTML fragment to be repeated for rendering the anchors of the landmark areas. 
		Such HTML fragment must contain a wr:Event tag, which denotes the anchor pointing to each area.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
		  The <b>&lt;wr:LandmarkAreaMenu&gt;</b> tag is an iterator: its content is repeated as many times as the 
		  number of landmark areas at the specified level of the hierarchy and within the specified range.
		</p>
		<p>
		  The inner <a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event&gt;</a> tag is replaced by an HTML anchor, pointing to 
		  the default page of the landmark area.
		</p>
		<p>
		  The following example demonstrates a piece of HTML for laying out the anchors of the top-level 
		  landmark areas; such anchors are distributed horizontally in one HTML row, with each anchor placed 
		  in a different cell, separated from the next anchor by a vertical bar:
		</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkAreaMenu level=&quot;1&quot;&gt;
        &lt;td&gt;&lt;wr:Event/&gt;&lt;/td&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!--the character | is used as a separator--&gt;
      &lt;/wr:LandmarkAreaMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		<p>
		Note that, for a <a href="/Concepts/StyleDefinition/PageLayout"/> to be reusable 
		in multiple projects, the HTML layout should be applicable 
		to site views consisting of a variable number of areas, with area names of variable length; 
		therefore, the absolute size of the entire area menu cannot be determined in advance. To overcome 
		this problem, it is good practice to include the wr:LandmarkAreaMenu inside a table, whose 
		size can be stretched according to the number of links and to the length of their anchor. 
		Conversely, because the number of areas may vary from page to page, a layout like the 
		following one may produce undesired results:
		</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;td&gt;FooBar&lt;/td&gt;
      &lt;td&gt;Foo&lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkAreaMenu level=&quot;1&quot;&gt;
        &lt;td&gt;&lt;wr:Event/&gt;&lt;/td&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!--the character | is used as a separator--&gt;
      &lt;/wr:LandmarkAreaMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		<p>
		The problem is that, depending on the actual number of areas, the number of columns in the two 
		rows may be different, producing unexpected results.
		</p>
		<p>
		<note> The possibility of individually placing the anchor of landmark areas is limited to the 
		top-level areas, and not available for the nested areas.</note>
		</p>
		]]>
	</Usage>
	<AssistantInfo hasBrackets="true">
		<Variable name="var" type="Object">The current element of the iteration (wr:LandmarkAreaMenu tag)</Variable>
		<Variable name="varIndex" type="Integer">The current index of the iteration (wr:LandmarkAreaMenu tag)</Variable>
		<Variable name="varCount" type="Integer">The total number of iterations (wr:LandmarkAreaMenu tag)</Variable>
	</AssistantInfo>
</Tag>