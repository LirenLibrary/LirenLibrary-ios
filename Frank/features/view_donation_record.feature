Feature: View my donation record 
  As a regular donator who already donated some books
  I want to view my donation record via my iPhone
  So that I can know what I can do next

#Story 20
Scenario: Navigate to the Donation record page
  Given I already donated 3 books on 21th,Dec,2012
  And I am on the Home Page
  When I tap "记录" button
  Then I should see "返回" button
  And I should see "2012年12月21日"
  And I should see "3 本"

#Story 5
Scenario: View the “审核中” donation record 
  Given I already donated 3 books on 21th,Dec,2012
  And the approvement is still in progress
  When I tap the donation record 
  Then I should see 审核中 message

#Story 5
Scenario: View the “可寄送” donation record 
  Given I already donated 3 books on 21th,Dec,2012
  And the approvement is done
  When I tap the donation record 
  Then I should see 可寄送 message

#Story 5
Scenario: View the “已拒绝” donation record 
  Given I already donated 3 books on 21th,Dec,2012
  And the donation is refused
  When I tap the donation record 
  Then I should see 对不起 message

#Story 4
Scenario: View the donation record 
  Given I already donated 2 books: "民主的细节" and "钢铁是怎样炼成的"
  When I tap the donation record 
  Then I can see those 2 books displayed with right title："民主的细节" and "钢铁是怎样炼成的"

#Story 4 May no need to be implemented, acts as live document
Scenario: View the “已拒绝” donation record 
  Given I already donated 2 books: "民主的细节" and "钢铁是怎样炼成的"
  When I tap the donation record 
  Then I can see the books displayed in red
