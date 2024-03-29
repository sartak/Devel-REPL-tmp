use strict;
use warnings;
use inc::Module::Install 0.91;

name 'Devel-REPL';
perl_version '5.008001';
all_from 'lib/Devel/REPL.pm';
repository 'http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/Devel-REPL.git';

install_script 'script/re.pl';

# core
requires 'File::Spec';
requires 'Term::ReadLine';

# rest
requires 'Moose' => '0.93';
requires 'MooseX::Object::Pluggable' => '0.0009';
requires 'MooseX::Getopt' => '0.18';
requires 'namespace::autoclean';
requires 'File::HomeDir';
requires 'Task::Weaken';
requires 'B::Concise';
requires 'Term::ANSIColor';
requires 'Devel::Peek';

feature 'Completion plugin - extensible tab completion',
    -default => 1,
    'PPI' => 0;

feature 'DDS plugin - better format results with Data::Dump::Streamer',
    -default => 1,
    'Data::Dump::Streamer' => 0;

feature 'DDC plugin - even better format results with Data::Dumper::Concise',
    -default => 1,
    'Data::Dumper::Concise' => 0;

feature 'INC completion driver - tab complete module names in use and require',
    -default => 0,
    'File::Next' => 0;

feature 'Interrupt plugin - traps SIGINT to kill long-running lines',
    -default => (($^O =~ /Win32/) ? 0 : 1),
    'Sys::SigAction' => 0;

feature 'Keywords completion driver - tab complete Perl keywords and operators',
    -default => 0,
    'B::Keywords' => 0;

feature 'LexEnv plugin - variables declared with "my" persist between statements',
    -default => 1,
    'Lexical::Persistence' => 0;

feature 'MultiLine::PPI plugin - continue reading lines until all blocks are closed',
    -default => 1,
    'PPI' => 0;

feature 'Nopaste plugin - upload a session\'s input and output to a Pastebin',
    -default => 0,
    'App::Nopaste' => 0;

feature 'PPI plugin - PPI dumping of Perl code',
    -default => 1,
    'PPI' => 0;

feature 'Refresh plugin - automatically reload libraries with Module::Refresh',
    -default => 0,
    'Module::Refresh' => 0;

test_requires 'Test::More';

auto_install;
WriteAll;

