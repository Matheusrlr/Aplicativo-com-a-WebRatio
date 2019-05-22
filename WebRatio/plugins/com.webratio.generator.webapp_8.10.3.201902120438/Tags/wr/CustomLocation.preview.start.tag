$$ def name = tag["name"] 
	if (name == null || name == ""){
		tagProblems.addFatalError("Attribute Name must be specified on the <wr:CustomLocation/> tag")
	}
$$
<table class="cust_wr">
  <tr class="cust_tr_wr"><td class="cust_td_wr">Location name=[%= "$$=name$$" %]</td></tr>
</table>