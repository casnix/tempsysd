use strict;
use warnings;
use boolean ':all';

use Popsoof;
use Popsoof::Logger;

package Popsoof::String;
our @ISA = qw(Popsoof, Popsoof::Logger);

#
# Private variables

#
#

#
# Public variables

#
#

#
# Private functions declared
my $VALUE;
#
#

#
# Private functions implemented

# string $VALUE(...) -- Accessor for String's value.
$VALUE = sub { &{ $_[0] }("VALUE", @_[1 .. $#_ ] ) };
#
#

#
# Public functions

# String new($) -- Popsoof object constructor.
#-- Arguments: $value, the text value of the string.
#-- Returns: a String object.
sub new {
  my $class = shift;
  my $value = shift;

  my $self = Popsoof->new();

  my $closure = sub {
    my $field = shift;
    @_ and $self->{$field} = shift;
    $self->{$field};
  };
  bless $closure, $class;

  $closure->LoggerRecord("Created as a String class.");

  if(ref $value ne "SCALAR"){
    $closure->LoggerRecord("Error on creation: passed value is not scalar!");
    return $closure;
  }

  $closure->$VALUE($value);
  return $closure;
}

# string Value(void) -- Retuns the value of the string.
#-- Returns: $value, the string's value.
sub Value {
  my $this = shift;

  return $this->$VALUE;
}

# string Set($) -- Set's the string's value.
#-- Arguments: $string, the string's value.
sub Set {
  my $this = shift;

  $this->$VALUE(shift);
}

# Mod: Make a Popsoof::RegEx object.

# string Filter($) -- Filter the String object with a RegEx.
#-- Arguments: $regex, the regular expression.
#-- Returns: $result, the result of the regular expression, or empty.
sub Filter {
  my $this = shift;
  my $regex = shift;

  $this->$VALUE =~ $regex;
  my $result = $&;

  return $result;
}

# string Before($) -- Get the string before a RegEx match.
#-- Arguments: $regex, the regular expression.
#-- Returns: $result, the string before the regular expression's match, or empty.
sub Before {
  my $this = shift;
  my $regex = shift;

  $this->$VALUE =~ $regex;
  my $result = $`;

  return $result;
}

# string After($) -- Get the string after a RegEx match.
#-- Arguments: $regex, the regular expression.
#-- Returns: $result, the string after the regular expression's match, or empty.
sub After {
  my $this = shift;
  my $regex = shift;

  $this->$VALUE =~ $regex;
  my $result = $';

  return $result;
}

# int WhereIs($) -- Index from left side of string to beginning of RegEx match.
#-- Arguments: $regex, the regular expression.
#-- Returns: $index, the index.
sub WhereIs {
  my $this = shift;
  my $regex = shift;

  $this->$VALUE =~ $regex;

  my $index = length $`;
  return $index;
}

#
#

1;
