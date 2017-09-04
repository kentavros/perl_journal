package Utils::File;

use strict;
use warnings;
use Data::Dumper;


sub readFile

{

    my($fileName) = $_[1];
    my @data = ();

    open my $fh, "< $fileName";

    binmode($fh);
    while(<$fh>)
    {
        chomp($_);
        push @data, $_;
    }
    close $fh;
	
    return join("\n", @data) unless (wantarray);
    return @data;

}

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {}; $class;
}
1;
#created by user8