Feature: Manage purchases
  As an administrator
  I want to be able to create and read purchases in the system
  So make sure the core of my business runs correctly

  Background:
    Given an initial setup
  
  # READ METHODS

  Scenario: View all purchases
    Given a dated purchase
    When I go to the purchases page
    Then I should see "Recent Purchases"
    And I should see "Item"
    And I should see "Quantity"
    And I should see "Date"
    And I should see "Basic Analog Chess Clock"
    And I should see "30"
    And I should see "Basic Chess Pieces"
    And I should see "-10"
    And I should see "Chronos Chess Clock"
    And I should see "12"
    And I should see "02/15/17"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
  
  Scenario: The item name is a link to item details
    When I go to the purchases page
    And I click on the link "Basic Analog Chess Clock"
    And I should see "Basic Analog Chess Clock"
    And I should see "Price: $10.95"
    And I should see "Inventory Level: 130"
    And I should see "Price History"

  
  # CREATE METHODS
  Scenario: Creating a new purchase is successful
    When I go to the new purchase page
    And I select "ZMF-II Digital Chess Timer Green" from "purchase_item_id"
    And I fill in "purchase_quantity" with "10"
    And I press "Create Purchase"
    Then I should see "Recent Purchases"
    And I should see "ZMF-II Digital Chess Timer Green"
    And I should see "10"
