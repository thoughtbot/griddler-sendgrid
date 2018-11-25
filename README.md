Griddler::Sendgrid
==================

This is an adapter that allows [Griddler](https://github.com/thoughtbot/griddler) to be used with
[SendGrid's Parse API].

[SendGrid's Parse API]: https://sendgrid.com/docs/for-developers/parsing-email/setting-up-the-inbound-parse-webhook/

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'griddler-sendgrid'
```

Usage
-----

* SendGrid has done a [great
  tutorial](https://sendgrid.com/blog/receiving-email-in-your-rails-app-with-griddler/)
  on integrating Griddler with your application.
* And of course, view our own blog post on the subject over at [Giant
  Robots](http://robots.thoughtbot.com/handle-incoming-email-with-griddler).
* *Note:* Make sure to uncheck the "Spam Check" and "Send Raw" checkboxes on the [Parse Webhook settings page](http://sendgrid.com/developer/reply), otherwise the returned parsed email will have the body stripped out.

More Information
----------------

* [SendGrid](http://www.sendgrid.com)
* [SendGrid Parse API](https://sendgrid.com/docs/for-developers/parsing-email/setting-up-the-inbound-parse-webhook/)

Credits
-------

Griddler::Sendgrid was extracted from Griddler.

Griddler was written by Caleb Thompson and Joel Oliveira.

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

Griddler is Copyright © 2014 Caleb Thompson, Joel Oliveira and thoughtbot. It is
free software, and may be redistributed under the terms specified in the LICENSE
file.

Griddler::Sendgrid is Copyright © 2014 Caleb Thompson and thoughtbot. It is free
software, and may be redistributed under the terms specified in the LICENSE
file.
