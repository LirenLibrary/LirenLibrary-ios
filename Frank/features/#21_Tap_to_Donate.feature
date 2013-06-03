Feature:
	As a book donator
	I want to tap the '捐赠' button
	So I can see the BookScanListViewController to start scanning my books

Scenario:
	Started the App
Given I launch the app
Then I should be on the landing screen

When I tap 捐赠 button
Then I should be on the BookScanListViewController

When I tap 扫描 button
Then I should be on the book scan view

When I tap 取消 button
Then I should be on the BookScanListViewController

When I tap 返回 button
Then I should be on the landing screen
