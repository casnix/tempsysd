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
  );
  use constant rMachCtl => \%hmachctl;
}
