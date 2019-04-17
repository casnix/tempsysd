use strict;
use warnings;
use boolean ':all';
use Term::ANSIColor;

use Popsoof;

package Tempsysdctl::RunInternals;

#
# Public functions

# RunInternals RunInternals($rhashRef, $sfunction, [, $rargs-{} ]) -- MachCtl RunInternals constructor
#-- Arguments: $rHashRef is the device hash map,
#              $sfunction is the ctl path to a function,
#              $rargs is an optional anonymous hash with arguments for functions.
#-- Returns: Depends on called functions.
sub RunInternals {
  my $rhashRef = shift;
  my $sfunction = shift;
  my $rargs = {};
  if($#_ > 0) $rargs = shift;

  # 1) Test if this is a MachCtl call or a device specific call:
  my @afunctionPath = split /\//, $sfunction;

  # If there are no slashes, then it's a device specific call.
  if($#afunctionPath == 0) {
    $rhashRef->Ctl->{$afunctionPath[0]}->($rargs);
  }

  # 2) Check if it's a machctl path.
  die("MachCtl error: ".colored($sfunction, 'bold')." is not a machctl path!\n") unless $afunctionPath[0] eq 'machctl';

  # 3) Service or device function?

  # 4) Run function with optional arguments.

  # 5) Return retval.
}
