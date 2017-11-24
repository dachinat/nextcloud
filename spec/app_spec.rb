RSpec.describe Nextcloud do
  it ".enabled retrieves all enabled applications" do
    VCR.use_cassette("app/enabled") do
      expect(@subject.app.enabled).to include("files", "activity")
    end
  end

  it ".disabled retrieves all disabled applications" do
    VCR.use_cassette("app/disabled") do
      expect(@subject.app.disabled).to include("user_ldap", "user_external")
    end
  end

  it ".enable enables an application" do
    VCR.use_cassette("app/enable") do
      @subject.app("user_ldap").enable
      expect(@subject.app.enabled).to include("user_ldap")
      expect(@subject.app.disabled).not_to include("user_ldap")
    end
  end

  it ".disable disables an application" do
    VCR.use_cassette("app/disable") do
      @subject.app("user_ldap").disable
      expect(@subject.app.disabled).to include("user_ldap")
      expect(@subject.app.enabled).not_to include("user_ldap")
    end
  end

  it ".find gives an information about an application" do
    VCR.use_cassette("app/find") do
      expect(@subject.app.find("external")["id"]).to eq("external")
      expect(@subject.app.find("external")["name"]).to eq("External sites")
    end
  end
end
