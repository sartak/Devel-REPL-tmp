package Devel::REPL;

use Term::ReadLine;
use Moose;
use namespace::clean -except => [ 'meta' ];

with 'MooseX::Object::Pluggable';

has 'term' => (
  is => 'rw', required => 1,
  default => sub { Term::ReadLine->new('Perl REPL') }
);

has 'prompt' => (
  is => 'rw', required => 1,
  default => sub { '$ ' }
);

has 'out_fh' => (
  is => 'rw', required => 1, lazy => 1,
  default => sub { shift->term->OUT || \*STDOUT; }
);

sub run {
  my ($self) = @_;
  while ($self->run_once) {
    # keep looping
  }
}

sub run_once {
  my ($self) = @_;
  my $line = $self->read;
  return unless defined($line); # undefined value == EOF
  my @ret = $self->eval($line);
  $self->print(@ret);
  return 1;
}

sub read {
  my ($self) = @_;
  return $self->term->readline($self->prompt);
}

sub eval {
  my ($self, $line) = @_;
  my ($to_exec, @rest) = $self->compile($line);
  return @rest unless defined($to_exec);
  my @ret = $self->execute($to_exec);
  return @ret;
}

sub compile {
  my $REPL = shift;
  my $compiled = eval $REPL->wrap_as_sub($_[0]);
  return (undef, $REPL->error_return("Compile error", $@)) if $@;
  return $compiled;
}

sub wrap_as_sub {
  my ($self, $line) = @_;
  return qq!sub {\n!.$self->mangle_line($line).qq!\n}\n!;
}

sub mangle_line {
  my ($self, $line) = @_;
  return $line;
}

sub execute {
  my ($self, $to_exec, @args) = @_;
  my @ret = eval { $to_exec->(@args) };
  return $self->error_return("Runtime error", $@) if $@;
  return @ret;
}

sub error_return {
  my ($self, $type, $error) = @_;
  return "${type}: ${error}";
}

sub print {
  my ($self, @ret) = @_;
  my $fh = $self->out_fh;
  print $fh "@ret";
}

1;
