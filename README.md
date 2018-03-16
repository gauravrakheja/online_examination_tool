- To get it up and running,
  install ruby 2.5.0 and bundler and run

```
	bundle install && rake db:create && rake db:migrate
```

- The application provides an Interface to manage the examination process anywhere, its made to be generic and is not attached to a specific process
in a college. 

- There are 3 kinds of users: students, teachers and admins.

- A student account can simply be created by signing up while a teacher account needs to be confirmed by an admin before they get access to all the features, it still lets you create the account and see all the students and their results.

- To create an admin user you need to create a student user and then find the same user in `rails console` and then change the role to the ADMIN_ROLE
constant. 

- students only see live exams which are of the same course and semester, while teachers and admins see all the exams. They also have the ability
to see all the attempts for an exam or correct an exam.

- For more info please refer to the code, I've tried keeping it simple and have created a class for each of the entities, most of the logic is encapsulated in the models. 

- Since this is a college project and they do not require me to write any tests for the application, I've skipped integration tests but I've also tried to avoid any code in the views whatsoever so that everything I call can be depended upon.