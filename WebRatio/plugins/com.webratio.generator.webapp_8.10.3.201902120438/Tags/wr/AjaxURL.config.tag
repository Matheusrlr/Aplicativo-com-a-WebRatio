<?xml version="1.0" encoding="UTF-8"?>
<Tag body="false" templateTypes="attr|cell|field|frame|grid|event|page|comp" nestable="true">
  <Description>
    Produces the value of the onclick attribute for a specific AJAX Layout Event.
  </Description>
  <Attribute name="context" required="false">
    <Description>
      <![CDATA[
      The variable used to locate the AJAX Layout Event whose
      onclick code should be printed out. If undefined, the nearest 
      surrounding tag having one of the following types is searched: 
      &lt;wr:Iterate&gt;
      ]]>
    </Description>
  </Attribute>
  <Attribute name="select" required="false">
    <Description>
      Optional XPath applied to the context variable to select the
      Layout Event whose onclick code should be printed out. If undefined,
      the context element itself is selected.
    </Description>
  </Attribute>
  <Attribute name="position" required="false">
    <Description>
      The name (or a comma-separated list of names) of page context 
      variables representing the current instance for a set-oriented 
      view component (e.g. SimpleList).
    </Description>
  </Attribute>
  <Attribute name="escapeXml">
    <Description>
      If set to true (default behavior) the resulting code is XML-escaped.
    </Description>
  </Attribute>
  <Attribute name="type" required="false">
    <Description>
      The HTML rendering to use: anchor (the default) or button. 
    </Description>
  </Attribute>
   <Parents>
    <Iterate/>
  </Parents>
  <Usage>
    <![CDATA[
    <p> 
      The following example shows how to print an AJAX Layout Event:
    </p>
    <source>
    &lt;% def compEvent = component.selectSingleNode("layout:Event") %&gt;
    &lt;a href=&quot;&lt;wr:URL context=&quot;compEvent&quot;/&gt; onclick=&quot;&lt;wr:AjaxURL context=&quot;compEvent&quot;/&gt;&quot;&gt;
    	&lt;wr:Label context=&quot;compEvent&quot;/&gt;
    &lt;/a&gt;
    </source>
    ]]>
  </Usage>
</Tag>