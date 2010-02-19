use strict;
use warnings;
use Test::More;
use Test::Base;
use Email::MIME::Jp::Mobile;
use Encode;
use Devel::Peek;
use utf8;

plan tests => 1*blocks;

filters {
    subject => [qw/eval /],
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

        my $mail = Email::MIME::Jp::Mobile->new($eml);
        is($mail->subject, $block->subject, "subject ok")
            or diag(Dump($mail->subject));

        done_testing();
    };

};

__END__
=== t/eml/au-pictogram.eml
--- subject: "\x{ecfb}やきいも絵文字"
=== t/eml/au-w41h-pictogram.eml
--- subject: "焼き肉\x{ef9d}"
=== t/eml/i-body-only.eml
--- subject: ""
=== t/eml/pc-title-body-pict.eml
--- subject: "サム寝入るもっと！"
=== t/eml/willcom.pictogram-mail.eml
--- subject: "はなび"
