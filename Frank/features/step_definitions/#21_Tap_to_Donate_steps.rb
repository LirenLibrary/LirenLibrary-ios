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

When /^I tap 扫描 button$/ do
	touch "view view:'UIButton' marked:'scan button 03'"
	wait_for_nothing_to_be_animating
end

Then /^I should be on the book scan view$/ do
	check_element_exists "view view:'UIImageView' marked:'scan_back'"
	check_element_exists "view view:'UIButton' marked:'flashlight'"
end

When /^I tap 取消 button$/ do
	touch "view view:'UIButton' index:0"
	wait_for_nothing_to_be_animating
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

When /^I tap the first record$/ do
	touch "view:'UILabel' marked:'1本'"
	wait_for_nothing_to_be_animating
end

Then /^I should see donation details$/ do
	touch "view:'UINavigationItemButtonView' marked:'返回'"
	wait_for_nothing_to_be_animating
end

Then /^I should be back on the donation list view$/ do
  
end