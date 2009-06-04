package Dist::Zilla::MetaProvides::ProvideRecord;

# ABSTRACT: Data Management Record for MetaProvider::Provides Based Class

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Types::Moose             (':all');
use Dist::Zilla::MetaProvides::Types (':all');
use List::MoreUtils                  ('all');
use Moose::Autobox;
use MooseX::Has::Sugar;

use namespace::autoclean;

=head1 ATTRIBUTES

=head2 version

See L<Dist::Zilla::MetaProvides::Types/ModVersion>

=cut

has version => ( isa => ModVersion, ro, required );

=head2 module

The String Name of a fully qualified module to be reported as
included in the distribution.

=cut

has module => ( isa => Str, ro, required );

=head2 file

The String Name of the file as to be reported in the distribution.

=cut

has file => ( isa => Str, ro, required );

=head2 parent

A L<Dist::Zilla::MetaProvides::Types/ProviderObject>, mostly to get Zilla information
and accessors from L<Dist::Zilla::Role::MetaProvider::Provider>

=cut

has parent => ( ro, required, weak_ref,
  isa     => ProviderObject,
  handles => [ 'zilla', '_resolve_version', ],
);

=head1 METHODS

=head2 copy_into C<( \%provides_list )>

Populate the referenced C<%provides_list> with data from this Provide Record object.

This is called by the  L<Dist::Zilla::Role::MetaProvider::Provider> Role.

This is very convenient if you have an array full of these objects, for you can just do

    my %discovered;
    for ( @array ){
       $_->copy_into( \%discovered );
    }

and C<%discovered> will be populated with relevant data.

=cut

sub copy_into {
  my $self  = shift;
  my $dlist = shift;
  $dlist->{ $self->module } = {
    file => $self->file,
    $self->_resolve_version( $self->version ),
  };
}

1;
