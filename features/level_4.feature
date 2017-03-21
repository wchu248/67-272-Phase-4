Feature: Create dashboards
  As an employee
  I want an appropriate dashboard on my home page
  So I am informed on business issues I am responsible for


  # READ METHODS

  Scenario: View reorder list (manager)
    Given an initial setup
    Given a large scorebook purchase
    When I go to the home page
    Then I should see "Reorder List"
    And I should see "Inventory"
    And I should see "Reorder Level"
    And I should see "Softcover Quality Scorebook"
    And I should see "20"
    And I should see "25"
