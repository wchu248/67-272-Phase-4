Feature: Manage prices
  As an administrator
  I want to be able to create and read prices in the system
  So make sure the core of my business runs correctly

  Background:
    Given an initial setup
  
  # READ METHODS
  Scenario: No prices yet
    Given no setup yet
    Given only items
    When I go to the item prices page
    And I should see "N/A"
    And I should not see "$2.50"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View list of current prices
    When I go to the item prices page
    Then I should see "Current Item Prices"
    And I should see "Item"
    And I should see "Price"
    And I should see "Basic Analog Chess Clock"
    And I should see "$10.95"
    And I should see "Mahogany Wood Chess Board"
    And I should see "$29.00"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
  
  Scenario: The item name is a link to item details
    When I go to the item prices page
    And I click on the link "Basic Chess Pieces"
    And I should see "Basic Chess Pieces"
    And I should see "Price: $2.50"
    And I should see "Inventory Level: 190"

  
  # CREATE METHODS
  Scenario: Creating a new price is successful
    When I go to the new price page
    Then I should see "New Price"
    And I select "Basic Chess Pieces" from "item_price_item_id"
    And I fill in "item_price_price" with "3.05"
    And I press "Create Item price"
    Then I should see "Changed the price of Basic Chess Pieces"
    And I should see "Price: $3.05"
    And I should see "Inventory Level: 190"
    And I should see "Price History"

