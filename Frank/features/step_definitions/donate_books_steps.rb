# coding: utf-8

Given /^I am a donator$/ do
end

When /^I tap the liren App icon on my iPhone$/ do
end

Then /^I should be see the Home page with 捐赠 and 记录 buttons$/ do
	check_element_exists "view view:'UIRoundedRectButton' marked:'捐赠'"
	check_element_exists "view view:'UIRoundedRectButton' marked:'记录'"
end

Given /^I had never donated any books via liren app$/ do
end

Given /^I am on the Home Page$/ do
end

When /^I tap 捐赠$/ do
 	touch "view view:'UIRoundedRectButton' marked:'捐赠'"
	wait_for_nothing_to_be_animating
end

Then /^I should see 扫描 button$/ do
	check_element_exists "view view:'UIButton' marked:'scan button 03'"
end

Then /^I should see 返回 button$/ do
	check_element_exists "view:'UINavigationItemButtonView' marked:'返回'"
end

Then /^I should see 提交 button disabled$/ do
end

Given /^I already scanned books: 民主的细节 and 钢铁是怎样炼成的$/ do
end

