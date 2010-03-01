use strict;
use warnings;
use Test::More;
use Test::Base;
use Email::MIME::JP::Mobile;
use Email::MIME::XPath;
use Encode;
use Devel::Peek;
use utf8;

plan tests => 1*blocks;

filters {
    subject => [qw/eval /],
    body    => [qw/eval /],
};

run {
    my $block = shift;

    my $eml;
    my $file = $block->name;
    subtest $file => sub {
        open my $io, '<', $file
            or die "Can't open $file";
        do { local $/ = undef; $eml = <$io>; };
        close $io;

        my $mail = Email::MIME::JP::Mobile->new($eml);
        is($mail->subject, $block->subject, "subject ok")
            or diag(Dump($mail->subject));

        my ($node,) = $mail->xpath_findnodes('//plain');
        is($node->body_str, $block->body, 'body_str ok')
            or diag(Dump($node->body_str));

        done_testing();
    };

};

__END__
=== t/eml/au-pictogram.eml
--- subject: "\x{ecfb}やきいも絵文字"
--- body: "\x{ef93}野球\x{ecfb}やきいも\r\n\r\n"

=== t/eml/au-w41h-pictogram.eml
--- subject: "焼き肉\x{ef9d}"
--- body: "焼き肉??\r\n\r\n"

=== t/eml/i-body-only.eml
--- subject: ""
--- body: "iモード本文のみ\n"

=== t/eml/willcom.pictogram-mail.eml
--- subject: "はなび"
--- body: "はれ\x{e63e}くもり\x{e63f}あめ\x{e640}ゆき\x{e641}\r\n"

=== t/eml/pc-title-body-pict.eml
--- subject: "サム寝入るもっと！"
--- body: "もっとっと\n"

