# "is Cool" brings in all the trigonometric functions

unit class Math::Angle is Cool;

# use Grammar::Tracer;

# The following definitions use the approximation
# π ≅ 66627445592888887/21208174623389167
# which is the best rational approximation to π such that
# the denominator and numerator of each of the following
# Rats will fit in 64 bits.
#
# This gives a significantly better approximation than using
# the built-in floating point value of π.
#
# Values are from entry 32 of https://oeis.org/A002485/b002486.txt and
# https://oeis.org/A002486/b002486.txt.

my \deg2rad = Rat.new(66627445592888887, 180 × 21208174623389167);
my \rad2deg = Rat.new(180 × 21208174623389167, 66627445592888887);

my \grad2rad = Rat.new(66627445592888887, 200 × 21208174623389167);
my \rad2grad = Rat.new(200 × 21208174623389167, 66627445592888887);

my \turn2rad = Rat.new(2 × 66627445592888887, 21208174623389167);
my \rad2turn = Rat.new(21208174623389167, 2 × 66627445592888887);

#| The angle. This is stored in radians, but that is transparent to the user.
has $!angle is built;

submethod TWEAK(:$rad, :$deg, :$grad, :$turn, :$min, :$sec) {
    if  ($rad.defined                                 ?? 1 !! 0)
      + ($deg.defined || $min.defined || $sec.defined ?? 1 !! 0)
      + ($grad.defined                                ?? 1 !! 0)
      + ($turn.defined                                ?? 1 !! 0)
      ≠ 1
      or $!angle.defined {
        fail 'Must specify exactly one of rad, deg, grad, or turn';
    }
    $!angle = $rad             if $rad.defined;
    $!angle = $grad × grad2rad if $grad.defined;
    $!angle = $turn × turn2rad if $turn.defined;
    if $deg.defined || $min.defined || $sec.defined {
        my $angle = 0;
        $angle += $deg        if $deg.defined;
        $angle += $min ÷   60 if $min.defined;
        $angle += $sec ÷ 3600 if $sec.defined;
        $!angle = $angle × deg2rad;
    }
}

#! Return the angle in radians
method rad() {
    $!angle;
}

#! Return the angle in degrees
method deg() {
    $!angle × rad2deg;
}

#! Return the angle in grads
method grad() {
    $!angle × rad2grad;
}

#! Return the angle in turns
method turn() {
    $!angle × rad2turn;
}

#| Return a string representing the angle in degrees, minutes and seconds.

method dms(:$degsym = '°',
           :$minsym = "′",
           :$secsym = '″',
           :$separator = ' ',
           :$presign = ' -',
           :$postsign = '  ',
           :$secfmt    = '%.4f',
          ) {
    my $pres = $presign ~ '  ';
    my $posts = $postsign ~ '  ';
    my $beforesign = '';
    my $aftersign = '';
    my $degrees = $!angle × rad2deg;
    if $degrees < 0 {
        $degrees    = - $degrees;
        $beforesign = $pres.substr(1,1);
        $aftersign  = $posts.substr(1,1);
    } else {
        $beforesign = $pres.substr(0,1);
        $aftersign  = $posts.substr(0,1);
    }
    my $deg = $degrees.Int;
    my $minutes = ($degrees - $deg) × 60;
    my $min = $minutes.Int;
    my $sec = ($minutes - $min) × 60;
    $beforesign ~ $deg ~ $degsym ~ $separator ~ $min ~ $minsym ~ $separator ~ sprintf($secfmt, $sec) ~ $secsym ~ $aftersign;
}
#`««
  By default, the returned string looks similar to «-43° 26' 4.2841"», but
  is significantly configurable.

  The symbols used to represent degrees, minutes and seconds can be changed
  by specifying the named paramaters C<degsym>, C<minsym> and C<secsym>
  respectively.

  The representation of seconds can be changed by specifying a printf
  format string for the C<secfmt> named parameter.

  The representation of positive and negative numbers can be changed by
  specifying the values of the C<presign> and C<postsign> named parameters.
  The first character of C<presign> is printed before a positive angle.
  The second character is printed after a positive angle.
  Similarly the characters of C<postsign> are printed before and after
  a negative angle. If any character of C<presign> or C<postsign>
  is a space, then it is not printed.

  Thus, if the angle above represented a latitude, then specifying
  C<presign> as '  ' (two spaces), and C<postsign> as 'NS', then the
  returned string would be «43° 23' 4.2841"S».

  The C<separator> named parameter can be specified to change the separator
  between the degress and minutes, and between the minutes and seconds.
»»


#|««
  Return a string representing the angle in degrees and minutes.

  By default, the returned string looks similar to «-43° 26.2841'», but
  is significantly configurable.

  The symbols used to represent degrees and minutes can be changed
  by specifying the named paramaters C<degsym> and C<minsym> respectively.

  The representation of minutes can be changed by specifying a printf
  format string for the C<minfmt> named parameter.

  The representation of positive and negative numbers can be changed by
  specifying the values of the C<presign> and C<postsign> named parameters.
  The first character of C<presign> is printed before a positive angle.
  The second character is printed after a positive angle.
  Similarly the characters of C<postsign> are printed before and after
  a negative angle. If any character of C<presign> or C<postsign>
  is a space, then it is not printed.

  Thus, if the angle above represented a latitude, then specifying
  C<presign> as '  ' (two spaces), and C<postsign> as 'EW', then the
  returned string would be «43° 23.2841'W».

  The C<separator> named parameter can be specified to change the separator
  between the degress and minutes, and between the mintes and seconds.
»»

method dm(:$degsym = '°',
          :$minsym = "'",
          :$separator = ' ',
          :$presign = ' -',
          :$postsign = '  ',
          :$minfmt    = '%.4f',
         ) {
    my $pres = $presign ~ '  ';
    my $posts = $postsign ~ '  ';
    my $beforesign = '';
    my $aftersign = '';
    my $degrees = $!angle × rad2deg;
    if $degrees < 0 {
        $degrees    = - $degrees;
        $beforesign = $pres.substr(1,1);
        $aftersign  = $posts.substr(1,1);
    } else {
        $beforesign = $pres.substr(0,1);
        $aftersign  = $posts.substr(0,1);
    }
    my $deg = $degrees.Int;
    my $min = ($degrees - $deg) × 60;
    $beforesign ~ $deg ~ $degsym ~ $separator ~ sprintf($minfmt, $min) ~ $minsym ~ $aftersign;
}

enum Math::Angle::Range is export (
    SYMMETRIC => 0,
    POSITIVE  => 1,
);

method normalize(:$range = SYMMETRIC) {
    my $newangle = $!angle;
    $newangle += π if $range == SYMMETRIC;
    $newangle %= τ;
    $newangle -= π if $range == SYMMETRIC;
    $!angle = $newangle;
}

method Numeric() { $!angle }

#|««
  Create a new C<Angle> object containing the argument as an angle in degrees.

  Thus C<45°> is the same as C<Angle.new(deg => 45)>.
»»
our sub postfix:<°>(\a) is export {
    Math::Angle.new(deg => a);
}

#|««
  Add two angles. The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360}.
»»
multi infix:<+>(Math::Angle $a, Math::Angle $b) is export {
    Math::Angle.new(rad => $a.rad + $b.rad);
}

#|««
  Multiply a number by an angle.  The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360).
»»
multi infix:<*>(Real $a, Math::Angle $b) is export {
    Math::Angle.new(rad => $a × $b.rad);
}

#|««
  Multiply a number by an angle.  The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360).

  This is the same as C<infix<*>>, but uses the Unicode multiplication operator.
»»
multi infix:<×>(Real $a, Math::Angle $b) is export {
    Math::Angle.new(rad => $a × $b.rad);
}

#|««
  Multiply an angle by a number.  The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360).
»»
multi infix:<*>(Math::Angle $a, Real $b) is export {
    Math::Angle.new(rad => $a.rad × $b);
}

#|««
  Multiply an angle by a number.  The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360).

  This is the same as C<infix<*>>, but uses the Unicode multiplication operator.
»»
multi infix:<×>(Math::Angle $a, Real $b) is export {
    Math::Angle.new(rad => $a.rad × $b);
}

#|««
  Divide an angle by a number.  The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360).
»»
multi infix:</>(Math::Angle $a, Real $b) is export {
    Math::Angle.new(rad => $a.rad ÷ $b);
}

#|««
  Divide an angle by a number.  The result is an C<Angle> object which is
  not normalised in any way. I.e. it might be outside the range [-180, 360).

  This is the same as C<infix</>>, but uses the Unicode division operator.
»»
multi infix:<÷>(Math::Angle $a, Real $b) is export {
    Math::Angle.new(rad => $a.rad ÷ $b);
}

#|««
  Return the ratio of two angles.  The result is a number.
»»
multi infix:</>(Math::Angle $a, Math::Angle $b) is export {
    $a.rad ÷ $b.rad;
}

#|««
  Return the ratio of two angles.  The result is a number.

  This is the same as C<infix</>>, but uses the Unicode division operator.
»»
multi infix:<÷>(Math::Angle $a, Math::Angle $b) is export {
    $a.rad ÷ $b.rad;
}

#|««
  Return the difference between two angles. The result is an C<Angle>
  object which is not normalised in any way. I.e. it might be outside
  the range [-180, 360).
»»
multi infix:<->(Math::Angle $a, Math::Angle $b) is export {
    Math::Angle.new(rad => $a.rad = $b.rad);
}

# The inverse trigonetric functions returning a Math::Angle object

our sub asin(Real $a) is export {
    Math::Angle.new(rad => $a.asin);
}

our sub acos(Real $a) is export {
    Math::Angle.new(rad => $a.acos);
}

our sub atan(Real $a) is export {
    Math::Angle.new(rad => $a.atan);
}

our sub atan2(Real $a, Real $b) is export {
    Math::Angle.new(rad => $a.atan2($b));
}

our sub asec(Real $a) is export {
    Math::Angle.new(rad => $a.asec);
}

our sub acosec(Real $a) is export {
    Math::Angle.new(rad => $a.acosec);
}

our sub acotan(Real $a) is export {
    Math::Angle.new(rad => $a.acotan);
}

our sub asinh(Real $a) is export {
    Math::Angle.new(rad => $a.asinh);
}

our sub acosh(Real $a) is export {
    Math::Angle.new(rad => $a.acosh);
}

our sub atanh(Real $a) is export {
    Math::Angle.new(rad => $a.atanh);
}

our sub asech(Real $a) is export {
    Math::Angle.new(rad => $a.asech);
}

our sub acosech(Real $a) is export {
    Math::Angle.new(rad => $a.acosech);
}

our sub acotanh(Real $a) is export {
    Math::Angle.new(rad => $a.acotanh);
}

method Complex() {
    self.Numeric.cis;
}
method complex() {
    self.Numeric.cis;
}

my @degsyms = <° d D>;
my @minsyms = <' ′ m M>;
my @secsyms = <" ″ s S>;

#|««
  Grammar C<DMS> matches a string representing an angle specified in
  degrees, minutes, and seconds.

  The string consists of an optional sign, followed by fields representing
  the number of degrees, minutes and seconds in that order—although each
  field is optional—followed by an optional 'N', 'S", 'E" or 'W' also
  representing the sign of the angle. (If a leading and trailing sign
  are both specified, then they are both applied—remember that two
  negatives make a positive.)

  Each of the three numeric fields consists of a number followed by
  a units designator. The degree field is marked either by
  a degree symbol (C<°>) or by the letter C<d> in ether case.
  Similarly the minutes field is indicated by a prime symbol (C<′>, C<U+2032>),
  a single quote (C<'>) or the letter 'm',
  and the seconds field by a double prime symbol (C<″>, C<U+2033>),
  a double quote (C<">), or the letter 's'.

  Note that in the following grammar, if the last field specified (normally
  seconds, but could be something else if the seconds field is missing) uses
  an alphabetic character to specify the type, then any following sign
  indicator must be separated from the type by whitespace.
  This is a bug!
»»

grammar DMS {
    rule TOP {<leading-sign> <deg> <min> <sec> <trailing-sign>
              {
                  make $<trailing-sign>.made
                     × $<leading-sign>.made
                     × ($<deg>.made + $<min>.made  + $<sec>.made)
                  ;
                  }
             }
    token deg {
        |                         {make 0;}
        | (<number>) @degsyms     {make +$0}}
    token min {
        |                         {make 0;}
        | (<number>) @minsyms     {make +$0 ÷ 60}}
    token sec {
        |                         {make 0;}
        | (<number>) @secsyms     {make +$0 ÷ 3600}}
    token leading-sign {
        |                         { make  1; }
        | '+'                     { make  1; }
        | '-'                     { make -1; }
    }
    token trailing-sign {
        |                         { make  1; }
        | :i 'S'                  { make -1; }
        | :i 'N'                  { make  1; }
        | :i 'W'                  { make -1; }
        | :i 'E'                  { make  1; }
    }
    token bare-number {
        | (\d+ [ <[.,]> [\d+]?]?) { make +$0; }
        | (<[.,]> \d+)            { make +$0; }
    }
    token exponent {
        |                          { make 1; }
        | :i 'e' (['-']? \d+)      { make 10 ** +$0; }
    }
    token number {
        | <bare-number> <exponent> { make $<bare-number>.made × $<exponent>.made; }
    }
}

#|««
  Return an C<Angle> object initialised with the value given by the argument string.  
»»

our sub from-dms(Str $s) is export {
    my $m = Math::Angle::DMS.parse($s);
    if $m {
        Math::Angle.new(deg => +$m.made);
    } else {
        fail("unrecognised angle in string");
    }
}
