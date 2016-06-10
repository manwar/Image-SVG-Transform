use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Deep;

use blib;

use_ok 'Image::SVG::Transform';

##simple transform
my $trans = Image::SVG::Transform->new();
$trans->extract_transforms('translate(1,1) scale(2)');
is_deeply
    $trans->transforms,
    [
        { type => 'translate', params => [1,1], },
        { type => 'scale', params => [2], }
    ],
    'checking setup for transform';

my $ctm = $trans->get_ctm();
cmp_deeply dump_matrix( $ctm ),
          [
            [ 2, 0, 2 ],
            [ 0, 2, 2 ],
            [ 0, 0, 1 ],
          ],
          'Getting the combined transform matrix for a double transform';

my $view1 = $trans->transform([0, 0]);
is_deeply $view1, [ 2, 2 ], 'Translate and scale from 0,0 to 2,2';

##Now, reverse the order and apply the same point
$trans->extract_transforms('scale(2) translate(1,1)');
my $view2 = $trans->transform([0,0]);
is_deeply $view2, [ 1, 1 ], 'scale and translate from 0,0 to 1,1';

done_testing();

sub dump_matrix {
    my $matrix = shift;
    my $dumped = [ ];
    $dumped->[0] = clone $matrix->[0];
    $dumped->[1] = clone $matrix->[1];
    $dumped->[2] = clone $matrix->[2];
    return $dumped;
}
