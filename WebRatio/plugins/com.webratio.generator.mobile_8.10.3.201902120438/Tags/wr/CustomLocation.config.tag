<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="screen">
	<Description>
		<![CDATA[
		Renders the output of a Custom Location, identified by its user-defined name.
		
		<p>The rendering is dictated by the custom location cell layout template,
		with leading/trailing whitespace removed and with the addition of any compatible
		built-in behaviors.</p>
		
		<p>The custom location contents are drawn from the <i>closest</i> Toolbar or
		Screen that is placing layout elements into it.
		<ol>
		<li>Toolbars are considered first, from the farthest (outermost) ones to the
		closest ones. Toolbars <i>overridden</i> by others are not considered.</li>
		<li>If no Toolbar is filling the custom location, the Screen and its enclosed
		Toolbars are taken into account.</li>
		<li>Finally, if the custom location is not populated by any Toolbar of Screen
		it is considered to be empty. Nothing is rendered in this case.</li>
		</ol>
		</p>
		]]>
	</Description>
	<Attribute name="name" required="true">
		<Description>
			A name that uniquely identifies a custom location in the screen template.
			The name is used by Toolbars and Screens to refer to the custom location and
			populate it. The name is also visible in the WebRatio IDE.
		</Description>
	</Attribute>
	<Attribute name="idePosition" required="false">
		<Description>
			<![CDATA[
			Indication of how to place the custom location when displaying it in the
			WebRatio IDE.
			
			<p>This attribute is intended to aid the user in picturing the
			final layout of custom locations within the screen and should generally be
			consistent with the final product of the screen template.</p>
			
			<p>Possible values are:
			<ul>
			<li><code>top</code> - at the top of the screen, over the main Grid area</li>,
			<li><code>bottom</code> - at the bottom of the screen, below the main Grid area</li>.
			</ul></p>
			]]>
		</Description>
	</Attribute>
</Tag>