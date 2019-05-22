<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp">
	<Description>
		<![CDATA[
		Evaluates the specified template and prints its output. Alternatively, renders a
		layout element using its configured layout template plus any built-in behavior.
		
		<p>For user templates, this tag behaves the same as an explicit 
		<code>printRaw(executeTemplate(...))</code> statement.</p>
		
		<p>For layout elements, this tag works like a simpler version of element-rendering tags
		(e.g. <code>wr:Element</code>),	albeit with reduced flexibility. The configured layout
		template is evaluated and built-in behaviors such as AJAX support code and visibility
		tests are included.<br/>
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
			Possible values are: grid, cell, component, field, event, attribute.
		</Description>
	</Attribute>
	<Attribute name="template" required="false">
		<Description>
			Path of the template to evaluate and print.
			This is optional when specifying &apos;type&apos;, since in that case the built-in generation
			logic and the configured layout template are used.
		</Description>
	</Attribute>
	<Usage>
		<![CDATA[
		<p>
			The tag is used to evaluate and print a template into another template. As such, it removes
			the need for explicitly calling <code>printRaw(executeTemplate(...))</code>. 
		</p>
		<p>
			A common use case is executing an external "helper" template to be included in the current template.
			This enables splitting a large template into smaller reusable templates.
			<source>
	&lt;td&gt;
	  [% def cellLayout = getLayout(cell, LayoutType.CELL)
	  def templateDir = getLayoutFile(cellLayout.path, LayoutType.CELL).parentFile
	  def templatePath = templateDir.absolutePath + &quot;/Preview.Helper.template&quot; 
	  def templateVars = [&quot;tempVar&quot;: value] %]
	  &lt;wr:PrintTemplate var=&quot;templateVars&quot; template=&quot;templatePath&quot;/&gt;
	&lt;/td&gt;
			</source>
			The template path (<code>templatePath</code>) is built using the base path of the current template
			(assumed to be a Cell Template in the example). The <code>templateVars</code> map is used to pass
			values to be made available in the external template as scripting variables. As is always the case,
			the scripting variables of the <i>current</i> template (e.g. <code>params</code>, <code>cell</code>)
			are implicitly passed along and do not need to be specified.<br/>
			The example code is equivalent to writing:
			<source>
	&lt;td&gt;
	  [% def cellLayout = getLayout(cell, LayoutType.CELL) %]
	  [% def templateDir = getLayoutFile(cellLayout.path, LayoutType.CELL).parentFile %]
	  [% printRaw(executeTemplate(templateDir.absolutePath + &quot;/Preview.Helper.template&quot;), [&quot;tempVar&quot;: value]) %]
	&lt;/td&gt;
			</source>
			If the executed template does not require additional variables, the <code>templateVars</code> map
			should be set to <code>null</code>.
			<source>
	&lt;td&gt;
	  [% def cellLayout = getLayout(cell, LayoutType.CELL)
	  def templateDir = getLayoutFile(cellLayout.path, LayoutType.CELL).parentFile
	  def templatePath = templateDir.absolutePath + &quot;/Preview.Helper.template&quot;
	  def templateVars = null %]
	  &lt;wr:PrintTemplate var=&quot;templateVars&quot; template=&quot;templatePath&quot;/&gt;
	&lt;/td&gt;
			</source>
			This corresponds to writing:
			<source>
	&lt;td&gt;
	  [% def cellLayout = getLayout(cell, LayoutType.CELL) %]
	  [% def templateDir = getLayoutFile(cellLayout.path, LayoutType.CELL).parentFile %]
	  [% printRaw(executeTemplate(templateDir.absolutePath + &quot;/Preview.Helper.template&quot;)) %]
	&lt;/td&gt;
			</source>
		</p>
		<p>
			Another possible use of the tag is laying out an element, as configured in its layout properties.
			<source>
	&lt;div&gt;
	  [% for (simpleList in simpleLists) { %]
	    &lt;wr:PrintTemplate var=&quot;simpleList&quot; type=&quot;component&quot;/&gt;
	  [% } %]
	&lt;/div&gt;
			</source>
			The above code will lay each element by using its configured Component Template, with the addition of
			any code required for built-in behaviors. In cases like this, also consider using a specific
			element-rendering tag (such as  <code>wr:Element</code>) instead of this tag.
		</p>
		]]>
	</Usage>
</Tag>