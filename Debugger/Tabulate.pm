# Tabulate.pm -- The Perl Autobild.  Automagically build your source files!
# Copyright (C) 2019  Matt Rienzo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Submit issues or pull requests at <https://github.com/casnix/autobild/>.

use strict;
use warnings;
use boolean ':all';

package Debugger::Tabulate;

#
# Global variables for external use

# Tabulate index.
{
  my $tabIndex = 1;
  use constant tabs => \$tabIndex;
}

#
#

#
# Public functions

# Tell() -- Counts how many tabs to write.
# Tabs are two spaces in width.
#-- Arguments: None.
#-- Returns: A string filled with two-space tabs, proportional to `tabs`.
sub Tell {
  return ('  ' x ${ (tabs) });
}

# Increment() -- Increments the number of tabs to tell.
# Tabs are two-spaces wide.
#-- Arguments: None.
#-- Returns: Nothing;
sub Increment {
  ${ (tabs) } += 1;
}

# Decrement() -- Decremets the number of tabs to tell.
# Tabs are two-spaces wide.
#-- Arguments: None.
#-- Returns: Nothing.
sub Decrement {
  ${ (tabs) } -= 1;
}

#
#

1;
