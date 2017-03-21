Feature: Manage items
  As an administrator
  I want to be able to create, read and update items in the system
  So make sure the core of my business runs correctly

  Background:
    Given an initial setup
  
  # READ METHODS
  Scenario: No items yet
    Given no setup yet
    When I go to the items page
    Then I should see "There are no items in the system at this time"
    And I should not see "Name"
    And I should not see "Inventory"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View all items
    When I go to the items page
    Then I should see "Available Items"
    And I should see "Name"
    And I should see "Price"
    And I should see "Inventory"
    And I should see "Boards"
    And I should see "Pieces"
    And I should see "Clocks"
    And I should see "Supplies"
    And I should see "Mahogany Wood Chess Board"
    And I should see "Weighted Chess Pieces"
    And I should see "$29.00"
    And I should see "$4.50"  
    And I should see "Inactive Items"
    And I should see "190"
    And I should see "130"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View item details
    When I go to the details on basic pieces
    And I should see "Basic Chess Pieces"
    And I should see "Price: $2.50"
    And I should see "The Basic Chess Pieces are our least expensive pieces and are ideal for schools and clubs working on a tight budget. These chess sets meet all chess tournament standards and regulations. They are a standard Staunton design and have a 3 3/4 inch tall King with a 1 1/2 inch felt paper base."
    And I should see "Inventory Level: 190"
    And I should see "Color: black/white"
    And I should see "Price History"
    And I should see "$2.25"
    And I should see "Similar Items"
    And I should see "Weighted Chess Pieces"
    And I should not see "Mahogany Wood Chess Board"
    And I should not see "Basic Analog Chess Clock"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
  
  Scenario: The item name is a link to item details
    When I go to the items page
    And I click on the link "Basic Chess Pieces"
    And I should see "Basic Chess Pieces"
    And I should see "Price: $2.50"
    And I should see "Inventory Level: 190"

  
  # CREATE METHODS
  Scenario: Creating a new item is successful
    When I go to the new item page
    And I fill in "item_name" with "Basic Large Pieces"
    And I fill in "item_description" with "These pieces are just like our basic pieces, only larger."
    And I select "Pieces" from "item_category"
    And I fill in "item_color" with "black/white"
    And I fill in "item_weight" with "1.2"
    And I fill in "item_inventory_level" with "50"
    And I fill in "item_reorder_level" with "15"
    And I press "Create Item"
    Then I should see "Successfully created Basic Large Pieces"
    And I should see "Price: N/A"
    And I should see "Inventory Level: 50"
    And I should see "Description: These pieces are just like our basic pieces, only larger."
    And I should not see "Price History"

  
  Scenario: Creating a new item fails without name
    When I go to the new item page
    And I fill in "item_description" with "These pieces are just like our basic pieces, only larger."
    And I select "Pieces" from "item_category"
    And I fill in "item_color" with "black/white"
    And I fill in "item_weight" with "1.2"
    And I fill in "item_inventory_level" with "50"
    And I fill in "item_reorder_level" with "15"
    And I press "Create Item"
    Then I should see "can't be blank"
    Then I should not see "Successfully created Basic Large Pieces"
    And I should not see "Similar Items"


  # UPDATE METHODS
  Scenario: Editing an existing item is successful
    When I go to the edit basic pieces page
    Then I should not see "Inventory level"
    And I fill in "item_reorder_level" with "51"
    And I press "Update Item"
    Then I should see "Successfully updated Basic Chess Pieces"
    And I should see "Reorder Level: 51"


