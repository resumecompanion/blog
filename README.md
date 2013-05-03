# ResumeCompanion Blog

This is a Blog engine provide by ResumeCompanion.

## Install

### 1. Add Blog To Gemfile

```ruby
if File.exists?("your-path/blog") && File.directory?("your-path/blog") && ENV['REMOTE_GEM'] != "true"
  gem 'blog', "0.0.2", :path => 'your-path/blog'
else
  gem 'blog', "0.0.2", :git => 'git@github.com:resumecompanion/blog.git'
end
```

This is an easier way for development. But, when you commit code in main application, **don't forget** to check if you still use the gem at local. **It's very important!**

### 2. Install The Gem

```ruby
# When you want install the gem by local
bundle install

# When you want install the gem by github
REMOTE_GEM=true bundle install
```

When you are developing, you can enter ```bundle install```, but, **before you commit the code in main appliaction**, please enter ```REMOTE_GEM=true bundle install```.

### 3. Generate Migration

```ruby
rails g blog:install # Generate default migration
rails g blog:add_meta_title # Generate meta title migration
rake db:migrate
```

### 4.Generate Seed Data

```ruby
rake blog:seed
```

This will generate some default settings and an admin account.

### 5. Mount Blog In ```routes.rb```

```ruby
mount Blog::Engine => '/blog', :at => 'blog'
```

You can change the path you want.

## Getting Start

### 1. Login

**http://localhost:3000/blog/users/login**

```
id => admin@resumecompanion.com
password => 123456
```

### 2. Setting

**http://localhost:3000/blog/admin/settings**

You can setup website name, index page, default meta title, default meta description, default meta keywords, and GA account here. **We don't provid create new key by user**.

### 3. User

**http://localhost:3000/blog/admin/users**

You can create new admin user here. Don't forget to set the admin attribute to be true.

### 4. Navigation

**http://localhost:3000/blog/admin/navigations**

You can setup navigation here. **Please be careful to setup the link and avoid infinity loop**.

### 5. Image

**http://localhost:3000/blog/admin/images**

You can upload, edit, and delete images here.

### 6. Post

**http://localhost:3000/blog/admin/posts**

You can create, edit, and delete pages here.

### 7. Sidebar

**http://localhost:3000/blog/admin/sidebars**

You can create, edit, and delete sidebar here.

### 8. Tag

**http://localhost:3000/blog/admin/tags**
You can create, edit, and delete tag here.

## Notice

### 1. Logout Method

The default logout method on devise is **"Delete"**, but, we use require_ssl in ResumeCompanion, it will modify the default method to **"Get"** (if redirection is happened). So, the logout will be broken when you install it to the new project.

