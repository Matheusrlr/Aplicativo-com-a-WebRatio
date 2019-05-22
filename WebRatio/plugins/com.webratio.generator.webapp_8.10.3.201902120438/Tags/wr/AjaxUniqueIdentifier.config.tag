<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp" nestable="true">
  <Description>
    Produces a unique identifier string for a layout element that will
    participate in AJAX interactions.
  </Description>
  <Attribute name="context" required="false">
    <Description>
      <![CDATA[
      The variable used to locate the layout element for which to
      generate the identifier. If undefined, the nearest surrounding
      tag having one of the following types is searched: 
      &lt;wr:Iterate&gt;
      ]]>
    </Description>
  </Attribute>
  <Attribute name="select" required="false">
    <Description>
      Optional XPath applied to the context variable to select the
      layout element for which to generate the identifier. If undefined,
      the context element itself is selected.
    </Description>
  </Attribute>
  <Attribute name="item" required="false">
    <Description>
      For attribute values, the name of the current instance. 
      If unspecified, the empty string is used.
    </Description>
  </Attribute>
  <Attribute name="position" required="false">
    <Description>
      The name (or a comma-separated list of names) of page context 
      variables representing the current instance for a set-oriented 
      view component (e.g. SimpleList)
    </Description>
  </Attribute>
   <Parents>
    <Iterate/>
  </Parents>
  <Usage>
    <![CDATA[
    <p> 
      The following example shows how to print an unique identifier for a table row:
    </p>
    <source>
    &lt;tr id=&quot;&lt;wr:AjaxUniqueIdentifier context=&quot;component&quot; item=&quot;current&quot; position=&quot;index&quot;/&gt;&quot;&gt;
  	  &lt;td&gt;Test&lt;/td&gt;
    &lt;/tr&gt;
    </source>
    ]]>
  </Usage>
</Tag>