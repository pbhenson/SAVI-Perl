#!/usr/local/bin/perl

use SAVI;

my $savi = new SAVI();

ref $savi or print "Error initializing savi: $savi\n" and die;

my $version = $savi->version();

ref $version or print "Error getting version: $version\n" and die;

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
    ref $results or print "error: $results\n" and next;
    
    print "clean\n" and next if ! $results->infected;

    print "infected by";
    
    foreach ($results->viruses) {
	print " $_";
    }
    print "\n";
}

sub set_options {

    my %options = (FullSweep => 1,
		   DynamicDecompression => 1,
		   FullMacroSweep => 1,
		   OLE2Handling => 1,
		   IgnoreTemplateBit => 1,
		   VBA3Handling => 1,
		   VBA5Handling => 1,
		   OF95DecryptHandling => 0,
		   HelpHandling => 1,
		   DecompressVBA5 => 1,
		   Emulation => 1,
		   PEHandling => 1,
		   ExcelFormulaHandling => 1,
		   PowerPointMacroHandling => 1,
		   PowerPointEmbeddedHandling => 1,
		   ProjectHandling => 1,
		   ZipDecompression => 1,
		   ArjDecompression => 1,
		   RarDecompression => 1,
		   UueDecompression => 1,
		   GZipDecompression => 1,
		   TarDecompression => 1,
		   CmzDecompression => 1,
		   HqxDecompression => 1,
		   MbinDecompression => 1,
		   LoopBackEnabled => 0,
		   Lha => 1,
		   SfxArchives => 1,
		   MSCabinet => 1,
		   TnefAttachmentHandling => 1,
		   MSCompress => 1,
		   OF95DecryptHandling => 1,
		   DeleteAllMacros => 0,
		   Vbe => 0,
		   ExecFileDisinfection => 0,
		   VisioFileHandling => 1
		   );


    my $error = $savi->set('MaxRecursionDepth', 16, 1);
    defined($error) and print "Error setting MaxRecursionDepth: $error\n";

    foreach (keys %options) {
	$error = $savi->set($_, $options{$_});
	defined($error) and print "Error setting $_: $error\n";
    }
}
