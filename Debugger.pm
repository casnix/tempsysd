# Debugger.pm -- The Perl Autobild.  Automagically build your source files!
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

use GlobalEnvironment;
use Debugger::Tabulate;
use Debugger::RegStack;

package Debugger;

#
# Private functions

# void $SetRegStackCurrent(class) -- sets the regstack current object to the top of stack
#-- Arguments: Class inheritance.
#-- Returns: Nothing.
my $SetRegStackCurrent;
$SetRegStackCurrent = sub {
  my $this = shift;

  my $topOfRegStack = $this->{regstack}->Top();
  $this->{regstack}->Set($topOfRegStack);
};

#
#

#
# Public functions

# Debugger new($,$) -- Constructor for the Debugger class
# Creates a new Debugger instance
#-- Arguments: $class, the inherited class (`Debugger' in this case)
#              $section, the program section (commonly file) for this debugger.
#-- Returns: Blessed class object.
sub new {
  my $class = shift;

  my $self = {
    section => shift,
    regstack => Debugger::RegStack->new('Debugger'),
  };

  return bless $self, $class;

  # Mod: bless it and then define RegStack in $this->{regstack}?
}

# void Register($,$) -- update debugger in runtime
# Pushes a new section on the debugger's section stack, commonly for function
#   debugging.
#-- Arguments: $this, the inherited Debugger instance
#              $codeSection, the section name to push on stack.
#-- Returns: Nothing.
sub Register {
  my($this, $codeSection) = @_;

  $this->{regstack}->Push($codeSection);
}

# void OpenHere(class) -- opens the debug stream at the top of the stack
# Updates the RegStack with the top of the stack, and prints a debug message
#   about it if the debugger is enabled.
#-- Arguments: Class inheritance.
#-- Returns: Nothing.
sub OpenHere {
  my $this = shift;

  $this->$SetRegStackCurrent();

  $this->Note("{");
  Debugger::Tabulate::Increment();
}

# void Note($,$) -- prints a debugger notification
# Prints a debugger notification if the debugger is enabled.
#-- Arguments: this, the class inheritance
#              $notation, a text string to print out to console
#-- Returns: Nothing.
sub Note {
  my($this, $notation) = @_;

  if($GlobalEnvironment::DebuggerOn){
    print "[".$this->{regstack}->Current().".".$this->{section}."]".Debugger::Tabulate::Tell().$notation."\n";
  }
}

# void CloseHere(class) -- closes the currently opened debug stack.
# Updates the RegStack with the last debug stream, and prints a debugger
#   message about it if the debugger is enabled.
#-- Arguments: Class inheritance.
#-- Returns: Nothing.
sub CloseHere {
  my $this = shift;

  Debugger::Tabulate::Decrement();
  $this->Note("}");

  $this->{regstack}->Pop();
  $this->$SetRegStackCurrent();
}

#
#

1;
