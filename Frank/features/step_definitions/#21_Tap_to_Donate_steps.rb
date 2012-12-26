Then /^I should be on the landing screen$/ do
	#检查是否有‘捐赠’按钮
	check_element_exists "view view:'UIRoundedRectButton' marked:'\u6350\u8d60'"

	#检查是否有'记录'按钮
	check_element_exists "view view:'UIRoundedRectButton' marked:'\u8bb0\u5f55'"
end

When /^I tap \u6350\u8d60 button$/ do
	touch "view view:'UIRoundedRectButton' marked:'\u6350\u8d60'"
	sleep(1)
end

Then /^I should be on the BookScanListViewController$/ do
	check_element_exists "view view:'UIRoundedRectButton' marked:'\u626b\u63cf'"
	check_element_exists "view view:'UITableView' marked:'Empty list'"
	check_element_exists "view view:'UINavigationItemView' marked:'\u7acb\u4eba\u6350\u4e66'"
end

When /^I tap \u8fd4\u56de button$/ do
	touch "view:'UINavigationItemButtonView' marked:'\u8fd4\u56de'"
	sleep(1)
end
