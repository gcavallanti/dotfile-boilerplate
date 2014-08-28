#!/usr/bin/env bash
pathname="$_"

function xterm_to_rgb() 
{
    if (( $1 > 231 && $1 <256 ))
    then
        ((c = 8 + ($1 - 232) * 10))
        echo "$c $c $c"
        return 0
    elif (( $1 >15 && $1 < 232 ))
    then
        ((x = $1 - 16))

        ((b = x % 6))
        ((b = ($b > 0) * 55 + $b * 40))

        ((g = (x % 36) / 6))
        ((g = ($g > 0) * 55 + $g * 40))

        ((r = x / 36))
        ((r = ($r > 0) * 55 + $r * 40))
        echo "$r $g $b"
        return 0
    else 
        return 1
    fi
}
if [[ $pathname == $0 ]]
then
    # file is run in a subshell
    for i in {0..15} ; do
        printf "\x1b[48;5;${i}m  \x1b[38;5;16mtest  \x1b[38;5;255mtest  \x1b[49;38;5;${i}m xterm:${i}\n" 
    done
    for i in {16..255} ; do
        rgb=$(xterm_to_rgb i)
        printf "\x1b[48;5;${i}m  \x1b[38;5;16mtest  \x1b[38;5;255mtest  \x1b[49;38;5;${i}m xterm:${i} #%02x%02x%02x rgb(%d,%d,%d)\n" $rgb $rgb
    done
fi
