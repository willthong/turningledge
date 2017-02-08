# turningledge

A script designed to work with [Ledger](https://ledger-cli.org) to give you a
turn-based budget. Inspired by Alex Recker's
[bennedetto](https://github.com/arecker/bennedetto), about which he wrote this
fascinating
[article](https://alexrecker.com/our-new-sid-meiers-civilization-inspired-budget.html).

Inspired by turn-based video games, turningledge takes your Ledger journal
and works out how much you make per day. It then deducts any regular outgoings
you may have declared (eg rent, bills, subscription services) to arrive at a
figure for how much money you get to spend per day while still breaking even or
saving, or alternatively how much money you need to save per day to break even
or achieve your saving targets.

## Setup

1. Check that your Ledger installation runs by default without needing to call
   any options. You can do this by making sure that options (in particular
   `--file` and `--date-format` if you've used a non-standard date format) are
   set in `~/.ledgerrc`.
2. Copy `.turningledgerc` into your home directory and replace the example
   settings with your own.

## Usage

Display the basic turningledge report: 

```bash
$ ./turningledge.sh
```

Show how turningledge got to its workings:

## Licence

Turningledge.sh is free software released under the [GNU General Public Licence v3](https://www.gnu.org/licenses/gpl-3.0.en.html).
