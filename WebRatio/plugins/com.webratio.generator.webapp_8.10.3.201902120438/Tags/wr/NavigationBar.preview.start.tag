$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def classAttr = StringUtils.defaultString(tag["class"], "")
def separator = StringUtils.defaultString(tag["separator"], "")
def linkClass = StringUtils.defaultString(tag["linkClass"], "")
$$
$$ if (standalone) { $$<span class="[%="$$=classAttr$$"%]">
[% for (area in getAncestorLandmarks(page).reverse()) { %]
[%="$$=separator$$"%]</span><a class="[%="$$=linkClass$$"%]" href="#">
[%="NavigationBar" + " level " + (getAncestorLandmarks(page).reverse().indexOf(area) + 1)%]
</a><span class="[%="$$=classAttr$$"%]">
[%}%]
</span>
$$ } else {$$
[% for (_wr_var0 in getAncestorLandmarks(page).reverse()) { %]
$$ }  $$