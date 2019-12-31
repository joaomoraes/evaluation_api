# README

## Prerequisite

This backend application uses ruby 2.6.4 and rails 5.2.3. Please install them before running the following commands. I would suggest installing RVM if you're new with ruby.

After that, please run: 

`rails db:create; rails db:migrate; rails db:seed`

After the DB is created and seeded, please run the following command to start the server

`rails s -p 3001`

This will instantiate the server on the port 3001



## Test

Please create a simple React SPA frontend application using the following endpoints from the rails application as data endpoints: `localhost:3001/users` and `localhost:3001/reports`. They should provide you with a JSON response regarding Users and Reports. The React SPA application should be a standalone application, running on a separate server 

The SPA should use some kind of css framework like bootstrap , but it doesn't need to be bootstrap. It needs to be one of the industry standards. It doesn't need to be pretty but it should be well structured and following best practices.

The SPA should show the user list , should be able to order by first name, role, email and when you click on the user should show a modal with a list of the reports for that specific user.

Please provide basic instalation instructions on the project README.