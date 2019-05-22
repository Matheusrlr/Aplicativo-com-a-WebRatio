#?delimiters [%, %], [%=, %]
$$
import org.apache.commons.lang.StringUtils
setJavaOutput()

def multipart = (tag["multipart"] ?: "true") == "true"
def ignoreStyleId = (tag["ignoreStyleId"] ?: "false") == "true"
$$
[%
	def masterPage = (page["ignoreMasterContainer"] == "true") ? null : getEffectiveMasterContainer(page)
	def formBasedComps = []
	formBasedComps.addAll(getFormBasedViewComponents(page))
	if (masterPage) {
		formBasedComps.addAll(getFormBasedViewComponents(masterPage))
	}
	def submitEventIds = formBasedComps.collect { getSubmitLayoutEventIds(it) }.sum()

	/* Boxing wrapper start */ %]
	<c:if test="${wrBoxed}">
		<div <c:if test="${not wrAjax}">id="wr-${wrClientAppName}" data-wr-appid="${wrClientAppName}"</c:if> class="wr-appui wr-appui-${wrClientAppName}">
	</c:if>
	<webratio:CollectScripts var="inlineScripts" enabled="${wrBoxed}" eventHandlerWrapper="wr.keepScoped">
	[%

	/* If used, add a view control for the waiting dialog */
	if (isWaitingDialogUsed(page)) { %]
		<script type="text/javascript">
			if (typeof wr !== "undefined") {
				WRAjax.onReady(function() {
					wr.getApp().getPlugin("ui").configureViews(null, {
						_oldajax_ww: {
							factory: "window",
							viewer: "wr.ui.jquery.WaitDialogViewer"
						}
					});
				});
			}
		</script>
	[% }
	
	/* Browser integration page marker */
	if (isBrowserIntegrationEnabled()) { %]
		<wr:RequireResource ref="wr-browsercontrol-style"/>
		<div id="_wr_page" title="[%= projectName %];[%= getOriginalId(page["id"]) %]"></div>
	[% }
	
	/* With form-based view components, provide a form and hidden preserve fields */
	if (!formBasedComps.empty) { %]
		[% printRaw(executeContextTemplate("MVC/Wrapper.template", ["refreshFragmentType": "formStart", "content": { %]
			<form:form action="${wrFormContextPath}form_[%= getPageRuntimeId(page) %].do${wrAjax ? '#!ajax=true' : ''}" $$if (!ignoreStyleId) {$$id="[%=getFormBeanName(page)%]"$$}$$ $$if (multipart) {$$enctype="multipart/form-data"$$}$$>
		[% }])) %]
		[% /* Hack for absolute URLs in form action */ %]
		<c:if test="${wrBoxed}">
			<script>
				jQuery("#[%= escapeCSS(getFormBeanName(page)) %]").prop("action", "${wrBaseURI}form_[%= getPageRuntimeId(page) %].do${wrAjax ? '#!ajax=true' : ''}");
			</script>
		</c:if>
		[% printRaw(executeContextTemplate("MVC/Wrapper.template", ["always": true, "wrapperId": getPageRuntimeId(page) + "HiddenFields", "refreshFragmentType": "hiddenFields", "content": { %]
			<form:hidden path="lastURL" id="lastURL_[%= getPageRuntimeId(page) %]"/>
			[% for (submitEventId in submitEventIds) { %]
				[%
					def submitEvent = getById(submitEventId)
					def submitEventFlowId = submitEvent.valueOf("NavigationFlow/@id")
				%]
				<input type="hidden" name="[%= submitEventFlowId %]" value="<webratio:Link link="[%= getEventRuntimeId(submitEvent) %]" />"[% if (pageOutputType.name == "xhtml") { %]/[% } %]>
				[% if (isSelectiveRefreshEvent(submitEvent)) { %]
					<input type="hidden" name="[%= submitEventFlowId %]_sr" value="<webratio:Link link="[%= getEventRuntimeId(submitEvent) %]" selectiveRefresh="true" />"[% if (pageOutputType.name == "xhtml") { %]/[% } %]>
				[% } %]
			[% } %]
		[% }])) %]
	[% }
%]