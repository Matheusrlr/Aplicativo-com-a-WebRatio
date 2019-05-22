<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page">
	<Description>
		<![CDATA[
		Iterates over all the landmark elements available in the final site view of the page.
		Such elements can be at the site view level, or nested within containers such as areas.
		
		<p>Can be nested inside other &lt;LandmarkMenu&gt; tags to retrieve the direct landmark
		children of each of the parent menu landmarks, effectively creating a menu structures.</p>
		]]>
	</Description>
	<Attribute name="level" required="false">
		<Description>
			<![CDATA[
			Identifies the level in the containers hierarchy for which landmark elements should
			be retrieved. Level 1 identifies top-level landmark elements, level 2 identifies landmark
			elements nested inside 1st-level areas, and so on. If unspecified, defaults to level 1.
			
			<p>When the tag is nested inside other &lt;LandmarkMenu&gt; tags, the level is ignored,
			since the retrieved landmarks are the direct children of the parent menu current one.</p>
			]]>
		</Description>
	</Attribute>
	<Attribute name="range" required="false">
		<Description>
			<![CDATA[
			A numeric range (e.g., 1-3), which defines a subset of landmark elements; both range
			indices are optional.
			The ordering of landmark elements is defined into the model.
			]]>
		</Description>
	</Attribute>
	<Attribute name="var" required="false">
		<Description>
			<![CDATA[
			The exported variable to hold the current element of the iteration.
			The iteration element can be an Area, Page, Action or a floating event.
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
	<Attribute name="type" required="false">
		<Description>
			<![CDATA[
			The type of landmark elements to retrieve. If unspecified, all landmark elements are taken into
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
		It must contain the HTML fragment to be repeated for rendering the landmark elements.  
		Such HTML fragment must contain a <a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event/&gt;</a> tag, 
		which denotes the anchor pointing to each landmark element.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>The following example demonstrates the tag usage:</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkMenu level=&quot;1&quot;&gt;
        &lt;td&gt;&lt;wr:Event/&gt;&lt;/td&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!--the character | is used as a separator--&gt;
      &lt;/wr:LandmarkMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		]]>
	</Usage>
	<AssistantInfo hasBrackets="true">
		<Variable name="var" type="Object">The current element of the iteration (wr:LandmarkMenu tag)</Variable>
		<Variable name="varIndex" type="Integer">The current index of the iteration (wr:LandmarkMenu tag)</Variable>
		<Variable name="varCount" type="Integer">The total number of iterations (wr:LandmarkMenu tag)</Variable>
	</AssistantInfo>
</Tag>