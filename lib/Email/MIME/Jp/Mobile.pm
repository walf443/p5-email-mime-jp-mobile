package Email::MIME::Jp::Mobile;

use strict;
use warnings;
our $VERSION = '0.01';

use base qw(Email::MIME);
use Encode ();
use Email::Address::JP::Mobile;


sub mobile {
    my ($self, ) = @_;
    $self->{__jp_mobile} ||= Email::Address::JP::Mobile->new( scalar $self->header('From') );
}

sub force_decode_hook { 1 }
sub decode_hook {
    my ($self, $body) = @_;
    $self->mobile->mail_encoding->decode($body);
}

sub subject {
    my ($self, ) = @_;
    my $subject = Email::Simple::header('Subject');
    $self->mobile->mime_encoding->decode($subject);
}

1;
__END__

=head1 NAME

Email::MIME::Jp::Mobile -

=head1 SYNOPSIS

    use Email::MIME::JP::Mobile;
    use Email::MIME::XPath;
    my $mail = Email::MIME::JP::Mobile->new($eml);
    say $mail->subject;
    my $bodynode = $mail->xpath_findnodes('//plain');
    say $bodynode->body if $bodynode;


=head1 DESCRIPTION

Email::MIME::Jp::Mobile is

=head1 AUTHOR

Tokuhiro Matsuno <tokuhirom {at} gmail.com>
Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
