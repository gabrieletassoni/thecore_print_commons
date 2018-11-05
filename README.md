# ThecorePrintCommons
This gem brings cups interaction into Thecore apps, allowing printing on all configured printers (be they local or remote), using cups' standardized interface.

## Usage
Add all the needed printers and be sure you can print on them.
to add printers to CUPS you can use http://localhost:631, but before it could be bettere to relax a bit 
the authentications needed for adding printers, to do so, please edit /etc/cups/cupsd.conf and replace all the Authentication directives with Authentication None.

When you enter the printers section and add a new printer in Thecore backend, you'll just see available (through cups) printers and you can just select one of these.

Otherwise, if you prefere to go the shell way, you can add it using lpadmin, say you'd like to install a samba printer:

First of all add current user to lpadmin group:

```shell
sudo apt install cups libcups2-dev
sudo adduser $(whoami) lpadmin
newgrp lpadmin
```

Then you can use lpadmin commands without sudo:

```shell
echo "Printer label:"; read PRINTERLABEL;
echo "Printer workgroup or Domain:";read WORKGROUP;
echo "Printer ip or netbios address:";read SHARE_IP_ADDRESS_OR_NETBIOS_NAME;
echo "Printer share name:";read SHARENAME;
echo "Printer share username:"; read USERNAME;
echo "Printer share password:"; read PASSWORD;
lpadmin -p "$PRINTERLABEL" -v "smb://${USERNAME}:${PASSWORD}@${WORKGROUP}/${SHARE_IP_ADDRESS_OR_NETBIOS_NAME}/${SHARENAME}" -m raw
```

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
