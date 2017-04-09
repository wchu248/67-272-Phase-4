module Contexts
  module Users
    # Context for users (assumes no prior contexts)

    def create_users
      @winston_chu = FactoryGirl.create(:user)
      @allie_caron = FactoryGirl.create(:user,
        first_name: "Allie",
        last_name: "Caron",
        username: "acaron",
        email: "allie_c@gmail.com",
        role: "customer")
      @jack_lance = FactoryGirl.create(:user,
        first_name: "Jack",
        last_name: "Lance",
        username: "jhlance",
        email: "jack_l@gmail.com",
        role: "manager")
      @sean_anderson = FactoryGirl.create(:user,
        first_name: "Sean",
        last_name: "Anderson",
        username: "seanande1",
        email: "sean_a@gmail.com",
        role: "shipper",
        phone: nil)
      @inactive_user = FactoryGirl.create(:user,
        first_name: "Inactive",
        last_name: "User",
        username: "inact_use",
        email: "inactive_user@gmail.com",
        phone: "(123) 456-7890",
        active: false)
    end

    def destroy_users
      @inactive_user.delete
      @sean_anderson.delete
      @jack_lance.delete
      @allie_caron.delete
      @winston_chu.delete
    end

  end
end