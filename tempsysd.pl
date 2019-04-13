#!/usr/bin/perl

use strict;
use warnings;
use boolean ':all';
use Proc::Daemon;

#
# Entry point
{
	my $istat = main($#ARGV, \@ARGV);
	exit($istat);
}
#
#

#
# Global var refs
{
	my $sversion = 'v0.1.0';
	my $sauthor = 'Matt Rienzo';
	use constant VERSION => $sversion;
	use constant AUTHOR => $sauthor;

	my $sddir = '/etc/tempsys/';
	use constant rDROOT => \$sddir;
	my $sctldir = '/ctl/tempsysd/';
	use constat rCTLROOT => \$sctldir;

	# Extry
	use constant nl => "\n";
}
#
#

#
# Public subs
sub main {
	my $iargc = shift;
	my $rargv = shift;

	return $iargc;
}
#
#

# (string, string) ProcessArguments($,$) -- commandline argument processor
#-- Arguments: $argc, the argument count
#              $argv, a reference to the argument vector.
#-- Returns: @returnList, { the input source parts directory
#                           the output source path. }
sub ProcessArguments {
  my $iargc = shift;
  my $rargv = shift;

  # Weirdly works online but not in CLI grep...?
  my $xcmdSwitches = qr/-(license|help|version|stop|start|once|status|config|configure)/;

  # Iterate through arguments
  my $bboolSkip = false;
  foreach my $iargumentIndex (0..$iargc){
    if($bboolSkip) {
      $bboolSkip = false;
      next;
    }

    PrintLicenseNotice() if $rargv->[$iargumentIndex] eq "license";
    UsageDie() if $rargv->[$iargumentIndex] eq "help";
    PrintVersion() if $rargv->[$iargumentIndex] eq "version";

    UsageDie() unless $rargv->[$iargumentIndex] =~ $xcmdSwitches;
  }

}

# void UsageDie(void) -- print the usage message and exit the program
#-- Arguments: none
#-- Returns: nothing, exits.
sub UsageDie {
  die ("Usage: tempsysd <long argument>\n".
    "Options: license                  Print license notice.\n".
    "         help                     Print usage message.\n".
    "         version                  Print version.\n".
		"         stop                     Try to stop the daemon.\n".
		"         start                    Start the daemon.\n".
		"         once                     Run as script instead of daemon (not recommended).\n".
		"         status                   Print service status.\n".
		"         config                   Print the file path to the configuration directory.\n".
		"         configure                Start a configuration shell (not working yet).\n".
    "Created by Matt Rienzo, 2019.\n");
}

# void PrintLicenseNotice(void) -- Prints the license notice.
#-- Arguments: None.
#-- Returns: Nothing.
sub PrintLicenseNotice {
  die ("tempsysd -- Written for home NAS by Matt Rienzo, 2019.  License uncertain.\n");
}

# void PrintVersion(void) -- Prints the version.
#-- Arguments: None.
#-- Returns: Nothing.
sub PrintVersion {
  die ("tempsysd\n".
  "Version: ".VERSION."\n".
  "Created 2019 Matt Rienzo\n");
}

# void Daemonize(void) -- Begins daemon spawn from hellforth unto Earth.
#-- Arguments: Rebellion in heaven.
#-- Returns: Idk.  Suffering probably.
sub Daemonize {
  use POSIX;
  POSIX::setsid or die "setsid: $!";
  my $pid = fork() // die $!; #//
  exit(0) if $pid;

  chdir "/";
  umask 0;
  for (0 .. (POSIX::sysconf (&POSIX::_SC_OPEN_MAX) || 1024))
    { POSIX::close $_ }
  open (STDIN, "</dev/null");
  open (STDOUT, ">/dev/null");
  open (STDERR, ">&STDOUT");

	$SIG{TERM} = sub {
		# exit sequence urgent
    exit(0);
	}
}
