package Utils::Db;

use DBI;
use strict;
use warnings;
use Data::Dumper;

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {}, $class;
}

sub connectDb
{
    my $dsn ="DBI:mysql:user6";
    my $user = "user6";
    my $pass = "tuser6";
    my $dbh = DBI->connect($dsn, $user, $pass)
        or die "Error connecting to DB!";
    return $dbh;
}

sub select
{
    my($self, $query)=@_;
    my $sth = $self->connectDb()->prepare($query);
    $sth->execute();
    my @res=();
    if(!$sth->err) {

        while (my $row = $sth->fetchrow_hashref()) {
            push(@res, $row);
        }
    }
    else {
        return $sth->errstr;
    }
    $sth->finish();
    $self->connectDb()->disconnect();
    return \@res;
}

sub update
{
    my ($self, $query)=@_;
    my $sth = $self->connectDb()->prepare($query);
    $sth->execute();
    if (!$sth->err)
    {
        return 1;
    }
    else {
        return $sth->errstr;
    }
    $sth->finish();
    $self->connectDb()->disconnect();
}

sub insert
{
    my($self, $query)=@_;
    my $sth=$self->connectDb()->prepare($query);
    $sth->execute();
    if (!$sth->err)
    {
        return 1;
    }
    else {
        print $sth->errstr;
    }
    $sth->finish();
    $self->connectDb()->disconnect();
}

sub delete
{
    my($self, $query)=@_;
    my $sth=$self->connectDb()->prepare($query);
    $sth->execute();
    if (!$sth->err)
    {
        return 1;
    }
    else {
        return $sth->errstr;
    }
    $sth->finish();
    $self->connectDb()->disconnect();
}
1;
#created by user6