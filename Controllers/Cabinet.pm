package Controllers::Cabinet;

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
			# my $sid = $self->{'UModel'}->{'cgi'}->cookie("SID");
			my $sid = $self->{'UModel'}->getSessCookie();
			my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'}); 
			my $uId = $sess->param('uId');
			my $templateName = 'templates/cabinet/cabinet.html';
			$self->{'View'}->read($templateName);
			my $req_meth = %ENV->{'REQUEST_METHOD'};
			
			if(%in->{'action'} eq 'add')
			{
				my %addArticle->{ADD_article} = $self->{'View'}->makeFormAddArticle();
				$self->{'View'}->parseAddArticleForm(\%addArticle);
			}
			if (%in->{'action'} eq 'delete' && (%in->{'id'} != undef))
			{
				$self->{'AModel'}->deleteArticle(%in->{'id'});
				%in = undef;
				$self->{'UModel'}->redirectTo('index.cgi?page=cabinet');
				# print $self->{'UModel'}->{'cgi'}->redirect(-url => 'index.cgi?page=cabinet');
			}
			if($req_meth eq 'POST')
			{
				if(%in->{'action'} eq 'add')
				{
					my $postData = \%in;

					$self->{'AModel'}->addArticle($postData, $uId);
					%in = undef;
					$self->{'UModel'}->redirectTo('index.cgi?page=cabinet');
					# print $self->{'UModel'}->{'cgi'}->redirect(-url => 'index.cgi?page=cabinet');
				}
                my $postData = \%in; 
				$self->{'AModel'}->editArticle($postData);
				$self->{'View'}->parseFormArticle({FORM_EditArticle => ''});
			}
			my %addArticle;
			$self->{'View'}->parseAddArticleForm(\%addArticle);
			
			my $id = %in->{'id'};
			if($id eq undef)
			{
				$self->{'View'}->parseFormArticle({FORM_EditArticle => ''});
			}
			else
			{
				my $formValues = $self->{'AModel'}->getArticleById($id);
				my @formValues = @$formValues;
				my %hash;
				foreach my $val(@formValues)
				{
					%hash->{LANG_title} = $val->{'title'};
					%hash->{LANG_body} = $val->{'body'};
					%hash->{LANG_id} = $val->{'id'};
				}
				$self->{'View'}->parseFormArticle({FORM_EditArticle => $self->{'View'}->makeFormEditArticle(\%hash)});
			}
			my $data = $self->{'AModel'}->getUserArticles($uId);
			my @data = @$data;	
			$self->{'View'}->parsePage(@data);
		}
		else
		{
			$self->{'UModel'}->redirectToHome();
		}
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