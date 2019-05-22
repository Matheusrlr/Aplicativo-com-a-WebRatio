<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="page">
	<Description>
		<![CDATA[
        Renders the output of the main Grid of the page.
		
		<p>The rendering is dictated by the grid layout template,
		with the addition of any compatible built-in behaviors.</p>
		
		<p>Some example of behavior code are:
		<ul>
			<li>HTML code enabling AJAX features such as selective refresh,</li>
			<li>server-side test for an attached Visibility Condition.</li>
		</ul>
		The additional code is included only when compatible with the page output type set
		by <code>wr:Page</code>. For example, AJAX features are included only in pages
		whose output is HTML or XHTML.</p>
		
		<p>About Visibility Conditions support, only the rendered grid is subject to the condition.
		To also affect the grid surroundings use the <code>wr:Visible</code> tag.</p>
		]]>
	</Description>
	<Usage>
		<![CDATA[
		<p>
			The grid is the main location of the page where dynamic content can be placed. The <code>wr:Grid</code>
			tag marks such location in the page layout.
		</p>
		<p>
			Each <a href="/Concepts/StyleDefinition/PageLayout"/> should include at most 
			one grid; if no grid is included, then custom locations must be used for positioning layout elements.
		</p>
		<p>
			The grid is composed of one or more cells. Since the actual layout elements that will 
			be rendered inside the grid depend on the specific page, the exact amount of space required by 
			the rendition of the <code>wr:Grid</code> tag is not known a priori. Therefore, the page layout must be 
			designed in such a way that contents of different sizes can be accommodated.
		</p>
		<p>
			Positioning multiple occurrences of the <code>wr:Grid</code> tag in the page layout is permitted, but 
			results in the same grid contents being displayed multiple times in the generated page, which is 
			normally a design error.
		</p>
		]]>
	</Usage>
</Tag>