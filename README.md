# Behat Box #
A virtual box for running behat tests
## Introduction ##
This box provides a complete virtual machine to run behat tests independant to the host machine. The virtual box contains ALL necessary software:
- Ubuntu Trusty 14.04 x64
- PHP 5
- Firefox 47
- Google chrome 62
- Selenium Server 2.53.1
- Behat 3
- Behat examples
## How to run my behat tests ##
1. Install git, Virtual box and Vagrant on the host machine
2. Open a terminal or window command on the host machine. Clone this repository. This will create a directory 'behat-box'
```code
cd <your working directory>
git clone https://github.com/ngson2000/behat-box.git
cd behat-box
vagrant up
vagrant reload
```
(Note: you may need to run the last command if required)

3. Add your feature files for testing into the directory 'behat-box/feature'

4. Run the following command
```code
cd behat-box
vagrant ssh
./behat.sh <your test options> <your feature files>
```
## Supported browsers
The behat tests can run on Firefox or Google Chrome browsers. Just set the option 'browser_name' in your behat.yml to 'firefox' or chrome respectively.

## Maintainers ##

* [Son Nguyen](mailto:ngson2000@yahoo.com)

## Licence ##

* GPL 2.0
