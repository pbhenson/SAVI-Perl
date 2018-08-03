#!/usr/local/bin/perl -w

use SAVI;
use strict;

my $savi = new SAVI();

ref $savi or print "Error initializing savi: " . SAVI->error_string($savi) . " ($savi)\n" and die;

my $version = $savi->version();

ref $version or print "Error getting version: " . $savi->error_string($version) . " ($version)\n" and die;

printf("Version %s (engine %d.%d) recognizing %d viruses\n", $version->string, $version->major,
       $version->minor, $version->count);

foreach ($version->ide_list) {
    printf("\tIDE %s released %s\n", $_->name, $_->date);
}

set_options();

print "\n";

foreach (@ARGV) {
    print "Scanning $_ - ";
    
    my $results = $savi->scan($_);
    ref $results or print "error: " . $savi->error_string($results) . " ($results)\n" and next;
    
    print "clean\n" and next if ! $results->infected;

    print "infected by";
    
    foreach ($results->viruses) {
	print " $_";
    }
    print "\n";
}

sub set_options {

    my @options = qw(
        FullSweep DynamicDecompression FullMacroSweep OLE2Handling
        IgnoreTemplateBit VBA3Handling VBA5Handling OF95DecryptHandling
        HelpHandling DecompressVBA5 Emulation PEHandling ExcelFormulaHandling
        PowerPointMacroHandling PowerPointEmbeddedHandling ProjectHandling
        ZipDecompression ArjDecompression RarDecompression UueDecompression
        GZipDecompression TarDecompression CmzDecompression HqxDecompression
        MbinDecompression !LoopBackEnabled
        Lha SfxArchives MSCabinet TnefAttachmentHandling MSCompress
        !DeleteAllMacros Vbe !ExecFileDisinfection VisioFileHandling
        Mime ActiveMimeHandling !DelVBA5Project
        ScrapObjectHandling SrpStreamHandling Office2001Handling
        Upx Mac SafeMacDfHandling PalmPilotHandling HqxDecompression
        Pdf Rtf Html Elf WordB OutlookExpress
      );


    my $error = $savi->set('MaxRecursionDepth', 16, 1);
    defined($error) and print "Error setting MaxRecursionDepth: $error\n";

    foreach (@options) {
        my $value = ($_ =~ s/^!//) ? 0 : 1;

        $error = $savi->set($_, $value);
	defined($error) and print "Error setting $_: $error\n";
    }
}
