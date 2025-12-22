## Write for ease of human readability

* Use well named, small functions
* Use descriptive variables


## Flexible calling of script
* Be explicit about script language: start with `#!/usr/bin/env bash`
* use `set` with options so a script can be called by `bash filename`.
* use stderr and appropriate non-zero exits for error states, so that the script can be used in other scripts

## Treat it like real code
* Consider how it will be tested. That may be manual checks, but consider what the test path should be
* Run Shellcheck to lint it
* Follow language best practices

## When in doubt, reference the google bash style guides

https://google.github.io/styleguide/shellguide.html

## Be consistent
Look at other scripts in the repo, and try to be both consistent with them, and elevate the repo by modeling best BASH practices.
