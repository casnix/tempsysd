#!/usr/bin/perl

use strict;
use warnings;
use boolean ':all';
use Term::ANSIColor;

use Popsoof;
use Debugger;
use Tempsysdctl;

our @ISA = qw(Tempsysdctl);

#
# Entry point
{
	main($#ARGV, \@ARGV);
	exit(${ rSTATUS });
}
#
#

#
# Global var refs
{
	my $sversion = 'v0.0.0';
	my $sauthor = 'Matt Rienzo';
	use constant VERSION => $sversion;
	use constant AUTHOR => $sauthor;

	my $sddir = '/etc/tempsys/';
	use constant rDROOT => \$sddir;
	my $sctldir = '/ctl/tempsysdctl/';
	use constant rCTLROOT => \$sctldir;

	my $istatus = 0;
	use constant rSTATUS => \$istatus;

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

	InitSpool();
	ProcessArguments($iargc, $rargv);

	return $iargc;
}

# (string, string) ProcessArguments($,$) -- commandline argument processor
#-- Arguments: $iargc, the argument count
#              $rargv, a reference to the argument vector.
#-- Returns: @returnList, { the input source parts directory
#                           the output source path. }
sub ProcessArguments {
  my $iargc = shift;
  my $rargv = shift;

  # Weirdly works online but not in CLI grep...?
  my $xcmdSwitches = qr/-(license|help|version|stop|start|once|status|config|interactive|temps)/;

  # Iterate through arguments
  foreach my $iargumentIndex (0..$iargc){
    PrintLicenseNotice() if $rargv->[$iargumentIndex] eq "license";
    UsageDie() if $rargv->[$iargumentIndex] eq "help";
    PrintVersion() if $rargv->[$iargumentIndex] eq "version";
		StopService() if $rargv->[$iargumentIndex] eq "stop";
		StartService() if $rargv->[$iargumentIndex] eq "start";
		${ rMachCtl }->RunInternals('once') if $rargv->[$iargumentIndex] eq "once";
		PrintServiceStatus() if $rargv->[$iargumentIndex] eq "status";
		PrintConfiguration() if $rargv->[$iargumentIndex] eq "config";
		InteractiveShell() if $rargv->[$iargumentIndex] eq "interactive";

		${ rMachCtl }->RunInternals('print-temperatures',
		{'rargs' => $rargv->[$iargumentIndex + 1]}) if $rargv->[$iargumentIndex] eq "temps";

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
		"         config                   Print the file path to the configuration directory,\n".
		"  																	 and then configuration information.\n".
		"         interactive              Start a configuration shell (not working yet).\n".
		"					temps [".colored('raid', 'bold underline')."|all]				 Print system temperatures.\n"
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
	};
}

# void InitSpool(void) -- Spools up the machctl hash.
#-- Arguments: None.
#-- Returns: None.
sub InitSpool {
	${ rMachCtl }->RunInternals('machctl/device/LoadMap()', {'root' => rDROOT, 'ctl' => rCTLROOT});
	${ rMachCtl }->RunInternals('machctl/device/Poll()');
	${ rMachCtl }->RunInternals('machctl/device/CheckSetup()');
}

# hook StopService(void) -- Stops the running tempsysd service, if any.
#-- Arguments: None.
#-- Modifies: rSTATUS = PID_of_service, 0 for none, -(PID_of_service) for error stopping service,
#								or -1 for general error.
sub StopService {
	${ rMachCtl }->RunInternals('machctl/service/Stop()');
	${ rSTATUS } = ${ rMachCtl }->RunInternals('machctl/service/PID_of_service');
}

# hook StartService(void) -- Starts the tempsysd service.
#-- Arguments: None.
#-- Modifies: rSTATUS = PID_of_service, -1 for general error.
sub StartService {
	Daemonize();
	${ rMachCtl }->RunInternals('machctl/service/Start()');
	${ rSTATUS } = ${ rMachCtl }->RunInternals('machctl/service/PID_of_service');
}

# void PrintServiceStatus(void) -- Prints the status of the tempsysd service.
#-- Arguments: None.
#-- Returns: None.
sub PrintServiceStatus {
	${ rMachCtl }->RunInternals('machctl/service/Status()')->Print();
}

# void PrintConfiguration(void) -- Prints a couple things...read the help menu.
#-- Arguments: None.
#-- Returns: Nothing.
sub PrintConfiguration {
	print "Information from configuration file: ";
	print ${ rDROOT }."/service.conf\n";

	foreach my $iconfig (0..${ rDROOT }->CountLines()) {
		next if ${ (rDROOT, \$iconfig)->FirstChar() } eq '#';

		(rDROOT, \$iconfig)->StringifyLine()->Print();
	}
}

# hook InteractiveShell(void) -- Does nothing right now.
#-- Arguments: None.
#-- Modifies: rSTATUS = -1.
sub InteractiveShell {
	${ rSTATUS } = -1;
}
