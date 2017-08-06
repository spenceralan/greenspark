# GreenSpark

This app will help you save the world! No really, it will!

Buying stock can be hard. But it doesn't need to be. That is why I built a webapp that will simplify the process so much, all you have to do is tell it how much you want to spend and it will tell you what to buy!

When you create an account for the first time your portfolio will be populated with green energy ETFs. An ETF is essentially a mutual fund that can be traded on a stock exchange.

Create your own account at http://www.greenspark.today and start investing in green energy today!

### Prerequisites

Web browser with ES6 compatibility
Examples: Chrome, Safari

Ruby 2.4.1
Bundler

### Installing

Installation is quick and easy! You can clone this repository to your machine and host it locally.

Once it is cloned, navigate to the root of the project and run:

```shell
bundle
```

When that finishes set up the database with the command:

```shell
bundle exec rake db:setup
```

When the database is successfully setup it is time to run the app!

```shell
bundle exec rails server
```

The default host path is http://localhost:3000

### .env file

The only required environmental variable is free from Alpha Vantages. 

Get your free key at the following website and place it in the .env file.

https://www.alphavantage.co/support/#api-key

```
ALPHA_VANTAGE="YOUR-KEY-HERE"
```

Not required for the app to run locally, but if you want to test email you will need to set up a free mailgun account and add the following variables to the .env file.

```
MG_ACTIVE_API="YOUR-KEY-HERE"
MG_EMAIL_VALIDATION="YOUR-KEY-HERE"
MG_DOMAIN="YOUR-DOMAIN-HERE"
```

## Built With

* Ruby
* Rails
* HTML
* CSS
* Bootstrap https://getbootstrap.com/
* ES6
* Jquery https://jquery.com/

## Authors

* Spencer Alan

## License

MIT License

Copyright (c) 2017 Spencer Alan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
