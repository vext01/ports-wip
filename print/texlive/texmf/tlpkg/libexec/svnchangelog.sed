#! /bin/sed -nf
# $Id: svnchangelog.sed 12325 2009-03-06 19:20:00Z karl $
# Written by Werner Lemberg, 25may06.  Public domain.
# svn log outputs the paths first, then the log message.  This sed
# script reverses that.

:main
/------------------------------------------------------------------------/ {
  p
  n
  /r[0-9][0-9]* / {
    p
    n
    /^Changed paths:$/ {
      h
      n

      :loop1
      /^$/! {
        H
        n
        bloop1
      }

      :loop2
      /------------------------------------------------------------------------/! {
        p
        n
        bloop2
      }

      i\

      x
      p
      g
      bmain
    }
  }
  bmain
}

p
