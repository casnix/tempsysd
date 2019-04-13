use strict;
use warnings;

package Popsoof::Logger;

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

#
#

#
# Private functions implemented

#
#

#
# Public functions

# Logger new(void) -- Logger object constructor.
sub new {
  my $class = shift;

  my $self = { };

  return bless $self, $class;
}

# void LoggerRecord($) -- Log something in an object's record.
#-- Arguments: $record, a text string.
sub LoggerRecord {
  my $this = shift;

  push @{ $this->("loggingenginerecords") }, shift;
}

# string LoggerGetLog($) -- Gets a log at index.
#-- Arguments: $index, the log index.
#-- Returns: $log, the log at $index.
sub LoggerGetLog {
  my $this = shift;

  return $this->("loggingenginerecords")->[shift];
}

# int LoggerLogLength() -- Returns the log size in indices.
sub LoggerLogLength {
  my $this = shift;

  return scalar @{ $this->{"loggingenginerecords"} };
}

#
#

1;
