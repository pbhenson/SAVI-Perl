#
# SAVI-Perl version 0.05
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

$VERSION = '0.05';

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
