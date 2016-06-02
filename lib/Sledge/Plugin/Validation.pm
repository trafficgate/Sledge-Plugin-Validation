package Sledge::Plugin::Validation;
# $Id: Validation.pm,v 1.4 2002/08/22 10:43:44 miyagawa Exp $
#
# Tatsuhiko Miyagawa <miyagawa@edge.co.jp>
# Livin' On The EDGE, Limited.
#

use strict;
use vars qw($VERSION);
$VERSION = 0.02;

use Sledge::Constants;
use Sledge::Exceptions;

sub import {
    my $class = shift;
    return unless @_;

    my %args = @_;
    my $pkg = caller;
    no strict 'refs';
    while (my($page, $validator) = each %args) {
        *{"$pkg\::post_dispatch_$page"} = $class->make_post_closure($page, $validator);
    }
}

sub make_post_closure {
    my($class, $page, $val_class) = @_;
    my $val_method = 'validate'; # default
    if ($val_class =~ /^(.*)\->(.*)$/) {
        $val_class = $1;
        $val_method = $2;
    }
    eval qq{require $val_class};
    if ($@ && $@ !~ /locate/) {
        Sledge::Exception::ClassUndefined->throw($@);
    }
    return sub {
        my $self = shift;
        my $validator  = $val_class->new;
        my($status, $reason) = $validator->$val_method($self);
        my $method = ($status == SUCCESS) ? "succeed_$page" : "fail_$page";
        $self->$method($reason);
    };
}

1;
