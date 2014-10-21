package Module::Version::App;

use strict;
use warnings;

use Getopt::Long;
use Module::Version 'get_version';

our $VERSION = '0.01';

sub new { return bless {}, shift }

sub run {
    my $self    = shift;
    my @modules = ();

    $self->parse_args;

    if ( my $modules = $self->{'modules'} ) {
        push @modules, @{$modules};
    }

    if ( my $file = $self->{'input'} ) {
        open my $fh, '<', $file or die "Can't open file '$file': $!\n";

        my @extra_modules = <$fh>;
        chomp @extra_modules;
        push @modules, @extra_modules;

        close $fh or die "Can't close file '$file': $!\n";
    }

    if ( scalar @modules == 0 ) {
        $self->error('No modules to check');
    }

    foreach my $module (@modules) {
        my $version = get_version($module);
        if ( !$version ) {
            if ( ! $self->{'quiet'} ) {
                $self->warn("module '$module' does not seem to be installed");
            }

            next;
        }

        my $output = $self->{'full'} ? "$module $version\n" : "$version\n";
        print $output;
    }
}

sub parse_args {
    my $self = shift;

    GetOptions(
        'h|help'    => sub { $self->help },
        'f|full!'   => \$self->{'full'},
        'i|input=s' => \$self->{'input'},
        'q|quiet!'  => \$self->{'quiet'},
        '<>'        => sub { $self->process(@_) },
    ) or $self->error('Could not parse options');
}

sub process {
    my ( $self, @args ) = @_;

    # force stringify Getopt::Long input
    push @{ $self->{'modules'} }, "$_" for @args;
}

sub help {
    my $self = shift;

    print <<"    _END";
$0 [ OPTIONS ] Module Module Module...

Provide a module's version, comfortably.

OPTIONS
    -f | --full     Output name and version (Module::Version 0.02)
    -i | --input    Input file to read module names from
    -q | --quiet    Do not error out if module doesn't exist

    _END
}

sub error {
    my ( $self, $error ) = @_;
    die "Error: $error\n";
}

sub warn {
    my ( $self, $warning ) = @_;
    warn "Warning: $warning\n";
}

1;

__END__

=head1 NAME

Module::Version::App - Application implementation for Module::Version

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This is the CLI program's implementation as a module.

    use Module::Version::App;

    my $app = Module::Version::App->new;

    $app->run;

=head1 SUBROUTINES/METHODS

=head2 new

Create a new object.

=head2 run

Do all the grunt work.

=head2 parse_args

Parsing the command line arguments using L<Getopt::Long>.

=head2 process

Parses extra arguments from L<Getopt::Long>.

=head2 help

Print a help menu for the application itself.

=head2 error($error)

Calls C<die> with a message.

=head2 warn($warning)

Calls C<warn> with a message.

=head1 EXPORT

Object Oriented, nothing is exported.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-module-version at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Version>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Module::Version

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Version>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Module-Version>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Module-Version>

=item * Search CPAN

L<http://search.cpan.org/dist/Module-Version/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Sawyer X.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

