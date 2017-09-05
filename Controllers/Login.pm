package Controllers::Login;

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
	return $self->{'UModel'}->printHeads()."\n\n".$self->{'View'}->getHtml();
}

#main logic function
#
sub run
{
    my ($self) = shift;
    if($self->{'UModel'}->is_autorized())
	{
		$self->{'UModel'}->redirectToHome();
	}
	my %warning;
	my $req_meth = %ENV->{'REQUEST_METHOD'};

    if($req_meth eq 'POST')
    {
		my $postData = \%in;
		if ($self->{'UModel'}->checkLogForm($postData))
		{
			$self->{'UModel'}->logIn($postData);
			$self->{'UModel'}->redirectToHome();
		}
		else
		{
			%warning->{LANG_warning} = 'Invalid user or password';
		}
	}

	$self->{'View'}->read('templates/login/login.html');
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