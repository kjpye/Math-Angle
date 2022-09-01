[![Actions Status](https://github.com/kjpye/Math-Angle/actions/workflows/test.yml/badge.svg)](https://github.com/kjpye/Math-Angle/actions)

NAME
====

Math::Angle - a class to handle geometric angles

SYNOPSIS
========

```raku
use Math::Angle;
my \φ = Math::Angle.new(deg => 63.4);
say φ.sin;
say cos φ;
```

DESCRIPTION
===========

Math::Angle defines objects which represent angles. It was written to try to prevent the problems I kept encountering in forgetting to convert angles between radians and degrees.

Thus an angle may be defined in terms of radians, degrees or grads, and then used in trigonometric expressions without concern for conversion between units.

The standard trigonometric functions available in Raku can all be used as either methods on the `Math::Angle` object, or as functions with the `Math::Angle` object as argument.

In addition, subroutines are available for the inverse trigonometric functions which return a Math::Angle object.

Some basic arithmetic using `Math::Angle` objects is also possible where it makes sense.

Object creation
---------------

`Math::Angle` objects are created by calling the `Math::Angle.new` routine with a named argument specifying the angle required. The following three possibilities are equivalent:

```raku
my $φ = Math::Angle.new(rad => π/4);
my $η = Math::Angle.new(deg => 45);
my $θ = Math::Angle.new(grad => 50);
```

Accessing the angle value
-------------------------

The angle embedded within a `Math::Angle` object can be accessed using the three methods `rad`, `deg`, and `grad` which convert the internal value to the requested representation

Note that it is thus possible to convert an angle from degrees to radians by writing

```raku
Math::Angle.new(deg => 27).rad
```

Arithmetic
----------

Arithmetic involving `Math::Angle` objects is possible where it makes sense:

```raku
my \φ1 = Math::Angle.new(:37deg);
my \φ2 = Math::Angle.new(rad => π/6);
say (φ1 - φ2).deg;
say (φ1 + φ2).rad;
say (φ1 × 2).rad;
say (4 × φ2).deg;
say φ1 ÷ φ2;
```

With the exception of division, the results of all those objects will be a `Math::Angle` object. The result of the division is a plain number representing the ratio of the two angles.

Coercion
--------

`Math::Angle` has two coercion methods, `Numeric` and `Comples`. `Numeric` returns the numeric value of the angle in radians. `Complex` returns a complex number with radius 1 and angle given by the `Math::Angle` object.

`Math::Angle` also inherits from `Cool`. When combined with the `Numeric` coercion, this gives access to the trigonometric functions `sin`, `cos`, `tan`, `sec`, `cosec`, `cotan`, `sinh`, `cosh`, `tanh`, `sech`. `cosech`, and `cotanh`. These may all be used as functions with the `Math::Angle` object as argument, or as methods on the `Math::Angle` object.

It probably also leads to all sorts of other undesirable effects.

Functions
---------

The following standard trigonometric functions may be used to return a `Math::Angle` object: `asin`, `acos`, `atan`, `atan2`, `asec`, `acosec`, `acotan`, `asinh`, `acosh`, `atanh`, `asech`, `acosech`, and `acotanh`.

### from-dms

`from-dms` takes a string argument representing an angle in degrees, minutes and seconds, and converts it into a Math::Angle object.

The string contains:

  * **sign** An optional sign `+` or `-`;

  * **degrees** An optional decimal number of degrees followed by a degree designator (one of the degree symbol (`°`) or a letter `d` of either case);

  * **minutes** An optional decimal number of minutes followed by a minutes designator (one of a single quote (`'`), the Unicode character `U+2032`—`PRIME`, or the letter `m` in either case);

  * **seconds** An optional decimal number of seconds followed by a seconds designator (one of a double quote `"`), the Unicode character `U+2033`)—`DOUBLE PRIME`, or the letter `s` in either case);

  * **hemisphere** To allow for latitude and longitude to be represented easily, the angle can be followed by one of the letters `E`, `W`, `N` or `S` in either case. If the letter is `N` or `E` then the angle is positive; if it is `S` or `W` then the angle is negative. Note that if a sign is also present at the start of the string, then the two indicators are both used. Thus an angle like `-12°S` will end up being positive,

The various fields may be separated by white space.

The decimal numbers can be fractional, and contain exponents such as `12.53e5`.

Note that no sanity checks are made. An angle of "`-2473.2857° 372974.2746′ 17382.2948e5s W`" is acceptable, and equal to about `491531.046°`. The values for degrees, minutes and seconds are simply added together with the appropriate scaling and with the appropriate sign calculated from the initial sign and the hemisphere.

If the seconds are designated by the letter `S` and a hemisphere is also specified, then they must be separated by whitespace.

Alternative representations
---------------------------

Two methods are available to produce string output in useful forms for angles expressed in degrees.

### dms

Method `dms` will return a string containing a representation of the angle in degrees, minutes and seconds. For example:

```raku
Math::Angle.new(rad => 0.82).dms.say; # 46° 58′ 57.1411″
```

However the output is fairly configurable. For example, signed numbers can be output in various forms:

```raku
Math::Angle.new(rad => -0.82).dms.say; # -46° 58′ 57.1411″
Math::Angle.new(rad => 0.82).dms(presign=>"+-").say; # +46° 58′ 57.1411″
Math::Angle.new(rad => 0.82).dms(presign=>"", postsign=>"NS").say; # 46° 58′ 57.1411″N
Math::Angle.new(rad => -0.82).dms(presign=>"", postsign=>"NS").say; # 46° 58′ 57.1411″S
Math::Angle.new(rad => -0.82).dms(presign=>"", postsign=>"EW").say; # 46° 58′ 57.1411″W
```

The full set of options is:

<table class="pod-table">
<thead><tr>
<th>option</th> <th>meaning</th> <th>default</th>
</tr></thead>
<tbody>
<tr> <td>degsym</td> <td>A string representing the symbol printed after the number of degrees</td> <td>&quot;°&quot; (unicode U00B0 — DEGREE SIGN)</td> </tr> <tr> <td>minsym</td> <td>A string representing the symbol printed after the number of minutes</td> <td>&quot;′&quot; (unicode U2032 — PRIME)</td> </tr> <tr> <td>secsym</td> <td>(dms only) A string giving the symbol printed after the number of seconds</td> <td>&#39;″&#39; (unicode U2033 — DOUBLE PRIME)</td> </tr> <tr> <td>presign</td> <td>A string where the first chracter is printed before a positive number, and the second character is printed before a negative number</td> <td>&quot; -&quot; (a space and a minus sign)</td> </tr> <tr> <td>postsign</td> <td>A string where the first character is printed after a positive number, and the second character is printed after a negative number</td> <td>&quot; &quot; (two spaces)</td> </tr> <tr> <td>separator</td> <td>A string printed between the degrees and minutes, and between the minutes and seconds</td> <td>&quot; &quot;</td> </tr> <tr> <td>secfmt</td> <td>(dms only) The format string for the seconds field</td> <td>&quot;%.4f&quot;</td> </tr> <tr> <td>minfmt</td> <td>(dm only) The format string for the minutes field</td> <td>&quot;%.4f&quot;</td> </tr>
</tbody>
</table>

Note for `presign` and `postsign` that a blank in the string is not printed.

### dm

Method `dm` will return a string containing a representation of the angle in degrees and minutes. For example:

```raku
Math::Angle.new(rad => 0.82).dm.say; # 46° 58' 57.1411"
```

The same configurability as in `dms` is available:

```raku
Math::Angle.new(rad => -0.82).dm.say; # -46° 58.9524′
Math::Angle.new(rad => 0.82).dm(presign=>"+-").say; # +46° 58.9524′
Math::Angle.new(rad => 0.82).dm(presign=>"", postsign=>"NS").say; # 46° 58.9524'N
Math::Angle.new(rad => -0.82).dm(presign=>"", postsign=>"NS").say; # 46° 58.9524′S
Math::Angle.new(rad => -0.82).dm(presign=>"", postsign=>"EW").say; # 46° 58.9524′W
```

The options are the same as for dms, except that `secsig` is not available and `secfmt` is replaced by `minfmt`.

AUTHOR
======

Kevin Pye <kjpraku@pye.id.au>

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Kevin Pye

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

