package Models::User;

use strict;
use warnings;
use Data::Dumper;
use Digest::MD5 qw(md5 md5_hex md5_base64);
 
use File::Basename qw(dirname);
use lib dirname(__FILE__).'/../Utils/';
use Utils::CGI::Session;




#
#checks if the sessionID cookie exists,
#checks the uId in relevant session
#returns true if uId is not NULL
sub is_autorized
{
    my $self = shift;
    my $sid = $self->{'cgi'}->cookie("SID");
    if ($sid ne '')
    {
        my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
        if ($sess->param('uId') != 0)
        {
            return 1;
        }
        else{
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

#
#redirects to home page 
sub redirectToHome
{
	my $self = shift;
	print $self->{'cgi'}->redirect(-url => 'index.cgi');
}

#recieving an URL string
#and redirects to it
sub redirectTo
{
	my $self = shift;
	my $destination = shift;
	print $self->{'cgi'}->redirect(-url => $destination);
}

#LogOuting User
#
#
sub logOut
{
    my $self = shift;
    #my $sid = $self->{'cgi'}->cookie("SID");
	my $sid = $self->getSessCookie();
    my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
    $sess->param('uId'=>0);
    $sess->param('name'=>'Guest');
    $sess->flush();
}

#returns CGI sessIdCookie
#
sub getSessCookie
{
	my $self = shift;
	return $self->{'cgi'}->cookie("SID");
}

#gets user name, id from db
#sets it to the session parametres
#
sub logIn
{
    my $self = shift;
    my $postData = shift;
    my $query = 'SELECT id, name FROM users WHERE email=\''.$postData->{'email'}.'\'';
    if ($self->{'Db'}->select($query))
    {
        my $data = $self->{'Db'}->select($query);
        my $uId = $data->[0]->{'id'};
        my $uName = $data->[0]->{'name'};		
        #my $sid = $self->{'cgi'}->cookie("SID");
		my $sid = $self->getSessCookie();
        my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
        $sess->param('name' => $uName);
        $sess->param('uId' => $uId);
	}
}

#recieving link to POST data hash
#makes md5 hashing on password input
#adds user to db
#perhaps should be a several functions for this action
sub addUser
{
    my $self = shift;
    my $data = shift;
    my $name = $data->{'name'};
    my $email = $data->{'email'};
    my $pass = md5_hex($data->{'password'});
    my $query = 'INSERT INTO users (name, email, pass) VALUES (\''.$name.'\', \''.$email.'\', \''.$pass.'\')';
    if ($self->{'Db'}->insert($query) == 1)
    {
        return 1;
    }
    return 0;
}

#recieving link to POST data hash
#checks input with validator methods
#
sub checkUserEditForm
{
    my $self = shift;
    my $data = shift;
    if ($self->{'validator'}->valName($data->{'name'}) && $self->{'validator'}->valPass($data->{'password'}))
    {
        return 1;
    }
    return 0;

}

#
#recieving input Name, User Id
#updates user name in db
sub editName
{
	my $self=shift;
    my $name=shift;
	my $uId = shift;
    my $query = 'UPDATE users SET name=\''.$name.'\' WHERE id=\''.$uId.'\'';
    if ($self->{'Db'}->update($query))
    {
        return 1;
    }
	return 0;
}

#
#recieving input password, User Id
#updates user password in db
sub editPass
{
	my $self=shift;
	my $pass =shift;
	my $uId = shift;
	my $pass = md5_hex($pass);
    my $query = 'UPDATE users SET  pass=\''.$pass.'\' WHERE id=\''.$uId.'\'';
    if ($self->{'Db'}->update($query))
    {
        return 1;
    }
	return 0;
}

#
#recieving an email input field
#check in db if this email already exists
#
sub isEmailExists
{
    my ($self, $email) = @_;
    my $query = 'SELECT email FROM users WHERE email=\''.$email.'\'';
    my $resEmail = $self->{'Db'}->select($query);
    if ($resEmail->[0]->{'email'} ne '')
    {

        return 1;
    }
    else
    {
        return 0;
    }
}


#
#recieving input post data
#check fields with validator methods
sub checkRegForm($)
{
    my $self = shift;
    my $data = shift;
    if ($self->{'validator'}->valName($data->{'name'}) && $self->{'validator'}->valEmail($data->{'email'}) && $self->{'validator'}->valPass($data->{'password'}))
    {
        return 1;
    }
    return 0;
}

#
#recieving post data
#checks email in db, if exists checks password to accept
#check fields with validator methods
sub checkLogForm
{
    my $self = shift;
    my $data = shift;
    my $email = $data->{'email'};
    my $pass = md5_hex($data->{'password'});
    my $query = 'SELECT email, pass FROM users WHERE email=\''.$email.'\'';
    my $res = $self->{'Db'}->select($query);
    if ($email eq $res->[0]->{'email'} && $pass eq $res->[0]->{'pass'})
    {
        return 1;
    }
    else
    {
        return 0;
    }

}


#returns headers from CGI object
# sub getHeader
sub printHeads
{
	my $self = shift;
	my $cookie = $self->{'cgi'}->cookie(SID => $self->{'cgi'}->{'sid'});
	return $self->{'cgi'}->header(-type=> 'text/html', -charset=>'utf-8', -cookie=>$cookie);
}

#__construct
#
#
sub new
{
    my $class = ref($_[0])||$_[0];

    my $cgi = CGI->new;
    my $sid = $cgi->cookie("SID");
	my $cookie;

    if ($sid ne '')
    {
        my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
		$cgi->{'sid'} = $sess->id;
    }
    else
    {
        my $sess = CGI::Session->new("driver:file", undef, {Directory=>'tmp'})
            or die CGI::Session->errstr();
        $sess->name('SID');
		$cgi->{'sid'} = $sess->id;
    }

    return bless {'Db'=> $_[1],'validator'=> $_[2], 'cgi'=> $cgi}; $class;
}
1;
#created by user6
