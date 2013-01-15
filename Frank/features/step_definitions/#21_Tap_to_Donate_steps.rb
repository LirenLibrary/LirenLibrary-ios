# coding: utf-8

Then /^I should be on the landing screen$/ do
	check_element_exists "view view:'UIButton' marked:'button1 03'"
	#check_element_exists "view view:'UIRoundedRectButton' marked:'记录'"
end

When /^I tap 捐赠 button$/ do
	touch "view view:'UIButton' marked:'button1 03'"
	wait_for_nothing_to_be_animating
end

Then /^I should be on the BookScanListViewController$/ do
	check_element_exists "view view:'UITableView' marked:'Empty list'"
end

When /^I tap 返回 button$/ do
	touch "view:'UINavigationItemButtonView' marked:'返回'"
	wait_for_nothing_to_be_animating
end

When /^I tap 记录 button$/ do
	touch "view view:'UIButton' marked:'button2 03'"
	wait_for_nothing_to_be_animating
end

Then /^I should be on the DonationListViewController$/ do

end