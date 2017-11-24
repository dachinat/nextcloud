RSpec.describe Nextcloud::Webdav::Directory do
  before(:each) do
    @subject = Nextcloud::WebdavApi.new(
      url: "https://cloud.testdomain.com",
      username: "testuser",
      password: "rn!rmEM1rm"
    ).directory
  end

  it ".find retrieves everything in /" do
    VCR.use_cassette("webdav_directory/find") do
      all = @subject.find
      expect(all.contents.count).to be > 0
    end
  end

  it ".find retrieves content of /dir1" do
    VCR.use_cassette("webdav_directory/find_in_dir") do
      in_dir = @subject.find("dir1/")
      expect(in_dir.contents.count).to be > 0
    end
  end

  it ".find retrieves a file" do
    VCR.use_cassette("webdav_directory/find_a_file") do
      file = @subject.find("base.txt")
      expect(file.id).not_to be(nil)
    end
  end

  it ".create creates a directory" do
    VCR.use_cassette("webdav_directory/create") do
      @subject.create("dir2")
      expect(@subject.find.contents.find { |c| c.href == "/remote.php/dav/files/testuser/dir2/" }).not_to be(nil)
    end
  end

  it ".destroy deletes a directory" do
    VCR.use_cassette("webdav_directory/destroy") do
      @subject.destroy("dir2")
      expect(@subject.find.contents.find { |c| c.href == "/remote.php/dav/files/testuser/dir2/" }).to be(nil)
    end
  end

  it ".move moves a directory" do
    VCR.use_cassette("webdav_directory/move_directory") do
      @subject.move("dir2/", "dir1/dir2/")
      expect(@subject.find("dir1/").contents.find { |c| c.href == "/remote.php/dav/files/testuser/dir1/dir2/" }).not_to be(nil)
    end
  end

  it ".move moves a file" do
    VCR.use_cassette("webdav_directory/move_file") do
      @subject.move("base.txt", "dir1/base.txt")
      expect(@subject.find("dir1/").contents.find { |c| c.href == "/remote.php/dav/files/testuser/dir1/base.txt" }).not_to be(nil)
    end
  end

  it ".copy copies a directory" do
    VCR.use_cassette("webdav_directory/copy_directory") do
      @subject.copy("dir1/dir2/", "dir2/")
      expect(@subject.find.contents.find { |c| c.href == "/remote.php/dav/files/testuser/dir2/" }).not_to be(nil)
    end
  end

  it ".copy copies a file" do
    VCR.use_cassette("webdav_directory/copy_file") do
      @subject.copy("dir1/base.txt", "base.txt")
      expect(@subject.find.contents.find { |c| c.href == "/remote.php/dav/files/testuser/base.txt" }).not_to be(nil)
    end
  end

  it ".download downloads a file" do
    VCR.use_cassette("webdav_directory/download") do
      expect(@subject.download("base.txt")).to match(/contents from/)
    end
  end

  it ".upload uploads a file" do
    VCR.use_cassette("webdav_directory/upload") do
      @subject.upload("upload.txt", "Uploaded file")
      expect(@subject.download("upload.txt")).to match("Uploaded file")
    end
  end

  it ".favorite makes a resource favorite" do
    VCR.use_cassette("webdav_directory/favorite") do
      expect(@subject.favorite("upload.txt")[:status]).not_to be(nil)
    end
  end

  it ".unfavorite unfavorites a resource" do
    VCR.use_cassette("webdav_directory/unfavorite") do
      expect(@subject.unfavorite("upload.txt")[:status]).not_to be(nil)
    end
  end

  it ".favorites return empty array if no favorites" do
    VCR.use_cassette("webdav_directory/favorites_empty") do
      expect(@subject.favorites).to eq([])
    end
  end

  it ".favorites lists favorites in base directory" do
    VCR.use_cassette("webdav_directory/favorites") do
      expect(@subject.favorites.count).to be(2)
    end
  end
end
