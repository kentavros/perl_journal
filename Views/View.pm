package Views::View;

use strict;
use warnings;
use Data::Dumper;

#
#
#reads file to self property
sub read($)
{
	my ($self) = shift;
	my $fileName = $_[0];
	$self->{'html'} = $self->{'fh'}->readFile($fileName);
}

#
#recieve hash link to
#parse file in self property 
sub parse($)
{
    my($self, $hash) = @_;
    $self->{'html'} =~ s/LANG_(\w)+/$hash->{$&}/gse;
}

#recieve an html string
#and hash link
#parse and returns parsed string
#
sub parseP($$)
{
    my($self, $html ,$hash) = @_;
    $html=~ s/LANG_(\w)+/$hash->{$&}/gse;
	return $html;
}

#
#returns an html content string
#
sub getHtml
{
	my ($self) = shift;
	return $self->{'html'};
}

#
#parse form for adding article
#saves it to self property
sub parseAddArticleForm
{
	my ($self) = shift;
	my $hash = $_[0];
	$self->{'html'}=~ s/ADD_(\w)+/$hash->{$&}/gse;
}

#recieves hash link
#reads form template
#parse it with hash
#returns parsed string
sub makeFormEditArticle
{
	my ($self) = shift;
	my ($hash) = shift;
	my $pattern = $self->{'fh'}->readFile('templates/cabinet/form.html');
	$pattern =~ s/LANG_(\w)+/$hash->{$&}/gse;
	return $pattern;	
}

#
#
#reads addArticle form template
#returns html string
sub makeFormAddArticle
{
	my ($self) = shift;
	my $pattern = $self->{'fh'}->readFile('templates/cabinet/addarticle.html');
	return $pattern;	
}

#
#recives an array
#parse html in self property 
#with self method on regexp name
#
#
sub parsePage
{
    my($self, @arr) = @_;
    $self->{'html'} =~ s/LANG_(\w)+/$self->$&(@arr)/gse;
}

#
#parse buttons to self html property 
#
#
sub parseButtons
{
	my ($self) = shift;
	my $btns = $_[0];
	$self->{'html'}=~ s/BUTT_(\w)+/$btns->{$&}/gse;
}


#
#parse values from hash
#to html template of form editArticle
#
sub parseFormArticle
{
	my ($self) = shift;
	my $hash = $_[0];
	$self->{'html'}=~ s/FORM_(\w)+/$hash->{$&}/gse;
}



#
#reads a button template
#parse it depends on incoming hash
#
sub makeButton
{
	my ($self) = shift;
	my ($hash) = shift;
	my $pattern = $self->{'fh'}->readFile('templates/home/button.html');
	$pattern =~ s/LANG_(\w)+/$hash->{$&}/gse;
	return $pattern;
}

#
#method to parse with
#regexp call-self-method
#
sub LANG_articles
{
	my ($self) = shift;
	my (@arr) = @_;
	my $pattern = $self->read('templates/home/article.html');
	
	my $string;
	my %hash;
	foreach my $value(@arr)
	{
		%hash->{LANG_title} = $value->{'title'};
		%hash->{LANG_date} = $value->{'date'};
		%hash->{LANG_body} = $value->{'body'};
		%hash->{LANG_author} = $value->{'author'};
		$string .= $self->parseP($pattern, \%hash);
	}
	return $string;
}

#
#method to parse with
#regexp call-self-method
#
sub LANG_UserArticles
{
	my ($self) = shift;
	my (@arr) = @_;
	my $pattern = $self->read('templates/cabinet/userArticles.html');
	
	my $string;
	my %hash;
	foreach my $value(@arr)
	{
		%hash->{LANG_title} = $value->{'title'};
		%hash->{LANG_date} = $value->{'date'};
		%hash->{LANG_body} = $value->{'body'};
		%hash->{LANG_id} = $value->{'id'};
		$string .= $self->parseP($pattern, \%hash);
	}
	return $string;
}


#__construct
#recieves an fileHandler util 
#
sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'fh' => $_[1], 'html' => ''}; $class;
}
1;
############
#created by user9