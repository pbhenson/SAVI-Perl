#
# SAVI-Perl version 0.10
#
# Paul Henson <henson@acm.org>
#
# Copyright (c) 2002 Paul Henson -- see COPYRIGHT file for details
#

package SAVI;

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT $AUTOLOAD);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

$VERSION = '0.10';

sub AUTOLOAD {
    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
        if ($! =~ /Invalid/) {
            $AutoLoader::AUTOLOAD = $AUTOLOAD;
            goto &AutoLoader::AUTOLOAD;
        }
        else {
                croak "Your vendor has not defined SAVI macro $constname";
        }
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap SAVI $VERSION;

my %error_strings = (
    0x200 => "DLL failed to initialize",
    0x201 => "Error while unloading",
    0x202 => "Virus scan failed",
    0x203 => "A virus was detected",
    0x204 => "Attempt to use virus engine without initializing it",
    0x205 => "The installed version of SAVI is running an incompatible version of the InterCheck client",
    0x206 => "The process does not have sufficient rights to disable the InterCheck client",
    0x207 => "The InterCheck client could not be disabled - the request to scan the file has been denied",
    0x208 => "The disinfection failed",
    0x209 => "Disinfection was attempted on an uninfected file",
    0x20A => "An attempted upgrade to the virus engine failed",
    0x20B => "Sophos Anti Virus has been removed from this machine",
    0x20C => "Attempt to get/set SAVI configuration with incorrect name",
    0x20D => "Attempt to get/set SAVI configuration with incorrect type",
    0x20E => "Could not configure SAVI",
    0x20F => "Not supported in this SAVI implementation",
    0x210 => "File couldn't be accessed",
    0x211 => "File was compressed, but no virus was found on the outer level",
    0x212 => "File was encrypted",
    0x213 => "Additional virus location is unavailable",
    0x214 => "Attempt to initialize when already initialized",
    0x215 => "Attempt to use a stub library",
    0x216 => "Buffer supplied was too small",
    0x217 => "Returned from a callback function to continue with the current file",
    0x218 => "Returned from a callback function to skip to the next file",
    0x219 => "Returned from a callback function to stop the current operation",
    0x21A => "Sweep could not proceed, the file was corrupted",
    0x21B => "An attempt to re-enter SAVI from a callback notification was detected",
    0x21C => "An error was encountered in the SAVI client's callback function",
    0x21D => "A call requesting several pieces of information did not return them all",
    0x21E => "The main body of virus data is out of date",
    0x21F => "No valid temporary directory found",
    0x220 => "The main body of virus data is missing",
    0x221 => "The InterCheck client is active, and could not be disabled",
    0x222 => "The virus data main body has an invalid version",
    0x223 => "SAVI must be reinitialised - the virus engine has a version higher than the running version of SAVI supports",
    0x224 => "Cannot set option value - the virus engine will not permit its value to be changed, as this option is immutable",
    0x225 => "The file passed for scanning represented part of a multi volume archive - the file cannot be scanned",
);

sub SAVI::error_string {
    my ($class, $code) = @_;

    defined ($error_strings{$code}) and return $error_strings{$code};

    return "Unknown error";
}

1;
__END__


=head1 NAME

SAVI - Perl module interface to Sophos Anti-Virus Engine

=head1 DESCRIPTION

=head1 Initialization

=over 4

=item $savi = new SAVI();

Creates a new instance of the virus scanning engine. Returns a reference
to an object of type SAVI on success or a numeric error code on failure.
    
=back

=head1 SAVI methods

=over 4

=item $version = $savi->version();

Returns a reference to an object of type SAVI::version on success,
a numeric error code in the case of failure of the underlying API call,
or undef upon failure to allocate memory.

=back

=over 4

=item $error = $savi->set(param, value, type = 0);

Sets the given parameter to the given value. The default type is
U32, calling with type not equal to 0 will use U16. Returns
undef on success and a numeric error code on failure.

=back

=over 4

=item $results = $savi->scan(path);

Initiates a scan on the given file. Returns a reference to an object of type
SAVI::results on success, or a numeric error code on failure.

=back

=over 4

=item $savi->error_string(code);

Returns an error message corresponding to the given code. Can also
be called as SAVI->error_string(code) if the failure resulted from
initializing the $savi object itself.

=back

=head1 SAVI::version methods

=over 4

=item $version->string

Returns the version number of the product.
    
=back
    
=over 4

=item $version->major

Returns the major portion of the version number of the virus engine.
    
=back
    
=over 4

=item $version->minor

Returns the minor portion of the version number of the virus engine.
    
=back
    
=over 4

=item $version->count

Returns the number of viruses recognized by the engine.
    
=back
    
=over 4

=item @ide_list = $version->ide_list

Returns a list of references to objects of type SAVI::ide, describing
what virus definition files are in use.
    
=back

=head1 SAVI::ide methods

=over 4

=item $ide->name

Returns the name of the virus definition file.
    
=back

=over 4

=item $ide->date

Returns the release date of the virus definition file.

=back

=head1 SAVI::results methods

=over 4

=item $results->infected

Returns true if the scan discovered a virus.

=back

=over 4

=item $results->viruses

Returns a list of the viruses discovered by the scan.
    
=back

=head1 AUTHOR

Paul Henson <henson@acm.org>

=head1 SEE ALSO

perl(1).

=cut
