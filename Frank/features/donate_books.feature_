Feature: Donate my books to liren library 
    As a donator
    I want to donate my books to liren library via my iPhone
    So that my books can be used by liren students

#Story 21
Scenario: Landing
    Given I am a donator 
    When I tap the liren App icon on my iPhone
    Then I should be see the Home page with 捐赠 and 记录 buttons

#Story 21
Scenario: Navigate to Scan Page at the first time
    Given I had never donated any books via liren app
    And I am on the Home Page
    When I tap 捐赠
    Then I should see 扫描 button 
    Then I should see 返回 button
    Then I should see 提交 button disabled

#Story 21
Scenario: Navigate to Scan Page when already scanned some books
    Given I already scanned books: 民主的细节 and 钢铁是怎样炼成的
    And I am on the Home Page
    When I tap 捐赠 
    Then I should see 扫描 button 
    Then I should see 返回 button
    Then I should see 提交 button 

#Story 2
Scenario: Donate books
    Given I already scanned 2 books: 民主的细节 and 钢铁是怎样炼成的
    When I am on the PreScan page
    Then I can see those 2 books displayed with right title：民主的细节 and 钢铁是怎样炼成的

#Story 1
Scenario: Scan 
    Given I am on the PreScan Page
    When I tap 扫描 
    Then I should see the Scan area on the Scan Page
    Then I should see 取消 button

#Story 1
Scenario: Cancel scanning 
    Given I am on the Scan page
    When I tap 取消 
    Then I should see 扫描 button 

#Story 3
Scenario: Apply for approvement  
     Given I already scanned 2 books: 民主的细节 and 钢铁是怎样炼成的
     When I tap 提交 button on the PreScan page
     Then I should see Thank you message
     Then I can see those 2 books displayed with right title：民主的细节 and 钢铁是怎样炼成的
