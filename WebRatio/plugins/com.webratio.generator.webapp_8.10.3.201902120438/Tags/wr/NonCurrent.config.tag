<?xml version="1.0" encoding="UTF-8"?>
<Tag body="true" templateTypes="page">
	<Description>
		<![CDATA[
		Conditional tag which evaluates its body if the currently reached landmark of the surrounding
		iteration tag can <b>not</b> be considered to be <i>the same</i> as the generated page.
		
		<p>Landmark pages are the same if they actually <i>are</i> the generated page. Landmark
		areas are the same if they <i>contain</i> the generated page. Landmark actions
		and floating events are the same if, when visited, they <i>invariably reach</i> the generated page.</p>
		]]>
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
		It must contain the HTML fragment to be repeated for rendering the non-current landmark element. 
		Such HTML fragment must contain a <a href="/Reference/GenerationTagsReference/GenerationTags/Event">&lt;wr:Event&gt;</a> tag, which denotes the name of 
		the landmark area or landmark page it refers to.
		]]>
	</Content>
	<Usage>
		<![CDATA[
		<p>
		The <b>&lt;wr:NonCurrent&gt;</b> contains the markup used for the anchor of the non-current area or page, the 
		<a href="/Reference/GenerationTagsReference/GenerationTags/Current">&lt;wr:Current&gt;</a> tag for the current anchors.
		These tags come in pair: either both must be present, or none of them.
		</p>
		<p>
		Hence, the following HTML fragment is wrong, because the cell including the separator is placed 
		outside wr:NonCurrent and <a href="/Reference/GenerationTagsReference/GenerationTags/Current">&lt;wr:Current&gt;</a> tags:
		</p>
		<source>
  &lt;table&gt;
    &lt;tr&gt;
      &lt;wr:LandmarkAreaMenu level=&quot;1&quot;&gt;
        &lt;wr:Current&gt;
          &lt;td bgcolor=&quot;red&quot;&gt;&lt;wr:Event /&gt;&lt;/td&gt;
        &lt;/wr:Current&gt;
        &lt;wr:NonCurrent&gt;
          &lt;td bgcolor=&quot;yellow&quot;&gt;&lt;wr:Event /&gt;&lt;/td&gt;
        &lt;/wr:NonCurrent&gt;
        &lt;td&gt;|&lt;/td&gt; &lt;!-- the character | is used as a separator --&gt;
      &lt;/wr:LandmarkAreaMenu&gt;
    &lt;/tr&gt;
  &lt;/table&gt;
		</source>
		]]> 
	</Usage>
</Tag>