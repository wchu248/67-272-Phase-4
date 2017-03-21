module NavigationHelpers
  def path_to(page_name)
    case page_name
 
    when /the home\s?page/
      '/'
    when /the About Us\s?page/
      about_path
    when /the Contact Us\s?page/
      contact_path
    when /the Privacy\s?page/
      privacy_path

    when /the items\s?page/ 
      items_path
    when /details on vinyl green boards/
      item_path(@vinyl_green)
    when /details on basic pieces/
      item_path(@basic_pieces)
    when /edit basic pieces\s?page/
      edit_item_path(@basic_pieces) 
    when /the new item\s?page/
      new_item_path

    when /the purchases\s?page/ 
      purchases_path
    when /the new purchase\s?page/
      new_purchase_path

    when /the item prices\s?page/ 
      item_prices_path
    when /the new price page/
      new_item_price_path

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)