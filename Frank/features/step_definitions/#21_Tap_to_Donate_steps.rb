Then /^I should be on the landing screen$/ do
	#检查是否有‘捐赠’按钮
	check_element_exists "view view:'UIRoundedRectButton' marked:'\u6350\u8d60'"

	#检查是否有'记录'按钮
	check_element_exists "view view:'UIRoundedRectButton' marked:'\u8bb0\u5f55'"
end
