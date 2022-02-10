# Nextcloud Ruby API

## Fork info

Forked from https://github.com/Dwimcore/nextcloud

Merged system tag support from https://github.com/rahul100885/nextcloud

Added content_type param to `Api#requset` method, so that it can be used directly for APIs that require e.g. JSON request body.

## Purpose

Wrapper gem for Ruby used for communicating with Nextcloud OCS and WebDAV API endpoints.

This gem provides features for User provisioning, Group and App management, control of Shares and Federated Cloud
Shares, WebDAV functions for File / Folder creation, removal and other operations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "nextcloud"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nextcloud

## Usage

#### Initialize with endpoint bundles

To initialize an OCS client you can look at following example

```
ocs = Nextcloud.ocs(
  url: "https://cloud.yourdomain.com",
  username: "your_username",
  password: "your_password"
)
```

An URL has to be a base of your Nextcloud instance. For API requests, it will be parsed to
`https://cloud.yourdomain.com/ocs/v2.php/cloud/` or similar.

Once `ocs` is available you can use following methods to initiate specific classes:

`ocs.user`, `ocs.app`, `ocs.group`, `ocs.file_sharing`

If you intent to work with WebDAV api you can initialize a client with `webdav`:

```
webdav = Nextcloud.webdav(
  url: "https://cloud.yourdomain.com",
  username: "your_username",
  password: "your_password"
)
```

You can also initialize and work with both APIs (useful if credentials are same):

```
nextcloud = Nextcloud.new(
  url: "https://cloud.yourdomain.com",
  username: "your_username",
  password: "your_password"
)

ocs = nextcloud.ocs
webdav = nextcloud.webdav
```

#### Initialize specific APIs

Previously described method is recommended, however you can initialize in a different manner.

Initialize OCS Users API:

```
user = Nextcloud::Ocs::User.new(url: "…", username: "…", password: "…")
```

Initialize OCS Groups API:

```
group = Nextcloud::Ocs::Group.new(url: "…", username: "…", password: "…")
```

Initialize OCS Apps API:

```
app = Nextcloud::Ocs::App.new(url: "…", username: "…", password: "…")
```

Initialize OCS File Sharing API:

```
file_sharing = Nextcloud::Ocs::FileSharingApi.new(url: "…", username: "…", password: "…")
```

Initialize WebDAV Directory API:

```
directory = Nextcloud::Webdav::Directory.new(url: "…", username: "…", password: "…")
```

> When initializing this way, to work with certain objects some circumstances might force you use `set` method.
> For example if you wish to list members of group admin, using first way you could simply write
`ocs.group('admin').members`, in this case you will need to use `group.set('admin').members`. There is another way to
set object of intereset by putting it into initialize arguments, like so
`Nextcloud::Ocs::Group.new({…credentials}, groupid="admin")` it can be then reset with
`set`. Corresponding parameter names for other classes are `userid` and `appid`.

### *OCS Api usage*

These examples assume you have `Nextcloud.ocs` instance or relevant instance of
`Nextcloud::Ocs::{CLASS_NAME}.new` stored in `ocs` variable.

### User actions

#### Get list of users

```
users = ocs.user.all
# => [#<Nextcloud::Models::User:0x00000104d253c0 @id="your_user_1">, #<Nextcloud::Models::User:0x00000104d1f858 @id="your_user_2">]

last_user = user.last
=> #<Nextcloud::Models::User:0x000001042a2ba0 @id="your_user_2">

response_meta = users.meta
{"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Get a single user

```
user = ocs.user.find("your_user_1")
# => #<Nextcloud::Models::User:0x00000103964020 @enabled="true", @id="your_user_1", …, @meta={"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}>
```

Having `user` variable you have access to following attributes:

* enabled
* id
* quota
* email
* displayname
* phone
* address
* website
* twitter
* groups
* language
* meta


Again, here you can use `user.meta` to get service response status, code and message.

#### Create an user

```
meta = ocs.user.create("user3", "userPassword1!").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Update an user

You can update an user attributes with key-value method.

Valid keys include:

* quota
* displayname
* phone
* address
* website
* twitter
* password

```
meta = ocs.user.update("user3", "email", "new-address@some-domain.com").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Disable user

```
meta = ocs.user.disable("user3").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Enable user

```
meta = ocs.user.enable("user3").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Delete user

```
meta = ocs.user.destroy("user3").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Resend welcome email message

```
meta = ocs.user.resend_welcome("user3").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

### User group actions

#### Get user groups

```
groups = ocs.user("user1").groups
# => ["admin"]
meta = groups.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized User class

```
user.set("user1").groups
```

#### Add user to group

```
meta = ocs.user("user4").group.create("admin").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized User class

```
user.set("user4").group.create("admin")
```

#### Remove user from group

```
meta = ocs.user("user4").group.destroy("admin").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized User class

```
user.set("user4").group.destroy("admin")
```

#### Promote user to group subadmin

```
meta = ocs.user("user4").group("group1").promote.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized User class

```
user.set("user4").group("group1").promote
```

#### Demote user from group subadmin

```
meta = ocs.user("user4").group("group1").demote.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized User class

```
user.set("user4").group("group1").demote
```

#### Get user subadmin groups

```
subadmin_groups = ocs.user("user4").subadmin_groups
# => ["group1"]
meta = subadmin_groups.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized User class

```
user.set("user4").subadmin_groups
```

### Group actions

#### Get all groups

```
groups = ocs.group.all
# => ["admin", "group1", "group2"]
meta = groups.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Search for a group

```
groups = ocs.group.search("admin")
# => ["admin"]
meta = groups.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Create a new group

```
meta = ocs.group.create("group3").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Get group members

```
members = ocs.group("admin").members
# => ["user1", "user2"]
meta = members.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized Group class

```
group.set("admin").members
```

#### Get group subadmins

```
members = ocs.group("group1").subadmins
# => ["user1", "user2", "user3"]
meta = members.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized Group class

```
group.set("group1").subadmins
```

#### Delete a group

```
meta = ocs.group.destroy("group3").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

### App actions

#### Get enabled applications

```
enabled = ocs.app.enabled
# => […]
meta = enabled.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Get disabled applications

```
disabled = ocs.app.disabled
# => […]
meta = disabled.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Get application information

```
app = ocs.app.find("appname")
# => {…}
meta = app.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Enable application

```
meta = ocs.app("appname").enable.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized App class

```
app.set("appname").enable
```

#### Disable application

```
meta = ocs.app("appname").disable.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

if you work with initialized App class

```
app.set("appname").disable
```

### FileSharing API

#### Initialize with authentication information

First of all you need to initiate a class with authentication information of user

```
ocs_fs = Nextcloud::Ocs::FileSharingApi.new(
  url: "https://cloud.yourdomain.com",
  username: "your_username",
  password: "your_password"
)
```

An URL has to be a base of your Nextcloud instance. For Sharing API requests, it will be parsed to
`https://cloud.yourdomain.com/ocs/v2.php/apps/files_sharing/api/v1/`

> You can also initialize with `Nextcloud.ocs(…credentials).file_sharing`

#### Retrieve all shares of an (authenticated) user

```
all_shares = ocs_fs.all
# => [{…}, {…}]
meta = all_shares.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Retrieve a single share

```
share = ocs_fs.find(11)
# => {"id" => "22", "shareType" => "0", …}
meta = share.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Retrive shares from specific file or folder

Can be called with two optional parameters
* reshares - boolean - shows all shares for a given file
* subfiles - boolean - shows all shares for subfiles in a directory

```
# shares from file.txt
file_shares = ocs_fs.specific("file.txt")

# shares from /dir1
dir_shares = ocs_fs.specific("/dir1")

# not only the shares from the current user but all shares from the given file
reshares = ocs_fs.specific("file1.txt", true)

# all shares within a folder, given that path defines a folder
subfiles = ocs_fs.specific("/dir1", ture, true)

# Attached variables will also have .meta method with server response information
```

#### Create a share

First argument is a `path` (required) to a file or a folder

`shareType` (required) has to be an integer

* 0 = user
* 1 = group
* 3 = public link
* 6 = federated cloud share

`shareWith` is only reqired if `shareType` is `0` or `1`, defines user or group file will be shared with

`publicUpload` is boolean, allows public uploads in a directory (Visitors will be able to upload to public directory
shared with link)

`password` to protect shared links with

`permissions` has to be an integer (default: 31, for public shares: 1)

* 1 = read
* 2 = update
* 4 = create
* 8 = delete
* 16 = share
* 31 = all

```
# share file.txt with user user1
ocs_fs.create("file.txt", 0, "user1").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}

# share file1.txt with public link and assign password to it
ocs_fs.create("file1.txt", 3, nil, nil, "password1P/")
```

#### Delete a share

```
delete = ocs_fs.destroy("21").meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Update a share

For details about permissions see "Create a share" section

Expiration date should be in "YYYY-MM-DD" format

```
# makes a share read-only
ocs_fs.update_permissions(21, 1)

# updates password
ocs_fs.update_password(21, "newPassword!0")

# allows public uploads
ocs_fs.update_public_upload(21, true)

# change expiration date
ocs_fs.update_expire_date(21, "2017-11-22")

# These methods will also have .meta method with server response information
```

### Federated Cloud Shares

To create a federated cloud shares you can use `create` method on `FileSharingApi` (see previous section)

#### List accepted federated shares

```
accepted = ocs_fs.federated.accepted
# => [{…}, {…}]
meta = accepted.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### List pending federated shares

```
pending = ocs_fs.federated.pending
# => [{…}, {…}]
meta = pending.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Info about federated share (accepted)

```
federated_share = ocs_fs.federated.find(12)
# => {"id"=>"12", "remote"=>"https://…", …}s
meta = federated_share.meta
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Delete accepted federated share

```
meta = ocs_fs.federated.destroy(12)
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Accept federated share

```
meta = ocs_fs.federated.accept(13)
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

#### Decline federated share

```
meta = ocs_fs.federated.decline(13)
# => {"status"=>"ok", "statuscode"=>"200", "message"=>"OK"}
```

### *WebDAV Api usage*

In these examples `webdav` variable is assumed to be a valid instance of
`Nextcloud.webdav` or `Nextcloud::Webdav::{CLASS_NAME}.new`

### File/Directory Operations

#### Find files/directories in given path

```
directory = webdav.directory.find("dir1/")
```

Will return instance of `Directory` model with information about current directory, it's method `contents` will contain
array of results:

```
directory.contents
```

#### Query information about file

```
file = webdav.directory.find("some_file.txt")
```

#### Create a directory

```
webdav.directory.create("some_dir/new_dir")
```

#### Delete a directory

```
webdav.directory.destroy("some_dir")
```

#### Move a directory

```
webdav.directory.move("source_dir/", "destination_dir/")
```

#### Copy a directory

```
webdav.directory.copy("source_dir/", "destination_dir/)
```

#### Download a file

```
webdav.directory.download("some_file.txt")
```

#### Upload a file

```
webdav.directory.upload("some_dir/new_file.txt", "CONTENTS")
```

#### Make a file favorite

```
webdav.directory.favorite("some_file")
```

#### Unfavorite a file

```
webdav.directory.unfavorite("some_file")
```

#### Show favorite files in path

```
webdav.directory.favorites("/")
```

### Group Folder API

#### Initialize with authentication information

First of all you need to initiate a class with authentication information of user

```
gf = Nextcloud::Ocs::GroupFolder.new(
  url: "https://cloud.yourdomain.com",
  username: "your_username",
  password: "your_password"
)
```

#### List of folders

```
gf.folders
```

#### Find folder with id 16

```
gf.find(16)
```

#### Get ID of folder with name 'Intern

```
gf.get_folder_id('Intern')
```

#### Create folder with name 'Intern'

```
gf.create('Intern')
```

#### Destroy folder id 16

```
gf.destroy(16)
```

#### Give access to folder with id 16 for 'Intern'

```
gf.give_access(16, 'Intern')
```

#### Remove access to folder with id 16 for 'Intern'

```
gf.remove_access(16, 'Intern')
```

#### Set permissions for folder with id 16 and group 'Intern' to 31

```
gf.set_permissions(16, 'Intern', 31)
```

#### Set quota of folder with id 16 to 7 GB

```
gf.set_quota(16, 1024*1024*1024*7)
```

#### Rename folder with id 16 to 'Extern'

```
gf.rename_folder(16, 'Extern')
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
