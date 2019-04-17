use strict;
use warnings;
use boolean ':all';
use Popsoof;
use Tempsysdctl::RunInternals;

package Tempsysdctl;
our @ISA = qw(Tempsysdctl::RunInternals);

#
# Private variables
{
  # machctl file structure
  my %hmachctl = (
    devid => 'tempsysdctl'
    map => {
      line1 => 'PID_of_service',
      line2 => 'state_of_service',
      line3 => 'database',

    },

    data => {
      'PID_of_service' => 0,
      'state_of_service' => 'stopped',
      'database' => 'RunInternals/machctldb',

    },

    descriptor => 'machctl/device',
    Ctl => Tempsysdctl->new();
  );
  use constant rMachCtl => \%hmachctl;
}
#
#

#
# Tempsysdctl accessors

# Tempsysdctl constructor
sub new {
  my $class = shift;

  my $self = {
    'once' => sub {
      # Do our thing, but only once as a script instead of daemon.
    },
    'print-temperatures' => sub {
      # Print CPU temperature first

      # Check arguments for all v. raid, default raid.

      # If raid, check mdstat and try it.

      # Else if all, loop through /dev/sd* with smartmonctl and ignore the ones
      # that don't return a temperature (and so not SATA hard drives.).

    },
  };

  return bless $self, $class;
}

#
#
