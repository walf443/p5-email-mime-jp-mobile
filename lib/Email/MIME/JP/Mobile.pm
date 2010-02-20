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

=encoding utf-8

=head1 NAME

Email::MIME::JP::Mobile - handle email for japanese mobile carrier.

=head1 SYNOPSIS

    use Email::MIME::JP::Mobile;
    use Email::MIME::XPath;
    my $mail = Email::MIME::JP::Mobile->new($eml);
    say $mail->subject;
    my $bodynode = $mail->xpath_findnodes('//plain');
    say $bodynode->body_str if $bodynode;


=head1 DESCRIPTION

Email::MIME::JP::MobileはEmail::MIMEのwrapperで同様のインターフェースでutf8フラグを立てた状態でsubjectあるいはbody_strを扱えます。

各キャリアの仕様の関係上で、絵文字が抜きだせるのはEzwebとウィルコム端末だけです。

今のところ受信向けでしかあまり使っていなくて、送信については特に検証はしてないです。

あまり関係ないですが、添付画像を抜きだりするときにDoCoMoとかだとうまくいかないケースがあるらしいので、Email::MIME::XPathを使うのがよいらしいです。
http://mobilehacker.g.hatena.ne.jp/tomi-ru/20080711/1215788914

現在の段階では、動かすためにはcpanに存在しない以下のモジュールが必要です。

Encode::JP::Mobile ( 通常版とは違うので注意 )
 http://svn.coderepos.org/share/lang/perl/Encode-JP-Mobile/branches/mime

Email::Address::JP::Mobile
http://svn.coderepos.org/share/lang/perl/Email-Address-JP-Mobile/trunk

=head1 AUTHOR

Tokuhiro Matsuno <tokuhirom {at} gmail.com>
Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 THANKS

Naoki Tomita (tomi-ru)

=head1 SEE ALSO

+<Email::MIME>, +<Email::Address::JP::Mobile>, +<Encode::JP::Mobile>, +<Email::MIME::XPath>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
