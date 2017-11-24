RSpec.describe Nextcloud do
  it ".all retrieves all groups" do
    VCR.use_cassette("group/all") do
      expect(@subject.group.all.count).to be > 0
    end
  end

  it ".search finds a group" do
    VCR.use_cassette("group/search") do
      expect(@subject.group.search("2")).to include("group2")
    end
  end

  it ".create creates a group" do
    VCR.use_cassette("group/create") do
      @subject.group.create("group4")
      expect(@subject.group.all).to include("group4")
    end
  end

  it ".destroy destroys a group" do
    VCR.use_cassette("group/destroy") do
      @subject.group.destroy("group4")
      expect(@subject.group.all).not_to include("group4")
    end
  end

  it ".members lists members of a group" do
    VCR.use_cassette("group/members") do
      @subject.user("test2").group.create("group3")
      expect(@subject.group("group3").members).to include("test2")
    end
  end

  it ".subadmins lists members of a group" do
    VCR.use_cassette("group/subadmins") do
      @subject.user("test3").group("group3").promote
      expect(@subject.group("group3").subadmins).to include("test3")
    end
  end
end
