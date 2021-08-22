require "open-uri"

RSpec.describe Nextcloud::Ocs::FileSharingApi do
  before(:each) do
    @subject = described_class.new(url: "https://cloud.testdomain.com", username: "testuser", password: "rn!rmEM1rm")
  end

  it ".all retrieves all shares" do
    VCR.use_cassette("file_sharing_api/all") do
      expect(@subject.all.count).to be > 0
    end
  end

  it ".find retrieves a single share do" do
    VCR.use_cassette("file_sharing_api/find") do
      expect(@subject.find(45)["path"]).to eq "/file1.txt"
    end
  end

  it ".specific retrieves shares from a specific file" do
    VCR.use_cassette("file_sharing_api/specific-own") do
      expect(@subject.specific("/file1.txt").count).to eq(1)
    end
  end

  it ".specific retrieves all shares from a specific file" do
    VCR.use_cassette("file_sharing_api/specific-all") do
      expect(@subject.specific("/file1.txt", true).count).to eq(2)
    end
  end

  it ".specific retrieves shares for all files for a specific folder" do
    VCR.use_cassette("file_sharing_api/specific-folder") do
      expect(@subject.specific("/folder1", nil, true).count).to eq(2)
    end
  end

  it ".create shares a file" do
    VCR.use_cassette("file_sharing_api/create") do
      @subject.create("/some_file.txt", 0, "test1")
      expect(@subject.specific("/some_file.txt")[0]["share_with"]).to eq("test1")
    end
  end

  it ".create creates a public link" do
    VCR.use_cassette("file_sharing_api/create-protected-public-link") do
      result = @subject.create("/some_file2.txt", 3, nil, nil, "somePassword1_")
      expect(result.share_url).to eq("https://cloud.testdomain.com/s/ShXdLVSmHvDF3kS")
      url = @subject.specific("/some_file2.txt")[0]["url"]
      expect(open(url).read).to match("password-protected")
    end
  end

  it ".destroy unshares a file" do
    VCR.use_cassette("file_sharing_api/destroy") do
      id = @subject.specific("/some_file.txt")[0]["id"]
      @subject.destroy(id)
      expect(@subject.specific("/some_file.txt")).to be(nil)
    end
  end

  it ".update_permissions changes permissions" do
    VCR.use_cassette("file_sharing_api/update_permissions") do
      expect(@subject.find(67)["permissions"]).not_to eq("1")
      @subject.update_permissions(67, 1)
      expect(@subject.find(67)["permissions"]).to eq("1")
    end
  end

  it ".update_password changes password" do
    VCR.use_cassette("file_sharing_api/update_password") do
      expect(@subject.find(70)["share_with"]).to be(nil)
      @subject.update_password(70, "somePassword/1")
      expect(@subject.find(70)["share_with"]).not_to be(nil)
    end
  end

  it ".update_public_upload changes public upload policy" do
    VCR.use_cassette("file_sharing_api/update_public_upload") do
      expect(@subject.find(72)["permissions"]).to eq("1")
      @subject.update_public_upload(72, true)
      expect(@subject.find(72)["permissions"]).to eq("15")
    end
  end

  it ".update_expire_date changes expiration date" do
    VCR.use_cassette("file_sharing_api/update_expire_date") do
      expect(@subject.find(72)["expiration"]).to eq("2017-11-26 00:00:00")
      @subject.update_expire_date(72, "2017-11-22")
      expect(@subject.find(72)["expiration"]).to eq("2017-11-22 00:00:00")
    end
  end

  it ".federated.pending shows pending federated shares" do
    VCR.use_cassette("file_sharing_api/federated.pending") do
      expect(@subject.federated.pending.count).to be(2)
    end
  end

  it ".federated.accepted shows accepted federated shares" do
    VCR.use_cassette("file_sharing_api/federated.accepted") do
      expect(@subject.federated.accepted.count).to be(1)
    end
  end

  it ".federated.accept accepts a federated share" do
    VCR.use_cassette("file_sharing_api/federated.accept") do
      @subject.federated.accept(7)
      expect(@subject.federated.accepted.count).to be(2)
    end
  end

  it ".federated.decline declines a federated share" do
    VCR.use_cassette("file_sharing_api/federated.decline") do
      expect(@subject.federated.pending.count).to be(1)
      @subject.federated.decline(11)
      expect(@subject.federated.pending).to be(nil)
    end
  end

  it ".federated.find shows an information about accepted federated share" do
    VCR.use_cassette("file_sharing_api/federated.find") do
      expect(@subject.federated.find(8)["id"]).to eq("8")
    end
  end

  it ".federated.destroy destroys an accepted federated share" do
    VCR.use_cassette("file_sharing_api/federated.destroy") do
      expect(@subject.federated.accepted.count).to eq(2)
      expect(@subject.federated.destroy(13).meta["statuscode"]).to eq("200")
      expect(@subject.federated.accepted.count).to eq(1)
    end
  end
end
