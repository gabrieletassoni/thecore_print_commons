# ThecorePrintCommons
This gem brings cups interaction into Thecore apps, allowing printing on all configured printers (be they local or remote), using cups' standardized interface.

## Usage
Add all the needed printers and be sure you can print on them.
to add printers to CUPS you can use http://localhost:631, but before it could be bettere to relax a bit 
the authentications needed for adding printers, to do so, please edit /etc/cups/cupsd.conf and replace all the Authentication directives with Authentication None.

When you enter the printers section and add a new printer in Thecore backend, you'll just see available (through cups) printers and you can just select one of these.

## Installation
First of all, please install libcups2-dev:

```shell
sudo apt install libcups2-dev
```

Add this line to your application's Gemfile:

```ruby
gem 'thecore_print_commons'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install thecore_print_commons
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
