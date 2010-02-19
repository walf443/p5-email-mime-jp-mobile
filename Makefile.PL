use inc::Module::Install;
# use Module::Install::ReadmeFromPod;
name 'Email-MIME-JP-Mobile';
all_from 'lib/Email/MIME/JP/Mobile.pm';
# readme_from 'lib/Email/MIME/Jp/Mobile.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
build_requires 'Test::LoadAllModules';
build_requires 'Module::Install::ReadmeFromPod';
use_test_base;
auto_include;
WriteAll;
