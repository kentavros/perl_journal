package Controllers::Profile;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);
use CGI::Carp qw(fatalsToBrowser); 
use vars qw(%in);
$|=1;
ReadParse();

#returns rendered html with headers 
#
sub display
{
	my ($self) = shift;
	return $self->{'UModel'}->getHeader()."\n\n".$self->{'View'}->getHtml();
}

#main logic function
#
sub run
{
    my ($self) = shift;
    if(!$self->{'UModel'}->is_autorized())
    {
        $self->{'UModel'}->redirectToHome();
    }

    my $req_meth = %ENV->{'REQUEST_METHOD'};
    my %warning;
	
	my $sid = $self->{'UModel'}->getSessCookie();
	my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'}); 
	my $uId = $sess->param('uId');
    if($req_meth eq 'POST')
    {
        my $postData = \%in;
		if($postData->{'name'})
		{
			my $name = $postData->{'name'};
			if ($self->{'UModel'}->{'validator'}->valName($name))
			{
				$self->{'UModel'}->editName($name, $uId);
			}
		}
		if($postData->{'password'})
		{
			my $pass = $postData->{'password'};
			if ($self->{'UModel'}->{'validator'}->valPass($pass))
			{
				$self->{'UModel'}->editPass($pass, $uId);
			}
		}
	}
    $self->{'View'}->read('templates/profile/profile.html'); 
    $self->{'View'}->parse(\%warning);
}

#__construct
#recives an UserModel, ArticlesModel, View objects
sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;
#created by user9