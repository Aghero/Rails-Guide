### 1. Ruby on Rails
#### Description
Ruby on Rails (RoR) is a model-view-controller (MVC) server-side fullstack framework. It's main selling point was it is
the fastest to deliver value to market and in my humble opinion it succeeded at that.

RoR foundation has been built on 9 important pillars. I am not going to list all of them. However the most fruitful to
me are:
- Optimize for programmer happiness
- Convention over Configuration (CoC)
- No one paradigm

It embodies less is more premise with such an ease. Which means little code yields great results.

Source: https://rubyonrails.org/doctrine
#### Advantages
1. Quick to market, yields feature-rich product in little development time
2. Shallow learning curve to get into
3. Huge ecosystem of ready to use tools
#### Disadvantages
1. Performance, as with most interpreted languages their performance is not up to par with their pre-compiled counter
   parts
2. Obfuscation by abstraction can be disastrous at times (E.g. hard to find slow running queries)
3. Documentation for older version is lacking in many departments

---
### 2. Briefly about ActiveRecord
Active Record (AR) facilitates the creation and use of business objects whose data requires persistent storage to a
database. It is an implementation of the AR pattern which itself is a description of an Object Relational Mapping (ORM).

AR gives us several mechanisms, the most important being the ability to:

- Represent models and their data.
- Represent associations between these models.
- Represent inheritance hierarchies through related models.
- Validate models before they get persisted to the database.
- Perform database operations in an object-oriented fashion.

Source: https://guides.rubyonrails.org/active_record_basics.html

---
### 3. Quick to market, easy to develop... What does it mean?
Most of modern, widely adapted by the industry and developers have their initializers in order to bootstrap projects.
RoR went a step further, provided a scaffolding mechanism that can be invoked directly via console at any given time within lifecycle of a project.

Lets see what are the most basic capabilities of such feature
```shell
rails rails-demo
rake routes
```
Lets now generate model, views, controller and basic test suite with one command
```shell
script/generate scaffold user firstname:string lastname:string email:text age:integer
rake routes
```
Field types representing their appropriate type that will be later persisted within chosen database
```ruby
:primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp, :time, :date, :binary, :boolean
```
Creating development and test databases
```shell
rake db:create
rake db:create RAILS_ENV=test
```
Running migrations for both development and test database
```shell
rake db:migrate
rake db:migrate RAILS_ENV=test
```
Generating another set of required classes
```shell
script/generate scaffold question tittle:string description:text user:references
rake routes
```
---
### 3. Create, Read, Update, Delete (CRUD) Controllers made easy
Almost all web applications involve CRUD operations.
Rails acknowledges this, and provides many features to help simplify code doing CRUD.

```ruby
def index
   @users = User.all

   respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
      # format.json  { render :json => @users }
   end
end

# GET /users/1
def show
   @user = User.find_by_id(params[:id])
end

# GET /users/new
def new
   @user = User.new
end

# GET /users/1/edit
def edit
   @user = User.find_by_id(params[:id])
end

# POST /users
def create
   @user = User.new(params[:user])

   if @user.save
      redirect_to(@user, :notice => 'User was successfully created.')
   else
      render :action => "new"
   end
end

# PUT /users/1
def update
   @user = User.find(params[:id])

   if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'User was successfully updated.')
   else
      render :action => "edit"
   end
end

# DELETE /users/1
def destroy
   @user = User.find(params[:id])
   @user.destroy

   redirect_to(users_url)
end
```
Source: https://guides.rubyonrails.org/getting_started.html

---
#### 3.1. Routes

Rails provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as photos

In Rails, a resourceful route provides a mapping between HTTP verbs and URLs and controller actions. By convention, each
action also maps to particular CRUD operations in a database

A single entry in the routing file`config/routes.rb`, such as
```ruby
map.resources :photos
```
creates seven different routes in your application, all mapping to the Photos controller:
```shell
GET       /photos
GET       /photos/new
POST      /photos
GET       /photos/:id
GET       /photos/:id/edit
PATCH/PUT /photos/:id
DELETE    /photos/:id
```
Or if you wish/have to break convention for example if you do not want to expose all CRUD operations, simply do:
```ruby
# Results in creating a route HTTP GET request to path: hidden/photos/:id 
# handled by method view_hidden_photos method within hidden_photos controller 
map.connect 'hidden/photos/:id', :controller => 'hidden_photos', :action => :view_hidden_photos

# Results in creating a route for handling HTTP POST request to path hidden/photos/:id
# handled by method create_hidden_photos method within hidden_photos controller
map.connect 'hidden/photos/:id', :controller => 'hidden_photos', :action => :create_hidden_photo, conditions: {method: :post}
```
Source: https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources

---
#### 3.2. How do we access data from request?
Params of a request is a simple hash. Therefore we can access it by key in the exactly same way that we deal with hashes in Ruby
```ruby
params[:expected_param]
```
Same goes with headers
```ruby
headers[:expected_header]
```
As you might remember there won't be an exception thrown in case of missing key.
Ruby will return `nil` in these cases. Remember to check your **expected** values before handling them tho!

Wait! But what about body? What if data is sent as a form instead?
They are all treated as request parameters. Rails does mapping for us with the respect to nested objects.
```json
{
    "firstname": "Adrian",
    "lastname": "Adrianowski",
    "email": "email@emailen.com",
    "age": 23
}
```
Is equal to:
```ruby
{"firstname" => "Adrian", "lastname" => "Adrianowski", "email" => "email@emailen.com", "age" => 23}
```
However there is a tiny difference with behaviour of `ParamsHashWithIndifferentAccess` which is the Class holding our params.
As follows:
```ruby
params[:firstname]
"Adrian"

params["firstname"]
"Adrian"
```
whereas in normal hash:
```ruby
params[:firstname]
nil

params["firstname"]
"Adrian"
```
This is the behaviour the class name suggests

More on different `request` methods: https://guides.rubyonrails.org/action_controller_overview.html#the-request-object

---
### 3.3. Filters
Filters are methods that are run `before`, `after` or `around` a controller action.

Filters are inherited, so if you set a filter on `ApplicationController`, it will be run on every controller in your application.

`before` filters are registered via before_action. They may halt the request cycle. A common `before` filter is one which requires that a user is logged in for an action to be run.

Example from our application `UsersController`:
```ruby
before_filter :show, only: :find_user

def find_user
   render(:status => :unprocessable_entity, json: "Id not provided.") if params[:id].blank?

   @user = User.find_by_id(params[:id])

   render(:status => :unprocessable_entity, json: "User not found ") if @user.blank?

   @user
end
```
Source: https://guides.rubyonrails.org/action_controller_overview.html#filters

---
### 3.4. Persisting data
Here comes the part where AR ORM comes in handy.
Typically, in web applications, creating a new resource is a multi-step process.

First, the user requests a form to fill out. Then, the user submits the form.

If there are no errors, then the resource is created and some kind of confirmation is displayed.
Else, the form is redisplayed with error messages, and the process is repeated.

```ruby
# GET /users/new
def new
   @user = User.new
end

# POST /users
def create
   @user = User.new(params[:user])

   if @user.save
      redirect_to(@user, :notice => 'User was successfully created.')
   else
      render :action => "new"
   end
end
```
---
### 4. Exceptions
Most likely your application is going to contain bugs or otherwise throw an exception that needs to be handled.
For example, if the user follows a link to a resource that no longer exists in the database, AR will throw the `ActiveRecord::RecordNotFound` exception.

Rails default exception handling displays a `500 Server Error` message for all exceptions.

Example of `rescue` within method
```ruby
rescue ArgumentError => e
   Rails.logger.error("ArgumentError has occurred. Message: #{e.clean_message}, backtrace: #{e.clean_backtrace}")
   render(:status => :unprocessable_entity, json: "Try with better params! :D ")
   return
ensure
   Rails.logger.info("Show must go on")
end
```
If you want to do something a bit more elaborate when catching errors, you can use `rescue_from`, which handles exceptions of a certain type (or multiple types) in an entire controller and its subclasses.

Example of `rescue_from` on controller level.
```ruby
rescue_from SyntaxError, NoMethodError, ArgumentError do
   render "error_422", status: :unprocessable_entity
end
```
---
### 5. Simple View
Currently we have a method to show all users within our database. Rails conveniently also has generated a basic view for us:
```rhtml
<h1>Listing users</h1>

<table>
  <tr>
    <th>Firstname</th>
    <th>Lastname</th>
    <th>Email</th>
    <th>Age</th>
  </tr>

  <% @users.each do |user| %>
    <tr>
      <td><%= h user.firstname %></td>
      <td><%= h user.lastname %></td>
      <td><%= h user.email %></td>
      <td><%= h user.age %></td>
      <td><%= link_to 'Show', user %></td>
      <td><%= link_to 'Edit', edit_user_path(user) %></td>
      <td><%= link_to 'Destroy', user, :confirm => 'Are you sure?', :method => :delete %></td>
    </tr>
  <% end %>
</table>

<br/>

<%= link_to 'New user', new_user_path %>
```

---
