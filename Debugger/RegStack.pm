# RegStack.pm -- The Perl Autobild.  Automagically build your source files!
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

package Debugger::RegStack;

#
# Public functions

# RegStack new($,$) -- constructor for the RegStack class
#-- Arguments: $class, inherited RegStack class
#              $stub, first value on stack.
#-- Returns: Blessed reference to self.
sub new {
  my($class, $stub) = @_;

  my $self = {
    current => $stub,
    __stack => [ $stub ],
  };

  return bless $self, $class;
}

# scalar Pop(class) -- Pops a value off the top of the RegStack.
#-- Arguments: Class inheritance.
#-- Returns: A scalar value from the top of RegStack.
sub Pop {
  my $this = shift;

  return pop @{ $this->{__stack} };
}

# void Push($,$) -- Pushes a value onto the top of the RegStack.
#-- Arguments: this, class inheritance
#              $value, the value to push onto the RegStack.
#-- Returns: Nothing.
sub Push {
  my $this = shift;
  my $value = shift;

  push @{ $this->{__stack} }, $value;
}

# void Set($,$) -- Sets the current section.
#-- Arguments: this, the class inheritance
#              $section, the section to set to.
#-- Returns: Nothing.
sub Set {
  my $this = shift;
  my $section = shift;

  $this->{current} = $section;
}

# scalar Top(class) -- Get the top of the RegStack
# Grabs the value at the top of the RegStack without modifying the stack.
#-- Arguments: Class inheritance.
#-- Returns: $topOfStack, the value at the top of the RegStack.
sub Top {
  my $this = shift;

  my $stackLength = scalar( @{ $this->{__stack} } );
  return $this->{__stack}[$stackLength - 1];
}

# scalar Current(class) -- Gets the currently open RegStack value.
#-- Arguments: Class inheritance.
#-- Returns: The currently open RegStack value.
sub Current {
  my $this = shift;
  return $this->{current};
}


#
#

1;
