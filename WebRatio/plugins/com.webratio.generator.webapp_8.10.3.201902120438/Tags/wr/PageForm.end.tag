#?delimiters [%, %], [%=, %]
$$
import org.apache.commons.lang.StringUtils
setJavaOutput()

def fieldFocusScript = (tag["fieldFocusScript"] ?: "true") == "true"

/* Look for containing PageBody tag */
def pageBodyTag = ancestorTags.find{it.name == "wr:PageBody"}

/* With form-based view components, close the form and focus the first field */
$$[% if (!formBasedComps.empty) { %]
	[% printRaw(executeContextTemplate("MVC/Wrapper.template", ["refreshFragmentType": "formEnd", "content": { %]
		</form:form>
	[% }])) %]
	$$ if (fieldFocusScript) { $$
		<script type="text/javascript">
			if (typeof wr !== "undefined" && wr.getApp().isConfigurable()) {
				wr.getApp().mergeConfig({
					"ui+": {
						autoFocusFirstWindow: true
					}
				});
			}
		</script>
	$$ } $$
[% } %]$$

/* If using AJAX features, unconditionally require the Client Runtime (there is no closer place to do this) */
$$[% if (isAjaxGenericPage(page)) { %]
	<wr:RequireResource ref="wr-runtime"/>
[% } else { %]
	<wr:RequireResource ref="wr-runtime" condition="wrAjaxCalling"/>
[% } %]$$

/* Initial client propagation state */
$$[% if (getPropagationMode(page).isClient()) { %]
	<script type="application/json" class="wr-linkInfos">
		<webratio:LinkInfos page="[%= page["id"] %]"/>
	</script>
	[% if (isSelectiveRefreshGenericPage(page)) { %]
		<script type="application/json" class="wr-linkInfosSelective">
			<webratio:LinkInfos page="[%= page["id"] %]" selectiveRefresh="true"/>
		</script>
	[% } %]
	<script type="application/json" class="wr-linkData">
		<webratio:LinkData page="[%= page["id"] %]"/>
	</script>
[% } %]$$

/* Boxing wrapper end */
$$</webratio:CollectScripts>
<c:if test="${wrBoxed}">
	<wr:RequireResource ref="jquery, wr-runtime" condition="wrBoxed">
		</div>
		<c:if test="${not wrAjax}">
			<script type="text/javascript">
				jQuery(function($) {
					wr.ui.html.addRemoveListener($("#wr-${wrClientAppName}")[0], $.proxy(wr.runScoped, this, "${wrClientAppName}", wr.LegacyAjaxPlugin.exit));
				});
				wr._configs["${wrClientAppName}"]();
			</script>
		</c:if>
		<c:if test="${not(empty inlineScripts)}">
			<script type="text/javascript">
				wr.runScoped("${wrClientAppName}", function(ajaxRequest, WRAjaxRequest, $H, WRAjax, WRAjaxRequestUtils, WRAjaxRequestQueue, WREvent, WREventUtils, Form) {
					${inlineScripts}
				});
			</script>
		</c:if>
	</wr:RequireResource>
</c:if>