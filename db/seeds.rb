#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

# Roles
normalRole = Role.new
normalRole.code = 'USER1'
normalRole.label = 'User'
normalRole.description = 'User role'
normalRole.save!

adminRole = Role.new
adminRole.code = 'ADMIN1'
adminRole.label = 'Admin'
adminRole.description = 'Administrator role'
adminRole.save!

superAdminRole = Role.new
superAdminRole.code = 'SUPERADMIN1'
superAdminRole.label = 'SuperAdmin'
superAdminRole.description = 'Super administrator role'
superAdminRole.save!

# OAuth2 Mobile devices
oauthApplicationAndroid = Doorkeeper::Application.new
oauthApplicationAndroid.name = "CloudPasswordManagerMobileApplication"
oauthApplicationAndroid.uid = "17de6c0adb24b6283caff61578c48a52de605475201432370d4dcdbcdd75806d"
oauthApplicationAndroid.secret = "6a4ff15a78fd0beec2f4260870d8d9ce6c948c3efd58cd4c923a0d5d318a9115"
oauthApplicationAndroid.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
oauthApplicationAndroid.save!

# Users demo data for development
if Rails.env.development? or Rails.env.test?
  # Normal demo account
  user = User.create_base_user({ fullname: 'Demo Demo', email: 'demo@demo.com', role: normalRole, password: 'demodemo' })
  # Administrator account
  admin = User.create_base_user({ fullname: 'Admin Admin', email: 'admin@demo.com', role: adminRole, password: 'adminadmin' })
  # Super administrator account
  superAdmin = User.create_base_user({ fullname: 'Super Admin', email: 'superadmin@demo.com', role: superAdminRole, password: 'superadmin' })

  # Demo account - directory - Root
  directoryEntryRoot = user.root_directory
  # Admin account - directory - Root
  adminDirectoryEntryRoot = admin.root_directory

  # Directory - Root -> General
  directoryEntryRootGeneral = DirectoryEntry.new
  directoryEntryRootGeneral.label = 'General'
  directoryEntryRootGeneral.description = 'The general passwords directory.'
  directoryEntryRootGeneral.user = user
  directoryEntryRootGeneral.directory_entry = directoryEntryRoot
  directoryEntryRootGeneral.save!

  # Password - Root -> General -> Email
  passwordEntryRootGeneralEmail = PasswordEntry.new
  passwordEntryRootGeneralEmail.label = 'E-mail'
  passwordEntryRootGeneralEmail.description = 'My e-mail password'
  passwordEntryRootGeneralEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralEmail.password = '12345678'
  passwordEntryRootGeneralEmail.directory_entry = directoryEntryRootGeneral
  passwordEntryRootGeneralEmail.save!

  # Password - Root -> General -> Private website
  passwordEntryRootGeneralPrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralPrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralPrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralPrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralPrivateWebsite.account = 'username'
  passwordEntryRootGeneralPrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralPrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralPrivateWebsite.directory_entry = directoryEntryRootGeneral
  passwordEntryRootGeneralPrivateWebsite.save!

  # Directory - Root -> General -> General 1
  directoryEntryRootGeneralGeneralOne = DirectoryEntry.new
  directoryEntryRootGeneralGeneralOne.label = 'General1'
  directoryEntryRootGeneralGeneralOne.description = 'The general1 passwords directory.'
  directoryEntryRootGeneralGeneralOne.user = user
  directoryEntryRootGeneralGeneralOne.directory_entry = directoryEntryRootGeneral
  directoryEntryRootGeneralGeneralOne.save!

  # Password - Root -> General -> General 1 -> Email
  passwordEntryRootGeneralGeneralOneEmail = PasswordEntry.new
  passwordEntryRootGeneralGeneralOneEmail.label = 'E-mail'
  passwordEntryRootGeneralGeneralOneEmail.description = 'My e-mail password'
  passwordEntryRootGeneralGeneralOneEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralGeneralOneEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralOneEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralOneEmail.password = '12345678'
  passwordEntryRootGeneralGeneralOneEmail.directory_entry = directoryEntryRootGeneralGeneralOne
  passwordEntryRootGeneralGeneralOneEmail.save!

  # Password - Root -> General -> General 1 -> Private website
  passwordEntryRootGeneralGeneralOnePrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralGeneralOnePrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.account = 'username'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.directory_entry = directoryEntryRootGeneralGeneralOne
  passwordEntryRootGeneralGeneralOnePrivateWebsite.save!

  # Directory - Root -> General -> General 2
  directoryEntryRootGeneralGeneralTwo = DirectoryEntry.new
  directoryEntryRootGeneralGeneralTwo.label = 'General2'
  directoryEntryRootGeneralGeneralTwo.description = 'The general2 passwords directory.'
  directoryEntryRootGeneralGeneralTwo.user = user
  directoryEntryRootGeneralGeneralTwo.directory_entry = directoryEntryRootGeneral
  directoryEntryRootGeneralGeneralTwo.save!

  # Password - Root -> General -> General 2 -> Email
  passwordEntryRootGeneralGeneralOneEmail = PasswordEntry.new
  passwordEntryRootGeneralGeneralOneEmail.label = 'E-mail'
  passwordEntryRootGeneralGeneralOneEmail.description = 'My e-mail password'
  passwordEntryRootGeneralGeneralOneEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralGeneralOneEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralOneEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralOneEmail.password = '12345678'
  passwordEntryRootGeneralGeneralOneEmail.directory_entry = directoryEntryRootGeneralGeneralTwo
  passwordEntryRootGeneralGeneralOneEmail.save!

  # Password - Root -> General -> General 2 -> Private website
  passwordEntryRootGeneralGeneralOnePrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralGeneralOnePrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.account = 'username'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralGeneralOnePrivateWebsite.directory_entry = directoryEntryRootGeneralGeneralTwo
  passwordEntryRootGeneralGeneralOnePrivateWebsite.save!

  # Directory - Root -> General -> General 2 -> General 21
  directoryEntryRootGeneralGeneralTwoGeneralTwoOne = DirectoryEntry.new
  directoryEntryRootGeneralGeneralTwoGeneralTwoOne.label = 'General21'
  directoryEntryRootGeneralGeneralTwoGeneralTwoOne.description = 'The general21 passwords directory.'
  directoryEntryRootGeneralGeneralTwoGeneralTwoOne.user = user
  directoryEntryRootGeneralGeneralTwoGeneralTwoOne.directory_entry = directoryEntryRootGeneralGeneralTwo
  directoryEntryRootGeneralGeneralTwoGeneralTwoOne.save!

  # Password - Root -> General -> General 2 -> General 21 -> Email
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.label = 'E-mail'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.description = 'My e-mail password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.password = '12345678'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoOne
  passwordEntryRootGeneralGeneralTwoGeneralTwoOneEmail.save!

  # Password - Root -> General -> General 2 -> General 21 -> Private website
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.account = 'username'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoOne
  passwordEntryRootGeneralGeneralTwoGeneralTwoOnePrivateWebsite.save!

  # Directory - Root -> General -> General 2 -> General 22
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwo = DirectoryEntry.new
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwo.label = 'General22'
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwo.description = 'The general22 passwords directory.'
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwo.user = user
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwo.directory_entry = directoryEntryRootGeneralGeneralTwo
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwo.save!

  # Password - Root -> General -> General 2 -> General 22 -> Email
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.label = 'E-mail'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.description = 'My e-mail password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.password = '12345678'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwo
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoEmail.save!

  # Password - Root -> General -> General 2 -> General 22 -> Private website
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.account = 'username'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwo
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoPrivateWebsite.save!

  # Directory - Root -> General -> General 2 -> General 22 -> General 221
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne = DirectoryEntry.new
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne.label = 'General221'
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne.description = 'The general211 passwords directory.'
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne.user = user
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwo
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne.save!

  # Password - Root -> General -> General 2 -> General 22 -> General 221 -> Email
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.label = 'E-mail'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.description = 'My e-mail password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.password = '12345678'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOneEmail.save!

  # Password - Root -> General -> General 2 -> General 22 -> General 221 -> Private website
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.account = 'username'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOne
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoOnePrivateWebsite.save!

  # Directory - Root -> General 2 -> General 22 -> General 222
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo = DirectoryEntry.new
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo.label = 'General222'
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo.description = 'The general212 passwords directory.'
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo.user = user
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwo
  directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo.save!

  # Password - Root -> General -> General 2 -> General 22 -> General 222 -> Email
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.label = 'E-mail'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.description = 'My e-mail password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.url = 'https://myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.account = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.email = 'username@myemailbox.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.password = '12345678'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoEmail.save!

  # Password - Root -> General -> General 2 -> General 22 -> General 222 -> Private website
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite = PasswordEntry.new
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.label = 'Website portal'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.description = 'My website password'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.url = 'https://mypersonalwebsite.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.account = 'username'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.email = 'username@email.com'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.password = 'abcdefghtij'
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.directory_entry = directoryEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwo
  passwordEntryRootGeneralGeneralTwoGeneralTwoTwoGeneralTwoTwoTwoPrivateWebsite.save!

  # Directory - Others
  directoryEntryOthers = DirectoryEntry.new
  directoryEntryOthers.label = 'Others'
  directoryEntryOthers.description = 'The other passwords directory.'
  directoryEntryOthers.user = user
  directoryEntryOthers.directory_entry = directoryEntryRoot
  directoryEntryOthers.save!

  # Password - Others -> Web hosting
  passwordEntryWebHosting = PasswordEntry.new
  passwordEntryWebHosting.label = 'Web hosting'
  passwordEntryWebHosting.description = 'My web hosting password'
  passwordEntryWebHosting.url = 'https://mywebhosting.com'
  passwordEntryWebHosting.account = 'user@domain.com'
  passwordEntryWebHosting.email = 'user@domain.com'
  passwordEntryWebHosting.password = 'tvuiwqdojao'
  passwordEntryWebHosting.directory_entry = directoryEntryOthers
  passwordEntryWebHosting.save!

  # Password - Others -> Virtual private server
  passwordEntryVirtualPrivateServer = PasswordEntry.new
  passwordEntryVirtualPrivateServer.label = 'MyVPS SSH'
  passwordEntryVirtualPrivateServer.description = 'My VPS SSH password'
  passwordEntryVirtualPrivateServer.url = 'https://myvps.ltd'
  passwordEntryVirtualPrivateServer.account = 'user'
  passwordEntryVirtualPrivateServer.email = 'user@email.com'
  passwordEntryVirtualPrivateServer.password = 'somethinggreat'
  passwordEntryVirtualPrivateServer.directory_entry = directoryEntryOthers
  passwordEntryVirtualPrivateServer.save!
end
