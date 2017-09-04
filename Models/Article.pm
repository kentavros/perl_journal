package Models::Article;

use strict;
use warnings;
use Data::Dumper;

#############
##created by user8
#gets all articles from db
#
sub getArticles
{
    my ($self) = shift;
    my $query = 'select a.title, a.body, a.date, u.name as author, u.id as auth_id from articles a inner join users u on a.id_author = u.id order by date';
    return $self->{'Db'}->select($query);
}

#
#
#gets articles by user ID
sub getUserArticles
{
    my ($self, $idUser) = @_;
    my $query = 'SELECT id, title, body, date FROM articles WHERE id_author=\''.$idUser.'\'';
    return $self->{'Db'}->select($query);
}
#############
##created by user8


#############
##created by user7
#gets article by Id
sub getArticleById
{
    my ($self, $artId) = @_;
    my $query = 'SELECT id, title, body FROM articles WHERE id=\''.$artId.'\'';
    return $self->{'Db'}->select($query);
}
#############
##created by user7


#############
##created by user8
#adds an article to db
sub addArticle
{
    my $self = shift;
    my $data = shift;
    my $uId = shift;
    my $query = 'INSERT INTO articles (id_author, title, body) VALUES (\''.$uId.'\', \''.$data->{'title'}.'\', \''.$data->{'body'}.'\')';
    if ($self->{'Db'}->insert($query) == 1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#
#
#delete an article by Id
sub deleteArticle
{
    my $self = shift;
    my $aId = shift;
    my $query = 'DELETE FROM articles WHERE id='.$aId;
    if ($self->{'Db'}->delete($query))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
#############
##created by user8

#############
##created by user7
#
#
#edits an article by Id
sub editArticle
{
    my $self = shift;
    my $postData = shift;
    my $query = 'UPDATE articles SET title=\''.$postData->{'title'}.'\', body=\''.$postData->{'body'}
    .'\', date=CURRENT_TIMESTAMP WHERE id=' .$postData->{'id'};
    if ($self->{'Db'}->update($query) == 1)
    {
        return 1;
    }
    else {
        return 0;
    }
}

#__construct
#recives an Db object
#
sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'Db' => $_[1]}; $class;
}
1;
#created by user7
