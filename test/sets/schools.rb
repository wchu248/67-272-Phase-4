module Contexts
  module Schools
    # Context for schools (assumes no prior contexts)

    def create_schools
      @ingomar_elem = FactoryGirl.create(:school)
      @central_school1 = FactoryGirl.create(:school,
        name: "Central School",
        city: "Warren",
        zip: "07059")
      @warren_middle = FactoryGirl.create(:school,
        name: "Warren Middle School",
        city: "Warren",
        zip: "07059",
        min_grade: 6,
        max_grade: 8)
      @watchung_high = FactoryGirl.create(:school,
        name: "Watchung Hills Regional High School",
        active: false)
      @central_school3 = FactoryGirl.create(:school,
        name: "Central School",
        zip: "12345")
    end

    def destroy_schools
      @central_school1.delete
      @ingomar_elem.delete
      @warren_middle.delete
      @watchung_high.delete
    end

  end
end