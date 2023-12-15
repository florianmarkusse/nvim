define bsave
    shell rm -f brestore.txt
    set logging file brestore.txt
    set logging on
    info break
    set logging off
    # Reformat on-the-fly to a valid GDB command file
    shell perl -n -e 'print "break $1\n" if /^\d+.+?(\S+)$/g' brestore.txt > brestore.gdb
end
document bsave
  store actual breakpoints
end

define brestore
  source brestore.gdb
end
document brestore
  restore breakpoints saved by bsave
end
