package Gerrit::REST::Exception;
{
  $Gerrit::REST::Exception::VERSION = '0.008';
}
# ABSTRACT: Exception class for Gerrit::REST errors

use 5.010;
use utf8;
use strict;
use warnings;

sub new {
    my ($class, $code, $type, $content) = @_;
    return bless {
        code    => $code,
        type    => $type,
        content => $content,
    } => $class;
}

sub as_text {
    my ($op) = @_;
    my $string = "Gerrit::REST::Exception[$op->{code}]: ";
    if ($op->{type} =~ m:text/plain:i) {
        $string .= $op->{content};
    } elsif ($op->{type} =~ m:text/html:i && eval {require HTML::TreeBuilder}) {
        $string .= HTML::TreeBuilder->new_from_content($op->{content})->as_text;
    } else {
        $string .= "<unconvertable Content-Type '$op->{type}'>";
    };
    $string =~ s/\n*$/\n/s;       # force ending in a single newline
    return $string;
};

1;

__END__

=pod

=head1 NAME

Gerrit::REST::Exception - Exception class for Gerrit::REST errors

=head1 VERSION

version 0.008

=head1 DESCRIPTION

This is an auxiliary class for the L<Gerrit::REST> distribution. It's
used by Gerrit::REST methods to throw exceptions when they get some
error code from Gerrit itself, during a REST call. The
Gerrit::REST::Exception objects are simple hash-refs containing the
following information taken from the REST HTTP response:

=over

=item * B<code>

The HTTP numeric error code.

=item * B<type>

The HTTP C<Content-Type>.

=item * B<content>

The HTTP response contents.

=back

Read L<Gerrit::REST> documentation to know how to use it.

=head1 SYNOPISIS

    use Gerrit::REST::Exception;

    # ...
    die Gerrit::REST::Exception->new($code, $content_type, $content);

=head1 METHODS

=head2 new CODE, TYPE, CONTENT

The constructor needs three arguments: the C<code>, the
C<Content-Type>, and the C<content> of the REST HTTP error message.

=head2 as_text

This method stringifies the object like this:

    Gerrit::REST::Exception[<code>]: <content>

The contents are converted to text if possible.

=head1 AUTHOR

Gustavo L. de M. Chaves <gnustavo@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by CPqD <www.cpqd.com.br>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
