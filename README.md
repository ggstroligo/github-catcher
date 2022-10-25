## Prerequisites
Before you begin, ensure you have met the following requirements:
*  Ruby ~> 3.1
*  SQLite3

## Installing
To install, follow these steps:

```shell
git clone git@github.com:ggstroligo/improving-jaya-test.git
cd improving-jaya-test
bundle install
```
## Environment
To run locally you must set the env vars, to achieve this you must copy the `.env.example` file at the application's root directory


```
cd improving-jaya=test
cp .env.example .env
```

## Running locally

To put this project running functionally, you must follow the steps:

- Run the rails server with `rails s -p 3000`
- Expose the port you server is running (`:3000`) to the internet
-  - You can use ngrok to achieve this
- Configure a webhook at your github's repository
-  - Creating Webhooks : https://developer.github.com/webhooks/creating/