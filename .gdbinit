echo \nReading ~/.gdbinit...\n\n
set print asm-demangle on

source ~/gdb/stl-views-1.0.3.gdb

set history size 9999999
set history filename ~/.gdbhistory
set history save on

define gdbkill
kill
end

define gdbquit
quit
end

set script-extension soft
source ~/gdb/rwtime.py

#echo Turning off listening for SIGUSR1...\n
#handle SIGUSR1 nostop


python
import sys
import os
import os.path as op
sys.path.insert(0, op.join(os.environ["HOME"], '/gdb/Boost-Pretty-Printer'))
from boost.printers import register_printer_gen
register_printer_gen(None)
end

#set scheduler-locking on
