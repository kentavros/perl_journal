package Controllers::Register;

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
    if($self->{'UModel'}->is_autorized())
	{
		$self->{'UModel'}->redirectToHome();
	}
	my %warning;
	my $req_meth = %ENV->{'REQUEST_METHOD'};

	if($req_meth eq 'POST')
	{
        my $postData = \%in;
		
		if ($self->{'UModel'}->checkRegForm($postData))
		{
            if(!$self->{'UModel'}->isEmailExists($postData->{'email'}))
            {
				if($self->{'UModel'}->addUser($postData))
                {
					%warning->{LANG_warning} = 'Thank You, follow to <a href="index.cgi?page=login">Login</a> page, please.';
				}
            }
			else
			{
				%warning->{LANG_warning} = 'Email is already exists';
			}
		}
		else
		{
			%warning->{LANG_warning} = 'Incorrect input';
		}
	}
    $self->{'View'}->read('templates/regpage/regist.html');
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