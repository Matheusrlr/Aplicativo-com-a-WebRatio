<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|event|screen|comp">
	<Description>
		<![CDATA[
		Evaluates the specified template and prints its output. Alternatively, renders a
		layout element using its configured layout template plus any built-in behavior.
		
		<p>For user templates, this tag behaves the same as an explicit 
		<code>printRaw(executeTemplate(...))</code> statement.</p>
		
		<p>For layout elements, this tag works like a simpler version of element-rendering tags
		(e.g. <code>wr:Element</code>),	albeit with reduced flexibility. The configured layout
		template is evaluated and built-in behaviors are included.<br/>
		However, not all types of layout elements are supported and it is not possible to
		fine-tune the layout process. For these reasons, element-rendering tags should be
		preferred over this tag when not invoking custom templates.</p>
		]]>
	</Description>
	<Attribute name="var" required="true">
		<Description>
			Map of binding variables to set during evaluation of the specified template.
			If a template path is not specified, the variable containing the element to lay out.
		</Description>
	</Attribute>
	<Attribute name="type" required="false">
		<Description>
			Only if a template path is not specified, the type of layout process to use for
			laying out the element. This typically corresponds to the type of layout element
			being passed as &apos;var&apos;.
			Possible values are: cell, component, field, event, attribute.
		</Description>
	</Attribute>
	<Attribute name="template" required="false">
		<Description>
			Path of the template to evaluate and print.
			This is optional when specifying &apos;type&apos;, since in that case the built-in generation
			logic and the configured layout template are used.
		</Description>
	</Attribute>
</Tag>