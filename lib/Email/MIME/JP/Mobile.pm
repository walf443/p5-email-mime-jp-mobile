package Email::MIME::JP::Mobile;

use strict;
use warnings;
our $VERSION = '0.01';

use base qw(Email::MIME);
use Encode ();
use Email::Simple;
use Email::Address::JP::Mobile;


sub mobile {
    my ($self, ) = @_;
    $self->{__jp_mobile} ||= Email::Address::JP::Mobile->new( scalar $self->header('From') );
}

sub body_str {
    my ($self, ) = @_;
    if ( $self->mobile && $self->mobile->is_mobile ) {
        my $carrier = $self->mobile->name eq 'EZweb' ? 'ezweb-auto' : $self->mobile->name;
        my $charset = $self->{ct}{attributes}{charset};
        if ( $charset ) {
            my $encoding = Encode::find_encoding("x-$charset-$carrier");
            if ( $encoding ) {
                return Encode::decode($encoding, $self->body);
            } else {
                return Encode::decode($charset, $self->body);
            }
        } else {
            return Encode::decode('iso-2022-jp', $self->body);
        }
    } else {
        return $self->SUPER::body_str;
    }
}

sub subject {
    my ($self, ) = @_;
    my $subject = $self->header_obj->header_raw('Subject');
    $self->mobile->mime_encoding->decode($subject);
}

1;
__END__

=head1 NAME

Email::MIME::JP::Mobile -

=head1 SYNOPSIS

    use Email::MIME::JP::Mobile;
    use Email::MIME::XPath;
    my $mail = Email::MIME::JP::Mobile->new($eml);
    say $mail->subject;
    my $bodynode = $mail->xpath_findnodes('//plain');
    say $bodynode->body_str if $bodynode;


=head1 DESCRIPTION

Email::MIME::JP::Mobile is

=head1 AUTHOR

Tokuhiro Matsuno <tokuhirom {at} gmail.com>
Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut