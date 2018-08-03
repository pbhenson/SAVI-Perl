#!/usr/local/bin/perl -w

use SAVI;
use strict;

my $savi = new SAVI();

ref $savi or print "Error initializing savi: " . SAVI->error_string($savi) . " ($savi)\n" and die;

my $mtime = (stat($ENV{SAV_IDE}))[9];
my $new_mtime;

while (1) {

    my $status;
    $status = $savi->load_data() and die "Failed to load virus data " . $savi->error_string($status) . " ($status)\n";

    my $version = $savi->version();

    ref $version or print "Error getting version: " . $savi->error_string($version) . " ($version)\n" and die;

    printf("Version %s (engine %d.%d) recognizing %d viruses\n", $version->string, $version->major,
	   $version->minor, $version->count);
    
    foreach ($version->ide_list) {
	printf("\tIDE %s released %s\n", $_->name, $_->date);
    }

    print "\n\nWaiting for update ($mtime)...\n\n";

    while (($new_mtime = (stat($ENV{SAV_IDE}))[9]) == $mtime) {
	sleep(600);
    }
    $mtime = $new_mtime;
}
