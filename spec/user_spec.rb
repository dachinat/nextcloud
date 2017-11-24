RSpec.describe Nextcloud do
  it ".all retrieves all users" do
    VCR.use_cassette("user/all") do
      expect(@subject.user.all.count).to be > 0
    end
  end

  it ".find finds an user" do
    VCR.use_cassette("user/find") do
      expect(@subject.user.find("test1").enabled).to eq("true")
    end
  end

  it ".create creates an user" do
    VCR.use_cassette("user/create") do
      @subject.user.create("user1", "new_user_Password1")
      expect(@subject.user.find("user1").id).to eq("user1")
    end
  end

  it ".update updates an user" do
    VCR.use_cassette("user/update") do
      @subject.user.update("user1", "displayname", "User 1")
      expect(@subject.user.find("user1").displayname).to eq("User 1")
    end
  end

  it ".disable disables an user" do
    VCR.use_cassette("user/disable") do
      @subject.user.disable("user1")
      expect(@subject.user.find("user1").enabled).to eq("false")
    end
  end

  it ".enables enables an user" do
    VCR.use_cassette("user/enable") do
      @subject.user.enable("user1")
      expect(@subject.user.find("user1").enabled).to eq("true")
    end
  end

  it ".destroy deletes an user" do
    VCR.use_cassette("user/destroy") do
      @subject.user.destroy("user1")
      user1 = @subject.user.find("user1")
      expect(user1.id).to be_empty
      expect(user1.meta["statuscode"]).to eq("998")
    end
  end

  it ".groups lists user groups" do
    VCR.use_cassette("user/groups") do
      expect(@subject.user("test1").groups.count).to be > 0
    end
  end

  it ".group.create adds user to a group" do
    VCR.use_cassette("user/group.create") do
      @subject.user("test1").group.create("group3")
      expect(@subject.user("test1").groups).to include("group3")
    end
  end

  it ".group.destroy removes user from a group" do
    VCR.use_cassette("user/group.destroy") do
      @subject.user("test1").group.destroy("group3")
      expect(@subject.user("test1").groups).not_to include("group3")
    end
  end

  it ".group.promote makes an user subadmin of a group" do
    VCR.use_cassette("user/group.promote") do
      @subject.user("test1").group("group1").promote
      expect(@subject.user("test1").subadmin_groups).to include("group1")
    end
  end

  it ".subadmin_groups lists groups that user is subadmin of" do
    VCR.use_cassette("user/subadmin_groups") do
      expect(@subject.user("test1").subadmin_groups.count).to be > 0
    end
  end

  it ".group.demote removes user from group subadmins" do
    VCR.use_cassette("user/group.demote") do
      @subject.user("test1").group("group1").demote
      expect(@subject.user("test1").subadmin_groups).not_to include("group1")
    end
  end

  it ".resend_welcome sends a welcome e-mail to an user" do
    VCR.use_cassette("user/resend_welcome") do
      expect(@subject.user.resend_welcome("test2").meta["statuscode"]).to eq("101")
      @subject.user.update("test2", "email", "some_test_email@some-test-domain.com")
      expect(@subject.user.resend_welcome("test2").meta["statuscode"]).to eq("200")
    end
  end
end
