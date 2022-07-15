### 1. ActiveRecord In Rails
Active Record (AR) is the model in MVC. It facilitates the creation and use of business objects whose data requires persistent storage to a
database. It is an implementation of the AR pattern which itself is a description of an Object Relational Mapping (ORM).

AR gives us several mechanisms, the most important being the ability to:

- Represent models and their data.
- Represent associations between these models.
- Represent inheritance hierarchies through related models.
- Validate models before they get persisted to the database.
- Perform database operations in an object-oriented fashion.

Source: https://guides.rubyonrails.org/active_record_basics.html

---
### 2. Naming Conventions
By default, AR uses some naming conventions to find out how the mapping between models and database tables should be created. 
Rails will pluralize your class names to find the respective database table. 

So, for a class Book, you should have a database table called books. 

When using class names composed of two or more words, the model class name should follow the Ruby conventions, using the CamelCase form, while the table name must use the snake_case form. Examples:

Model Class - Singular with the first letter of each word capitalized (e.g., **BookClub**).
Database Table - Plural with underscores separating words (e.g., **book_clubs**).

| Model / Class | Table / Schema |
|---------------|----------------|
| Article       | articles       |
| LineItem      | line_items     |
|  Mouse        | mice           |
| Person        | people         |
Source: https://guides.rubyonrails.org/active_record_basics.html

---
### 3. Creating a model along with required files
We can leverage rails built in mechanisms to create models, migrations, tests and fixtures for us
```ruby
script/generate model new_model tittle:string description:text removed:boolean
```
Here are colum types that you can leverage: 
```ruby
:primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp, :time, :date, :binary, :boolean
```
You can do the same by hand, but why would you do that? Not recommended! :D

---
### 4. CRUD with model and only model itself
#### 4.1. Create
In Rails by default we have two ways to instantise our models `new` and `create`. 

The `new` method will return a new object.
```ruby
>> u=User.new(firstname: "Tester", lastname: "Test", age: 13)
=> #<User id: nil, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: nil, updated_at: nil>
  >> User.find_by_firstname("Tester")
=> nil
>> u.save
=> true
>> User.find_by_firstname("Tester")
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">
```
The `create` will return the object and save it to the database. (Provided data passed results in valid object)
```ruby
>> u1=User.create(firstname: "Paweł", lastname: "Pawłowski", age: 26)
=> #<User id: 4, firstname: "Paweł", lastname: "Pawłowski", email: nil, age: 26, created_at: "2022-07-14 23:51:34", updated_at: "2022-07-14 23:51:34">
>> User.find_by_firstname("Paweł")
=> #<User id: 4, firstname: "Paweł", lastname: "Pawłowski", email: nil, age: 26, created_at: "2022-07-14 23:51:34", updated_at: "2022-07-14 23:51:34">
```
Corresponding SQL statement done under the hood by the AR API
```mysql-sql
INSERT INTO "users" ("firstname", "lastname", "email", "age", "created_at", "updated_at") 
VALUES('Paweł', 'Pawłowski', NULL, 26, '2022-07-15 00:02:57', '2022-07-15 00:02:57')
```
#### 4.2. Read
AR provides rich API for itself. With many methods to retrieve object/s from the database.
I'll briefly describe few

`find` Retrieves the object/s corresponding to the specified primary key/s that matches any supplied options.
```ruby
>> User.find_by_id(3)
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">

>> User.find([3,4])
=> [#<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">, #<User id: 4, firstname: "Paweł", lastname: "Pawłowski", email: nil, age: 26, created_at: "2022-07-15 00:02:57", updated_at: "2022-07-15 00:02:57">]
  
>> User.find(-1)
ActiveRecord::RecordNotFound: Couldn't find User with ID=-1
```
Corresponding SQL statements done under the hood by the AR API
```mysql-sql
SELECT * FROM "users" WHERE ("users"."id" = 3)
SELECT * FROM "users" WHERE ("users"."id" IN (3,4))
SELECT * FROM "users" WHERE ("users"."id" = -1)
```
`all` Retrieves whole table
```ruby
>> User.all
=> [#<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">, #<User id: 4, firstname: "Paweł", lastname: "Pawłowski", email: nil, age: 26, created_at: "2022-07-15 00:02:57", updated_at: "2022-07-15 00:02:57">]
```
Corresponding SQL statements done under the hood by the AR API
```mysql-sql
SELECT * FROM "users"
```
`find_by` Finds the first record matching conditions 
```ruby
>> User.find_by_id(3)
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">

>> User.find_by_id(-3)
=> nil

>> User.find_by_age(13)
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">

>> User.find_by_firstname("Tester")
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">

>> User.find_by_firstname_and_lastname_and_age("Tester", "Test", 13)
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">

>> User.find(:all, conditions: ["firstname = ?", "Tester"])
=> [#<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">]

>> User.find(:all, conditions: {firstname: "Tester"})
=> [#<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">]

>> User.find(:first, conditions: {firstname: "Tester"})
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">
```
Corresponding SQL statements done under the hood by the AR API
```mysql-sql
SELECT * FROM "users" WHERE ("users"."id" = 3) LIMIT 1
SELECT * FROM "users" WHERE ("users"."id" = -3) LIMIT 1
SELECT * FROM "users" WHERE ("users"."age" = 13) LIMIT 1
SELECT * FROM "users" WHERE ("users"."firstname" = 'Tester') LIMIT 1
SELECT * FROM "users" WHERE ("users"."firstname" = 'Tester' AND "users"."lastname" = 'Test' AND "users"."age" = 13) LIMIT 1
SELECT * FROM "users" WHERE (firstname = 'Tester')
SELECT * FROM "users" WHERE ("users"."firstname" = 'Tester')
SELECT * FROM "users" WHERE ("users"."firstname" = 'Tester') LIMIT 1
```
Source: https://guides.rubyonrails.org/active_record_querying.html#retrieving-objects-from-the-database

---
#### 4.3. Update
Once an AR object has been retrieved, its attributes can be modified and it can be saved to the database.
```ruby
>> user=User.first
=> #<User id: 3, firstname: "Tester", lastname: "Test", email: nil, age: 13, created_at: "2022-07-14 23:54:33", updated_at: "2022-07-14 23:54:33">
>> user.firstname = "NewFirstname"
=> "NewFirstname"
>> user.save
=> true

>> user.update_attribute(:lastname, "NewLastname")

>> User.update_all(age: 33)
=> 2
```
Corresponding SQL statements done under the hood by the AR API
```mysql-sql
UPDATE "users" SET "firstname" = 'NewFirstname', "updated_at" = '2022-07-15 00:35:15' WHERE "id" = 3
UPDATE "users" SET "lastname" = 'NewLastname', "updated_at" = '2022-07-15 00:36:50' WHERE "id" = 3
UPDATE "users" SET "age" = 33
```
Source: https://guides.rubyonrails.org/active_record_basics.html#update
#### 4.4. Delete (Destroy)
Likewise, once retrieved an Active Record object can be destroyed which removes it from the database.
```ruby
>> u.destroy
=> #<User id: 1, firstname: "Programmer", lastname: "Newbie", email: nil, age: 42, created_at: "2022-07-15 00:45:03", updated_at: "2022-07-15 00:45:03">

>> User.destroy_all
=> [#<User id: 2, firstname: "Programmer", lastname: "Newbie", email: nil, age: 42, created_at: "2022-07-15 00:46:59", updated_at: "2022-07-15 00:46:59">]
```
Corresponding SQL statements done under the hood by the AR API
```mysql-sql
DELETE FROM "users" WHERE "id" = 1

SELECT * FROM "users"
DELETE FROM "users" WHERE "id" = 2
```
Source: https://guides.rubyonrails.org/active_record_basics.html#delete

---
### 5. Validations
Validations are used to ensure that only valid data is saved into your database. Model-level validations are the best way to achieve it.

Here is comparison of validating data at several levels along with their pros & cons:
* **Database** constraints and/or stored procedures 
  * Cons: testing and maintenance is a tad bit more difficult.
  * Pros: can safely handle some things (e.g. data uniqueness) which might be difficult to implement with such robust approach otherwise.
* **Client-side** 
  * Cons: generally unreliable if used alone. If they are implemented using JS, they may be bypassed if JS is turned off in the user's browser. 
  * Pros: can be a convenient way to provide users with immediate feedback as they use your site.
* **Controller-level** 
  * Cons: detailed validations can be tempting to use, but often become unwieldy and difficult to test and maintain. 
  * Pros: provide a quick feedback to the end user with the fail fast approach

Validations are typically run before `INSERT/UPDATE` statements are invoked. 
If any validations fail, the object will be marked as invalid and AR will not perform the `INSERT/UPDATE` operations.

They can be invoked by calling methods `valid?` and `invalid?` AR objects.
Lets take following User Active Record
```ruby
class User < ActiveRecord::Base
  validates_presence_of [:firstname, :lastname]
end
```
then by instantising empty user and calling these methods object we get:
```ruby
>> u=User.new
=> #<User id: nil, firstname: nil, lastname: nil, email: nil, age: nil, created_at: nil, updated_at: nil>
>> u.valid?
=> false
>> u.invalid?
=> true
>> u.errors.full_messages
=> ["Firstname can't be blank", "Lastname can't be blank"]
>> u.errors[:firstname]
=> "can't be blank"
```

#### 5.1 Validation Helpers
AR offers many pre-defined validation helpers that you can use directly inside your class definitions. 
Every time a validation fails, an error is added to the object's errors collection associated with the attribute being validated.

Lets add three more validations from the AR API to our `User`
```ruby
validates_length_of [:firstname, :lastname], within: 2..10
validates_uniqueness_of   :lastname, :if => :lastname?, :message => I18n.t("validations.lastname.taken")
validates_numericality_of :age, {only_integer: true, greater_than_or_equal_to: 0}
```
then by instantising empty user and calling these methods object we get:
```ruby
=> ["Firstname can't be blank", "Firstname is too short (minimum is 2 characters)", "Lastname can't be blank", "Lastname is too short (minimum is 2 characters)", "Age is not a number"]

# In case of not unique lastname:
=> ["Lastname Lastname is already taken!"]
```

#### 5.2 Custom validations
Lets say we need a fancy validation that is not provided with the Rails framework. No biggie.
We can create and add our own custom validations to AR.
Below I'll present two ways of achieving adding custom email validator
```ruby
validate :custom_email_validator
validates_format_of :email, :if => :email?, :with => /\A([_a-zA-Z0-9À-ž\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => I18n.t("validations.email.new_error")

private

def custom_email_validator
  return if email.blank?
  return if email.match(/\A([_a-zA-Z0-9À-ž\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)

  errors.add(I18n.t("validations.email.new_error"))
end
```
then by trying to create an `User` object with invalid email we get: 
```ruby
>> user=User.create(email: "not_real_email.com")
>> user.errors.full_messages
=> ["Welp, this is our new error in english is invalid", "Email Welp, this is our new error in english"]
```
Which one is better is up to you and your implementation in most cases. 
However I'd say in this case you should definitely go with the oneliner. The *RoR* way :D  

Source: https://guides.rubyonrails.org/active_record_validations.html

---
### 6. Callbacks
Callbacks are methods that get called at certain moments of an object's life cycle. 
With callbacks it is possible to write code that will run whenever an AR object is created, saved, updated, deleted, validated, or loaded from the database.

Basic list of before mentioned moments in object's lifecycle when callbacks can be set to trigger
* Creating an Object
  * before/after validation
  * before/after save
  * before/after create
  * after_commit / after_rollback
* Updating an Object
  * before/after validation
  * before/after save
  * before/after update
  * after_commit / after_rollback
* Destroying an Object
  * before/after destroy
  * after_commit / after_rollback

With that knowledge lets extend our `User` by a simple callback
```ruby
before_save :set_age_in_months, if: :age?

private

def set_age_in_months
  self.age_in_months = self.age * 12
end
```
Then after creation our user object will result in:
```ruby
>> u=User.create(firstname: "Testi", lastname: "Tester", age: 10)
=> #<User id: 3, firstname: "Testi", lastname: "Tester", email: nil, age: 10, age_in_months: 120, created_at: "2022-07-15 02:06:35", updated_at: "2022-07-15 02:06:35">
```
Source: https://guides.rubyonrails.org/active_record_callbacks.html

---

### 7. Associations (Relations)
In Rails, an association is a connection between two Active Record models. Why do we need associations between models? 
Because they make common operations simpler and easier. 

For example, consider a simple Rails application that includes a model for users and a model for questions. Each user can have many questions. 
Without associations, models and handling them would look somehow like this:
```ruby
class User < ActiveRecord::Base
end

class Question < ActiveRecord::Base
end

>> user=User.find_by_id(3)
=> #<User id: 3, firstname: "Testi", lastname: "Tester", email: nil, age: 10, age_in_months: 120, created_at: "2022-07-15 02:06:35", updated_at: "2022-07-15 02:06:35">
>> question=Question.create(user_id: user.id)
=> #<Question id: 1, tittle: nil, description: nil, user_id: 3, created_at: "2022-07-15 02:22:52", updated_at: "2022-07-15 02:22:52">
```
then what happens if we wanted to access our `user` questions?
```ruby
>> user.questions
NoMethodError: undefined method `questions' for #<User:0x00007fc4df3fadf8>
```
the other way around maybe?
```ruby
>> question.user
NoMethodError: undefined method `user' for #<Question:0x00007fc4df3e1060>
Did you mean?  user_id
```
Now lets try the same thing with associations:
```ruby
class User < ActiveRecord::Base

  has_many :questions
end

class Question < ActiveRecord::Base
  belongs_to :user
end

>> user.questions
=> [#<Question id: 1, tittle: nil, description: nil, user_id: 3, created_at: "2022-07-15 02:22:52", updated_at: "2022-07-15 02:22:52">]
>> question.user
=> #<User id: 3, firstname: "Testi", lastname: "Tester", email: nil, age: 10, age_in_months: 120, created_at: "2022-07-15 02:06:35", updated_at: "2022-07-15 02:06:35">
```
Convenient isn't it?

Source: https://guides.rubyonrails.org/association_basics.html