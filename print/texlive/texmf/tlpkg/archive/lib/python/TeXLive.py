#!/usr/bin/python2.4 -u
# TeXLive.py
# -*- encoding: utf-8 -*-
#  Usage:  call with argument of --help
# 2007-Aug-05 Jim Hefferon  ftpmaint@tug.ctan.org
"""Understand a TeX Live package and the associated dB file.

TeX Live has a format for metadata located in trunk/Master/tlpkg (for
the 'src' packages and documentation of the format) and
trunk/Master/texlive.tlpdb (see also -withctan ?).  This module reads the
two formats, can transform them by adding package documentation from the
ctanWeb database, and can write them back out. 

"""
__version__='1.0.0'
__author__='Jim Hefferon'
__date__='2007-Aug-05'
__notes__="""
Bugs:
1) Does not expand patterns for the src module, and does not
  redo the sizes, etc., for obj files.
2) You can't from the command line change the name of the db files.
3) This version for the TeX Live svn tree has the dB stripped out, so
  the option -a doesn't work, and the option -n has no effect.
"""

import os, os.path, sys
import re
import optparse
import codecs
import tempfile
import time
import pprint
import glob

## import library
## from util import *
## import dBUtils
## from defaults import DEFAULT_ENCODING, DEFAULT_DATABASE_ENCODING, DEBUG, LOGGING
DEFAULT_ENCODING='UTF-8'

TLPDB_FILENAME='/home/svn/texlive/trunk/Master/texlive.tlpdb'

THIS_SCRIPT=sys.argv[0]
DEBUG=True
LOGGING=True
LOGFILE_NAME=os.path.splitext(os.path.basename(THIS_SCRIPT))[0]+'.log'
VERBOSE=True

# What encoding for the terminal?
import locale
locale_language, locale_output_encoding = locale.getdefaultlocale()
if locale_output_encoding is None:
    locale_output_encoding='UTF-8'


#---------------------- stuff from util.py
import StringIO # for msg
import traceback # for msg
import logging  # for openLog, msg
import locale  # for warn messages
import types

import grp, pwd # get user name and group name

import pprint  # to make nice debugging structures

termEncoding='UTF-8'

class utilError(StandardError):
    pass

# Getting the string from the exception is a problem if you want unicode,
# since str() is no good for that, and I can't get err.message to work.
# I need the same functionality for my exceptions as for Python's so
# I wrap a call to err[0]
def errorValue(err):
    """Return the string error message from an exception.
      err  exception instance
    Note: I cannot get err.message to work.  I sent a note to clp on
    Jan 29 2007 with a related query and this is the best that I figured
    out.
    """
    try:
        return str(err)
    except:
        return err[0] # one of mine, in unicode

class jhError(StandardError):
    """Subclass this to get exceptions that behave correctly when
    you do this.
      try:
          raise subclassOfJhError, 'some error message with unicode chars'
      except subclassOfJhError, err
          mesg='the message is '+unicode(err)
    I don't believe that the built-in exceptions ever pass unicode so you can
    use unicode(err) on those also, I think, provided that you don't
    raise them yourself.
    """
    def __unicode__(self):
        return errorValue(self)

# You can use a string to set the level, or a constant from the logging
# module
_logLevels={'debug':logging.DEBUG,
            'info':logging.INFO,
            'warn':logging.WARN,
            'error':logging.ERROR,
            'critical':logging.CRITICAL,
            logging.DEBUG:logging.DEBUG,
            logging.INFO:logging.INFO,
            logging.WARN:logging.WARN,
            logging.WARN:logging.ERROR,
            logging.CRITICAL:logging.CRITICAL}


# openLog  Open a logging instance
def openLog(fn,name=None,purpose=None,format="%(levelname)s\t%(asctime)s: %(message)s",level=logging.DEBUG,announce=False):
    """Open an instance of the logging module.  Does not append to an old file;
    instead it makes a new one.
      fn  Name of the file.
      name=None  Name of the logging instance; if None then fn is used
      purpose=None  Name of calling program; if None then no head line on log
        file is written
      format='%(levelname)s %(asctime)s: %(message)s' Format for log file
        entries
      announce=False  Announce in log file that logging has started
    These are available for the format:
    %(name)s            Name of the logger (logging channel)
    %(levelno)s         Numeric logging level for the message (DEBUG, INFO,
                        WARN, ERROR, CRITICAL)
    %(levelname)s       Text logging level for the message ("DEBUG", "INFO",
                        "WARN", "ERROR", "CRITICAL")
    %(pathname)s        Full pathname of the source file where the logging
                        call was issued (if available)
    %(filename)s        Filename portion of pathname
    %(module)s          Module (name portion of filename)
    %(lineno)d          Source line number where the logging call was issued
                        (if available)
    %(created)f         Time when the LogRecord was created (time.time()
                        return value)
    %(asctime)s         Textual time when the LogRecord was created
    %(msecs)d           Millisecond portion of the creation time
    %(relativeCreated)d Time in milliseconds when the LogRecord was created,
                        relative to the time the logging module was loaded
                        (typically at application startup time)
    %(thread)d          Thread ID (if available)
    %(message)s         The result of record.getMessage(), computed just as
                        the record is emitted
    May raise a utilError.
    """
    if not(purpose is None): # write a header on the file, if it is new
        if not(os.path.isfile(fn)):
            try:
                f=open(fn,'w')
                f.write("# log file for %s\n" % (purpose,))
                f.close()
            except IOError, err:
                raise utilError, "Log file %s not present and unable to open and write to a new log file: %s" % (fn,errorValue(err))
    if name is None:
        log=logging.getLogger(fn)
    else:
        log=logging.getLogger(name)
    logger_formatter=logging.Formatter(format)
    try:
        logger_handler=logging.FileHandler(fn)
    except Exception, err:
        raise utilError, "Unable to associate a log with %s: %s" % (fn,errorValue(err))
    logger_handler.setFormatter(logger_formatter)
    log.addHandler(logger_handler)
    try:
        log.setLevel(_logLevels[level])
    except:
        raise utilError, "Unable to set level of the log"
    if announce:
        try:
            log.info("Logging started")
        except Exception, err:
            raise utilError, "Unable to initially write to the log with file name %s: %s" % (fn,errorValue(err))
    return log

# msg  return a message, for debugging, feedback to the user, etc., and
#  optionally log
def msg(m,devel=None,log=None,logLevel='debug',debug=False,**mDct):
    """Return a message.  Options allow it to be logged, or for a special
    debugging flag to be switched to give additional information
      m  The message returned.  Substitutions from the keyword arguments at end
      devel=None  String that will be used if the DEBUG flag is set for
        developer (and used for writing to the log).  If devel=None, then m
        is used.
      log  A logging object
      logLevel='debug'  One of 'debug', 'info', 'warn', 'error', 'critical',
         or logging.DEBUG, .. logging.CRITICAL
      debug=False  Boolean select which message m or mDevel is shown.
      **mDct  Keyword argument that are substituted into m and mDevel
    Note that if an exception is pending then a traceback gets printed to the
    log file.
    """
    # Indicate log level
    try:
        level=_logLevels[logLevel]
    except:
        raise utilError, "Unable to set level of the log to %s" % (repr(logLevel),)
    # The main part
    if devel is None:
        devel_str=m
    else:
        devel_str=devel
    #if log:
    #    log.debug("in msg: m=<%s>, devel_str=<%s>" % (m,devel_str))
    if log:
        (excClass,excObj,excTb)=sys.exc_info() # is there a pending exception? 
        if excClass: 
            tbStr=StringIO.StringIO()
            traceback.print_exc(None,tbStr)
            mDct['tB']=tbStr.getvalue().rstrip()
            log.log(level,(devel_str+"\n  %(tB)s") % mDct)
        else:
            log.log(level,devel_str % mDct)
    if debug:
        m=devel_str
    # expect that everybody needs to be encoded; print can't do characters numbered greater than 128
    for (k,v) in mDct.items():
        try:
            if not(isinstance(v,UnicodeType)):
                mDct[k]=unicode(v,termEncoding,'replace')
        except:
            try:
                mDct[k]=unicode(str(v),termEncoding,'replace')  #? has no unicode method, but has a str method?  Like StandardError?
            except:
                mDct[k]="Error in util.msg() -- string conversion to unicode impossible: %s" % (repr(v),) # give a message with some hint of what's gone wrong
    return m % mDct


DEFAULT_EXCEPTION=utilError
WARNINGS_WANTED=False  # sometimes, as for unit testing, nice to turn off
def noteException(m,devel=None,log=None,logLevel='error',exception=DEFAULT_EXCEPTION,debug=None,**mDct):
    """
    Raise an exception, and also, optionally, note it in a log file
      m  string  Error message for users; use '%(id)s'-style substitution
      devel=None  string  String for development; sub as in m. 
      log  Instance of logging module
      exception  An exception
      debug  Print the error to the stderr?
      **mDct  Additional keyword arguments; like 'id=7' will be subbed into
        m, devel
    Uses the msg function; will raise exception.
    """
    # print "util.py.noteException: m is: ",m," mDct is",pprint.pformat(mDct)
    if sys.exc_info()[0]: # if there is an active exception
        extraStr=" (exception is %s)" % (exceptionName(),)
        if devel is None:
            m+=extraStr
        else:
            devel+=extraStr
    r=msg(m,devel=devel,log=log,logLevel=logLevel,debug=debug,**mDct)
    if (debug
        and not(log)
        and WARNINGS_WANTED):
        warn(r,log=None,debug=debug) # print to stderr
    raise exception, r

def warn(s,leader='WARNING: ',log=None,debug=False,**mDct):
    """Send a message to stderr and possibly log it
      s  Message to report
      log=None  A logging object
      debug=False  Whether to report debugging information
    Warning!  You can't use leader, log, or debug as a key
    """
    # print >>sys.stderr, leader, msg(s,log=log,logLevel='error',debug=debug,**mDct).encode(locale.getdefaultlocale()[1])
    if not(isinstance(s,types.UnicodeType)):
        s=unicode(s,termEncoding,'replace')
    # print "in warn(): s=",s," and mDct.keys() is ",repr(mDct.keys()),"<<<<<==="
    print >>sys.stderr, leader, msg(s,log=log,logLevel='error',debug=debug,**mDct).encode(termEncoding)
    return None

def ann(s,log=None,debug=False,**mDct):
    """Issue a warning-like message without the 'WARNING' message.
      s  Message to report; may contain %(var)s as long as they are matched
        by var=var in the tailing arguments
      log=None,debug=False  debugging stuff
      **mDct  variables to substitute in s
    """
    return warn(s,leader='',log=log,debug=debug,**mDct)

def note(s,log,flag=os.environ.has_key('GATEWAY_INTERFACE'),leader="NOTE: "):
    """Take the message s and either log it or print it, depending
    on the flag.  The idea is to debug with note('informational message',log)
    and have it do the right thing, in a cgi context or not.
      s  message to use
      log  logging instance
      flag=os.environ.has_key('GATEWAY_INTERFACE') if True, use log.  If
        False, use stdout (default is True iff running as a CGI script)
    """
    # programming note:
    #  I've avoided too many options, such as potentially outputting
    # to stderr or using another log level; we'll see if simple works.
    if flag and log:
        log.info(s)
    else:
        warn(s,leader=leader,log=log)  # no debug because no devel string


def fail(s,returnCode=1,log=None,debug=False,**mDct):
    """Drop out, reporting a return code, and possibly logging a message
      s  Message to report
      returnCode=1  return code
      log=None  A logging object
      debug=False  Whether to report debugging information
    Warning!  You can't use returnCode, leader, log, or debug as a key
    """
    warn(s,leader='ERROR: ',log=log,debug=debug,**mDct)
    sys.exit(returnCode)

# exceptionName: get the name of the raised exception
# for use as:
#  try:
#     ..
#  except specificError, err:
#    ..
#  except Exception, err:
#    eN=exceptionName()
#    print "exception was",eN
#
def exceptionName():
    """Get the name of the currently raised exception.
    """
    fullName=sys.exc_info()[0]  # looks like "'exceptions.AttributeError'"
    if fullName is None:
        return 'No exception' # return rather than None, as I don't expect it to happen, and I don't want the failure if it is None
    else:
        return str(fullName).split('.')[-1]
#----------------------------------------

#-------------------------------stuff from dButils.py
## import psycopg2, psycopg2.extensions

## DEFAULT_DBCONNECTION_STRING="user=hefferon dbname=ctan password=Gd6eBitK55y"
## DEFAULT_DATABASE_ENCODING='UTF-8'

## dBConnectionString=DEFAULT_DBCONNECTION_STRING  # can be force-changed for debugging

## class dBUtilsError(StandardError):
##     pass

## def opendB(connectionstring=dBConnectionString,log=None,debug=DEBUG,encoding=DEFAULT_DATABASE_ENCODING,utc=True):
##     """
##     Make a connection to the database; return the pair (connection, cursor).
##       connectionstring=dBConnectionstring  string  See doc for psycopg
##       log=None  logging object
##       debug=DEBUG  Whether to output extra information
##       encoding='UNICODE'  What to set the client encoding to (default is utf-8)
##       utc=True  Set time zone to utc (alternative is local time)
##     May raise a dBUtilsError.
##     """
##     if encoding.upper()=='UTF-8':
##         encoding='UNICODE'  # postgres's name for UTF-8
##     if not(encoding in psycopg2.extensions.encodings.keys()):
##         mesg=u'Unable to make a database connection'
##         noteException(mesg,devel=mesg+" using connection string %(connectionstring)s because the called-for encoding %(encoding)s is not one known to psycopg2",log=log,exception=dBUtilsError,debug=debug,connectionstring=connectionstring,encoding=encoding)
##     try:
##         dBcnx = psycopg2.connect(connectionstring)
##         # dBcnx.set_client_encoding(encoding) # causes a failure JH 05-10-12
##         dBcsr = dBcnx.cursor()
##         if utc:
##             dBcsr.execute("SET TIME ZONE 'UTC'")
##         dBcsr.execute("SET client_encoding TO "+encoding)
##         if encoding=='UNICODE':  # any way to systematize this code?
##             psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
##         elif encoding=='LATIN1':
##             psycopg2.extensions.register_type(psycopg2.extensions.LATIN1)
##         elif encoding=='SQL_ASCII':
##             psycopg2.extensions.register_type(psycopg2.extensions.SQL_ASCII)
##         elif encoding=='latin-1':
##             psycopg2.extensions.register_type(psycopg2.extensions.LATIN1)
##     except psycopg2.DatabaseError, err:
##         mesg=u'Unable to connect to the database'
##         noteException(mesg,devel=mesg+" using connection string %(connectionstring)s: %(err)s",log=log,exception=dBUtilsError,debug=debug,connectionstring=connectionstring,err=err)
##     except Exception, err:
##         eN=exceptionName()
##         mesg=u'Unable to connect to the database'
##         noteException(mesg,devel=mesg+" (exception: %(eN)s) using connection string %(connectionstring)s: %(err)s",log=log,exception=dBUtilsError,debug=debug,eN=eN,connectionstring=connectionstring,err=err)
##     return (dBcnx,dBcsr)

## def getData(sql,dct={},dBcsr=None,selectOne=False,log=None,debug=DEBUG,listtype='list from the database'):
##     """
##     Get data out of the database, returning a list of lists
##       sql  SQL statement; typically a SELECT statement
##       dct={}  Dictionary of substitutions into SQL statement (unicode strings
##         are encoded according to the encoding)
##       dBcsr=None  database cursor. If None, one will be generated
##       log=None  Instance of logging object
##       selectOne=False  With a dB result, issue a fetchone() or a fetchall()?
##       debug=DEBUG  Whether to include debugging information
##       listtype  Phrase for use in error messages
##     Psycopg2 will handle conversion of unicode strings.
##     """
##     if not(dBcsr):  # sanity check
##         mesg=u'Error getting access to the database'
##         noteException(mesg,devel=mesg+": no database cursor, while getting a %(listtype)s",log=log,exception=dBUtilsError,debug=debug,listtype=listtype)
##     try:
##         dBcsr.execute(sql,dct)
##         if selectOne:
##             dBres=dBcsr.fetchone()
##             if dBres is None:
##                 lst=[]  # an empty list so always yield a sequence
##             else:
##                 lst=dBres   # one tuple
##         else:
##             lst=dBcsr.fetchall()  # a list with possibly many tuples
##     except psycopg2.DatabaseError, err:
##         mesg=u'Database operation error fetching a %(listtype)s'
##         noteException(mesg,devel=mesg+" with query "+dBcsr.query+": %(err)s -- "+dBcsr.statusmessage,log=log,exception=dBUtilsError,debug=debug,listtype=listtype,sql=sql,dct=repr(dct),err=err)
##     except Exception, err:
##         eN=exceptionName()
##         noteException("Database error (unknown kind) fetching a %(listtype)s",devel="Database error (exception %(eN)s) fetching a %(listtype)s with sql='%(sql)s' and dct=%(dct)s: %(err)s",log=log,exception=dBUtilsError,debug=debug,listtype=listtype,eN=eN,err=err)
##     return lst

## def putData(sql,dct={},dBcsr=None,log=None,encoding=DEFAULT_DATABASE_ENCODING,debug=DEBUG,listtype='list to the database'):
##     """
##     Put data into the database, encoding unicode strings on their way in
##       sql  SQL statement; should be an INSERT or an UPDATE
##       dct={}  Dictionary of substitutions into SQL statement (unicode strings
##         are encoded according to the encoding)
##       dBcsr=None  database cursor. If None, one will be generated
##       log=None  Instance of logging object
##       encoding=DEFAULT_DATABASE_ENCODING  Unicode encoding to use for the
##         database
##       debug=DEBUG  Whether to include debugging information
##       listtype  Phrase for use in error messages
##     Does *not* do a dBcsr.commit().
##     """
##     if not(dBcsr):  # sanity check
##         mesg=u'Error accessing the database'
##         noteException(mesg,devel=mesg+" while putting a %(listtype)s: no database cursor",log=log,exception=dBUtilsError,debug=debug,listtype=listtype)
##     try:
##         dBcsr.execute(sql,dct)
##     except (psycopg2.DatabaseError,psycopg2.ProgrammingError), err:
##         eN=exceptionName()
##         mesg=u'Database operation error'
##         noteException(mesg,devel=mesg+" (exception %(eN)s) %(err)s while putting a %(listtype)s with query="+dBcsr.query+": %(err)s -- "+dBcsr.statusmessage,log=log,exception=dBUtilsError,debug=debug,listtype=listtype,eN=eN,err=err)
##     except Exception, err:
##         eN=exceptionName()
##         mesg=u'Database operation error'
##         noteException(mesg,devel=mesg+" (exception %(eN)s) %(err)s while putting a %(listtype)s",log=log,exception=dBUtilsError,debug=debug,eN=eN,err=str(err),listtype=listtype)
##     return None

#-------------------------------------------------

class tlError(jhError):
    pass

tlobjKeys=set(['name','category','catalogue','shortdesc','longdesc','depend','execute','revision','srcsize','srcfiles','docsize','docfiles','runsize','runfiles','binsize','binfiles','cataloguedata','srcpattern','runpattern','docpattern','binpattern'])

class tlp(object):
    """Give information based on a TeXLive object file
    """
    def __init__(self,verbose=False,log=None,debug=False):
        """Initialize an object.
        """
        self.verbose=verbose
        self.log=log
        self.debug=debug
        self.name=None   # string  id of package
        self.category=None # string   category into which package falls 
        self.catalogue=None # string  id of associated Catalogue package
        self.shortdesc=None # string  one-liner
        self.longdesc=None # string  may have newlines
        self.depend=None  # list  of the form Category/Name
        self.execute=None # list  free-form strings
        return None

    def __unicode__(self):
        r=[]
        r.append("name: %s" % (pprint.pformat(self.name),))
        r.append("  category: %s" % (pprint.pformat(self.category),))
        r.append("  catalogue: %s" % (pprint.pformat(self.catalogue),))
        r.append("  shortdesc: %s" % (pprint.pformat(self.shortdesc),))
        r.append("  longdesc: %s" % (pprint.pformat(self.longdesc),))
        r.append("  depend: %s" % (pprint.pformat(self.depend),))
        r.append("  execute: %s" % (pprint.pformat(self.execute),))
        return "\n".join(r)

    def writeout(self,fn=None):
        """Write a textual representation
          fn=None  file name; if None use sys.stdout
        """
        if fn is None:
            f=sys.stdout
            if f.encoding!=DEFAULT_ENCODING:
                warn('using STDOUT but the encoding is %(fEncoding)s and not the expected %(defaultEncoding)s',log=self.log,debug=self.debug,fEncoding=repr(f.encoding),defaultEncoding=repr(DEFAULT_ENCODING))
        else:
            if self.debug:
                errors='strict'
            else:
                errors='replace'
            try:
                f=codecs.open(fn,'w',DEFAULT_ENCODING,errors)
            except Exception, err:
                mesg='unable to open the file for writing'
                noteException(mesg,devel=mesg+' %(fn)s: %(err)s',exception=tlError,log=log,debug=self.debug,fn=repr(fn),err=unicode(err))
        self.writeout_fh(f)
        f.close()
        return None

    def _stringToWriteout(self):
        """String that will be written out during writeout_fh
        """
        r=[]
        r.append("name %s" % (self.name,))
        if self.category:
            r.append("category %s" % (self.category,))
        if self.shortdesc:
            r.append("shortdesc %s" % (self.shortdesc,))
        if self.longdesc:
            for line in self.longdesc.split("\n"): 
                r.append("longdesc %s" % (line,))
        if self.depend:
            for line in self.depend:
                r.append("depend %s" % (line,))
        if self.execute:
            for line in self.execute:
                r.append("execute %s" % (line,))
        return "\n".join(r)

    def writeout_fh(self,f):
        """Write a string representation of the user variables to the
        filehandle.
          f  filehandle
        """
        s=self._stringToWriteout()
        f.write(s)
        return None

    def get_associated_cat_ids(self,dBcsr,log=None,debug=False):
        """Return the matching catalogue ids
        """
        sql="""SELECT pkg_id FROM tl_cat
                 WHERE tl_id=%(tlId)s
                 AND pkg_id IS NOT NULL"""
        dct={'tlId':self.name}
        try:
            dBres=dBUtils.getData(sql,dct=dct,dBcsr=dBcsr,log=log,debug=debug,listtype='get catalogue package ids related to this TeX Live package id')
        except dBUtils.dBUtilsError, err:
            mesg=u'unable to get texlive-catalogue packages record'
            noteException(mesg,devel=mesg+' for TeX Live package %(tlId)s: %(err)s',exception=tlError,log=log,debug=debug,tlId=repr(tlId),err=errorValue(err))
        return [catId for (catId,) in dBres]

    def add_cat_desc(self,dBcsr,catId=None,log=None,debug=False):
        """If there is not now a description, and there is a matching
        Catalogue package, add its descriptions.  (Also sets the catalogue
        variable)
          dBcsr  database cursor
          catId=None  string or None  if present, the name of the Catalogue
            package whose descriptions will be added.
          log=None,debug=False  debugging
        """
        if not(catId):
            catIds=self.get_associated_cat_ids(dBcsr,log=log,debug=debug)
            if len(catIds)==1:
                catId=catIds[0]
        if not(catId):
            return False
        sql="""SELECT caption, description FROM pkg_text
                 WHERE id=%(catId)s
                 AND iso_code='en'"""
        dct={'catId':catId}
        try:
            dBres=dBUtils.getData(sql,dct=dct,dBcsr=dBcsr,log=log,debug=debug,listtype='get catalogue descriptions related to this TeX Live package id')
        except dBUtils.dBUtilsError, err:
            mesg=u'unable to get catalogue package descriptions for this TeX Live package'
            noteException(mesg,devel=mesg+' for TeX Live package %(tlId)s and catalogue id %(catId)s: %(err)s',exception=tlError,log=log,debug=debug,tlId=repr(tlId),catId=repr(catId),err=errorValue(err))
        res=dBres[0]
        if res:
            (catCaption,catDesc)=dBres[0]
            if (not(self.shortdesc)
                and not(self.longdesc)):
                self.catalogue=catId
                self.shortdesc=catCaption
                self.longdesc=catDesc
        return True

    def from_file(self,fn=None,multi=False):
        """Read a tlp object from a file.
          fn=None  string  file name or None, which means sys.stdin
          multi=False  boolean  whether to allow multiple pkgs in a file
        """
        if fn is None:
            f=sys.stdin
            if f.encoding!=DEFAULT_ENCODING:
                warn('using STDIN but the encoding is %(fEncoding)s and not the expected %(defaultEncoding)s',log=self.log,debug=self.debug,fEncoding=repr(f.encoding),defaultEncoding=repr(DEFAULT_ENCODING))
        else:
            try:
                if self.debug:
                    errors='strict'
                else:
                    errors='replace'
                f=codecs.open(fn,'rU',DEFAULT_ENCODING,errors)
            except Exception, err:
                mesg='unable to open file for reading'
                noteException(mesg,devel=mesg+' %(fn)s: %(err)s',exception=tlError,log=log,debug=self.debug,fn=repr(fn),err=unicode(err))
        r=self.from_fh(f,multi=multi,lineNo=0)
        return None

    initialState='init'
    keyValueStates=tlobjKeys # line of form "key value"
    filePathStates=set(['srcfiles_file','runfiles_file','docfiles_file','binfiles_file'])  # line contains file path indented by space
    nextStates={initialState:tlobjKeys,
                'name':keyValueStates-set(['name']),
                'category':keyValueStates-set(['category']),
                'catalogue':keyValueStates-set(['catalogue']),
                'shortdesc':keyValueStates-set(['shortdesc']),
                'longdesc':keyValueStates,
                'depend':keyValueStates,
                'execute':keyValueStates}
    def from_fh(self,f,multi=None,lineNo=0):
        """Read tlp information from a file handle.  Returns None if EOF is
        read before anything is found.  Note that files have been opened
        with codecs.open() (except for stdin)
          f  an opened file
          multi=None  If not None then multiple tplobj's in the file are
            treated as an error
          lineNo=0  debugging
        May raise tlError.
        """
        # Implementation note: I am putting the full parsing routine in
        # this base class, except for some "handle" routines, to allow
        # me to have the handle routines report error messages in the
        # tplobj and tplsrc classes.
        state=self.initialState
        # Look for blank lines that are delimeters between tlp parts
        anyNonblankLinesRead=False
        while True:
            line=f.readline()
            if not(line):  # EOF?
                return False
            lineNo+=1
            if self.debug and self.verbose:
                note('line is '+repr(line),self.log)
            line=line.rstrip()
            if not(anyNonblankLinesRead):
                if (not(line)
                    or line[0]=='#'): # toss initial blank lines or comments
                    continue
                else:
                    anyNonblankLinesRead=True
            elif not(line):
                if multi is None:
                    mesg=u'unexpected multiple tpl objects'
                    noteException(mesg,devel=mesg+'; trailing blank line found at line %(lineNo)s',exception=tlError,log=self.log,debug=self.debug,lineNo=repr(lineNo))
                else:
                    return self
            # Get the next state (the key) and the part of the line after key.
            # The "srcfiles", etc., states need special handling as they
            # put the reader in a position where the first thing on the line
            # is not the next state.
            restOfLine=""
            if line[0]==' ':
                if (state=='srcfiles'
                    or state=='srcfiles_file'):
                    newState='srcfiles_file'
                    restOfLine=line[1:]
                elif (state=='runfiles'
                      or state=='runfiles_file'):
                    newState='runfiles_file'
                    restOfLine=line[1:]
                elif (state=='docfiles'
                      or state=='docfiles_file'):
                    newState='docfiles_file'
                    restOfLine=line[1:]
                elif (state=='binfiles'
                      or state=='binfiles_file'):
                    newState='binfiles_file'
                    restOfLine=line[1:]
            else:
                try:
                    fields=line.split()
                    newState=fields[0].lower()
                    restOfLine=line[len(newState):] # can't lstrip() if it is longdesc
                except:
                    mesg=u'no key in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; while in state %(state)s unable to get the new state for line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),state=repr(state))
            # Reject illegal newState's
            if not(newState=='binfiles_file'):
                self.currentArch=None
            if not(newState in self.nextStates[state]):
                # print"newState",repr(newState),"state",repr(state),'self.nextStates[state]=',repr(self.nextStates[state])," type",repr(type(self.nextStates[state]))
                mesg=u'unable to transition to the next state in line number=%(lineNo)s'
                noteException(mesg,devel=mesg+'; while in state %(state)s the next state %(newState)s is not legal in line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),state=repr(state),newState=repr(newState))
            # Main part of routine: handle the line depending on the newState.
            # if self.debug:
            #     print "newState is ",repr(newState)," line is ",repr(line)
            if newState==self.initialState:
                mesg=u'unexpected initial state in line=%(lineNo)s'
                noteException(mesg,devel=mesg+'; while in state %(state)s now in initial state reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),state=repr(state))
            if newState=='name':
                try:
                    fields=restOfLine.strip().split()
                    self.name=fields[0]
                    if self.debug:
                        note("package name is "+repr(self.name),self.log)
                except Exception, err:
                    mesg=u'no "value" text in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s: %(err)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState),err=errorValue(err))
            elif newState=='category':
                try:
                    fields=restOfLine.strip().split()
                    self.category=fields[0]
                except:
                    mesg=u'no "value" text in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
            elif newState=='catalogue':
                try:
                    fields=restOfLine.strip().split()
                    self.catalogue=fields[0]
                except:
                    mesg=u'no "value" text in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
            elif newState=='shortdesc':
                try:
                    # I'll allow multiline shortdesc's, although I'll regret it
                    if self.shortdesc is None:
                        self.shortdesc=""
                    if self.shortdesc:
                        self.shortdesc+=' '
                    self.shortdesc+=restOfLine
                except:
                    mesg=u'no value in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
            elif newState=='longdesc':
                try:
                    if self.longdesc is None:
                        self.longdesc=""
                    if self.longdesc:
                        self.longdesc+="\n"
                    self.longdesc+=restOfLine
                except Exception, err:
                    mesg=u'no value in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s: %(err)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState),err=errorValuse(err))
            elif newState=='depend':
                fields=restOfLine.strip().split()
                if len(fields)>0:
                    if self.depend is None:
                        self.depend=[]
                    self.depend.append(restOfLine.strip())
                else:
                    mesg=u'no value in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
            elif newState=='execute':
                fields=restOfLine.strip().split()
                if len(fields)>0:
                    if self.execute is None:
                        self.execute=[]
                    self.execute.append(restOfLine.strip())
                else:
                    mesg=u'no value in line number=%(lineNo)s'
                    noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
            elif newState=='revision':
                self.handleRevision(newState,restOfLine,line,lineNo)
            elif newState=='srcfiles':
                self.handleSrcfiles(newState,restOfLine,line,lineNo)
            elif newState=='srcfiles_file':
                self.handleSrcfilesFile(newState,restOfLine,line,lineNo)
            elif newState=='docfiles':
                self.handleDocfiles(newState,restOfLine,line,lineNo)
            elif newState=='docfiles_file':
                self.handleDocfilesFile(newState,restOfLine,line,lineNo)
            elif newState=='runfiles':
                self.handleRunfiles(newState,restOfLine,line,lineNo)
            elif newState=='runfiles_file':
                self.handleRunfilesFile(newState,restOfLine,line,lineNo)
            elif newState=='binfiles':
                self.handleBinfiles(newState,restOfLine,line,lineNo)
            elif newState=='binfiles_file':
                self.handleBinfilesFile(newState,restOfLine,line,lineNo)
            elif newState=='srcpattern':
                self.handleSrcpattern(newState,restOfLine,line,lineNo)
            elif newState=='runpattern':
                self.handleRunpattern(newState,restOfLine,line,lineNo)
            elif newState=='docpattern':
                self.handleDocpattern(newState,restOfLine,line,lineNo)
            elif newState=='binpattern':
                self.handleBinpattern(newState,restOfLine,line,lineNo)
            elif newState.startswith('cataloguedata-'):
                self.handleCataloguedata(newState,restOfLine,line,lineNo)
            else:
                mesg=u'unknown key in line number=%(lineNo)s'
                noteException(mesg,devel=mesg+'; key is %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=repr(lineNo),line=repr(line),newState=repr(newState))
            # Cycle back to read next line
            state=newState
        return True

    def handleRevision(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'revision'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleSrcfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'srcfiles'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleSrcfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'srcfiles_file'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleDocfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'docfiles'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleDocfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'docfiles_file'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleRunfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'runfiles'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleRunfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'runfiles_file'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleBinfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'binfiles'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleBinfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'binfiles_file'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleSrcpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'srcpattern'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleRunpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'runpattern'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleDocpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'docpattern'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleBinpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'binpattern'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None
    def handleCataloguedata(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'cataloguedata-xxx'
        """
        mesg=u'the new state is not allowed here, line number=%(lineNo)s'
        noteException(mesg,devel=mesg+"; this object %(objName) cannot be in the state %(newState)s: line=%(line)s",exception=tlError,log=self.log,debug=self.debug,objName=repr(self.__class__.__name__),newState=repr(newState),lineNo=repr(lineNo),line=repr(line))
        return None


class tlp_db(object):
    """Give information based on a tl file database.  This class exists
    for tlpobj_db and tlpsrc_db to inherit from
    """
    def __init__(self,verbose=False,log=None,debug=False):
        """Initialize an instance.
        """
        self.verbose=verbose
        self.log=log
        self.debug=debug
        self.value={}  # map name --> tl pkg
        return None

    def __unicode__(self):
        names=self.value.keys()
        names.sort()
        return u" ".join(names)

    def get_package(self,name):
        try:
            return self.value[name]
        except:
            return None

    def _makeSingle(self):
        """Helper fcn to make one of whatever self.value is holding multiple
        of.  Used in from_file.
        """
        return tlp(log=self.log,debug=self.debug)
    
    def from_file(self,fn=None,multi=True):
        """Read a tlp db file.  Set self.value.
        """
        if fn is None:
            f=sys.stdin
            if f.encoding!=DEFAULT_ENCODING:
                warn('using STDIN but the encoding is %(fEncoding)s and not the expected %(defaultEncoding)s',log=self.log,debug=self.debug,fEncoding=repr(f.encoding),defaultEncoding=repr(DEFAULT_ENCODING))
        else:
            if self.debug:
                errors='strict'
            else:
                errors='replace'
            try:
                f=codecs.open(fn,'rU',DEFAULT_ENCODING,errors)
            except Exception, err:
                mesg='unable to open tlpobj file'
                noteException(mesg,devel=mesg+' %(fn)s: %(err)s',exception=tlError,log=log,debug=self.debug,fn=repr(fn),err=unicode(err))
        r=self._makeSingle()
        retVal=r.from_fh(f,multi=multi,lineNo=0)
        self.value[r.name]=r
        while retVal:
            r=self._makeSingle()
            retVal=r.from_fh(f,multi=multi,lineNo=0)
            self.value[r.name]=r
        return None

    def write_file(self,fn=None):
        if fn is None:
            f=sys.stdout
            if f.encoding!=DEFAULT_ENCODING:
                warn('using STDOUT but the encoding is %(fEncoding)s and not the expected %(defaultEncoding)s',log=self.log,debug=self.debug,fEncoding=repr(f.encoding),defaultEncoding=repr(DEFAULT_ENCODING))
        else:
            if self.debug:
                errors='strict'
            else:
                errors='replace'
            try:
                f=codecs.open(fn,'w',DEFAULT_ENCODING,errors)
            except Exception, err:
                mesg=u'unable to write because unable to open the file'
                noteException(mesg,devel=mesg+': %(err)s',exception=tlError,log=self.log,debug=self.debug,err=errorValue(err))
        pkgNames=self.value.keys()
        pkgNames.sort()
        pkgNo=1
        for k in pkgNames:
            v=self.value[k]
            v.writeout_fh(f)
            f.write("\n")
            if pkgNo<len(pkgNames): # keep off extra \n after end
                f.write("\n")
            pkgNo+=1
        f.close()
        return None

    def add_cat_descs(self,dBcsr):
        """Add catalogue descriptions to all matching TL packages that do not
        already have a description.
        """
        pkgNames=self.value.keys()
        pkgNames.sort()
        for k in pkgNames:
            self.value[k].add_cat_desc(dBcsr,log=self.log,debug=self.debug)
        return None
    


class tlpobj(tlp):
    """Give information based on a TeXLive object file
    """
    def __init__(self,verbose=False,log=None,debug=False):
        """Initialize an object.
        """
        super(tlpobj,self).__init__(verbose=verbose,log=log,debug=debug)
        self.revision=None # integer
        self.srcfiles=None # list of files
        self.runfiles=None # list of files
        self.docfiles=None # dct fileName--> (dct tagkey --> tagval)
        self.binfiles=None # arch --> list of files
        self.srcsize=None # int (or None)
        self.runsize=None # int (or None)
        self.docsize=None # int (or None)
        self.binsize=None  # arch --> size  (or None)
        self.cataloguedata=None # cataloguekey --> value
        return None

    def __unicode__(self):
        r=[]
        r.append(super(tlpobj,self).__unicode__())
        r.append("  revision: %s" % (pprint.pformat(self.revision),))
        r.append("  srcsize: %s" % (pprint.pformat(self.srcsize),))
        r.append("  srcfiles: %s" % (pprint.pformat(self.srcfiles),))
        r.append("  docsize: %s" % (pprint.pformat(self.docsize),))
        r.append("  docfiles: %s" % (pprint.pformat(self.docfiles),))
        r.append("  runsize: %s" % (pprint.pformat(self.runsize),))
        r.append("  runfiles: %s" % (pprint.pformat(self.runfiles),))
        r.append("  binsize: %s" % (pprint.pformat(self.binsize),))
        r.append("  binfiles: %s" % (pprint.pformat(self.binfiles),))
        r.append("  cataloguedata: %s" % (pprint.pformat(self.cataloguedata),))
        return "\n".join(r)

    def _stringToWriteout(self):
        """String that will be written out during writeout_fh
        """
        r=[]
        r.append(super(tlpobj,self)._stringToWriteout())
        if self.revision:
            r.append("revision %s" % (self.revision,))
        if self.docfiles:
            if self.docsize is None:
                mesg='docsize is not there but there are docfiles'
                noteException(mesg,devel=mesg,exception=tlError,log=self.log,debug=self.debug)
            r.append("docfiles size=%s" % (self.docsize,))
            dFiles=self.docfiles.keys()
            dFiles.sort()
            for line in dFiles:
                s=[]
                for (k,v) in self.docfiles[line].items():
                    s.append("%s=%s" % (k,v))
                dLine=" "+line
                if s:
                    dLine+=" "+(" ".join(s))
                r.append(dLine)
        if self.srcfiles:
            if self.srcsize is None:
                mesg='srcsize is not there but there are srcfiles'
                noteException(mesg,devel=mesg,exception=tlError,log=self.log,debug=self.debug)
            r.append("srcfiles size=%s" % (self.srcsize,))
            self.srcfiles.sort()
            for line in self.srcfiles:
                r.append(" "+line)
        if self.runfiles:
            if self.runsize is None:
                mesg='runsize is not there but there are runfiles'
                noteException(mesg,devel=mesg,exception=tlError,log=self.log,debug=self.debug)
            r.append("runfiles size=%s" % (self.runsize,))
            self.runfiles.sort()
            for line in self.runfiles:
                r.append(" "+line)
        if self.binfiles:
            arches=self.binfiles.keys()
            arches.sort()
            for arch in arches:
                if self.binsize[arch] is None:
                    mesg='binsize is not there but there are binfiles'
                    noteException(mesg,devel=mesg+" for %(arch)s",exception=tlError,log=self.log,debug=self.debug,arch=repr(arch))
                r.append("binfiles arch=%s size=%s" % (arch,self.binsize[arch],))
                sBinfiles=self.binfiles[arch]
                sBinfiles.sort()
                for line in sBinfiles:
                    r.append(" "+line)
        if self.cataloguedata:
            cdKeys=self.cataloguedata.keys()
            for k in cdKeys:
                r.append("catalogue-%s %s" % (k,self.cataloguedata[k]))
        return "\n".join(r)

##     def to_db(self,dBcsr,dBcnx,careful=True,associatedCatPkgs=None,verbose=False):
##         """Put the yyy-file information to a database
##           dBcsr, dBcnx  database cursor and connection
##           careful=True  raise exception on error?
##           associatedCatPkgs=None  list of catalogue package id's that either 
##             are part of this texlive package of of which this texlive package
##             is a part (None is the same as using what is now in the dB)
##           verbose=False  Give warnings
##         """
##         tlId=self.name
##         # Drop the file records if they are there
##         sql="DELETE FROM tds_files WHERE tl_id=%(tlId)s"
##         dct={'tlId':tlId}
##         try:
##             dBUtils.putData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='drop old texlive files record')
##         except dBUtils.dBUtilsError, err:
##             mesg=u'unable to drop existing tds files record'
##             noteException(mesg,devel=mesg+' for package %(pkgId)s: %(err)s',log=self.log,debug=self.debug,pkgId=repr(pkgId),err=errorValue(err))
##         # Do the tl_cat records; see which ones to do
##         if associatedCatPkgs is None:
##             sql="SELECT pkg_id FROM tl_cat WHERE tl_id=%(tlId)s"
##             dct['tlId']=tlId
##             try:
##                 dBres=dBUtils.getData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='get list of catalogue packages for this texlive package')
##             except dBUtils.dBUtilsError, err:
##                 mesg=u'unable to get list of catalogue packages for this texlive packages '
##                 noteException(mesg,devel=mesg+'%(tlId)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),err=errorValue(err))
##             associatedCatPkgs=[a for (a,) in dBres]
##             if not(associatedCatPkgs): # try tlId
##                 possiblePkgId=tlId.lower()
##                 sql="SELECT id FROM package WHERE id=%(pkgId)s"
##                 dct['pkgId']=possiblePkgId
##                 try:
##                     dBres=dBUtils.getData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='check for existence of a catalogue id')
##                 except dBUtils.dBUtilsError, err:
##                     mesg=u'unable to check for existence of a catalogue id'
##                     noteException(mesg,devel=mesg+'%(pkgId)s: %(err)s',log=self.log,debug=self.debug,pkgId=repr(possiblePkgId),err=errorValue(err))
##                 if dBres:
##                     associatedCatPkgs.append(possiblePkgId)
##         # drop any that are there now
##         sql="DELETE FROM tl_cat WHERE tl_id=%(tlId)s"
##         dct={'tlId':tlId}
##         try:
##             dBUtils.putData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='drop old texlive package-catalogue package association')
##         except dBUtils.dBUtilsError, err:
##             mesg=u'unable to drop existing texlive package record'
##             noteException(mesg,devel=mesg+' for package %(tlId)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),err=errorValue(err))
##         # Drop the tl records if they are there
##         sql="DELETE FROM tl WHERE tl_id=%(tlId)s"
##         dct={'tlId':tlId}
##         try:
##             dBUtils.putData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='drop old texlive package record')
##         except dBUtils.dBUtilsError, err:
##             mesg=u'unable to drop existing texlive package record'
##             noteException(mesg,devel=mesg+' for package %(tlId)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),err=errorValue(err))
##         # Insert new tl record
##         sql="INSERT INTO tl (tl_id,shortdesc,longdesc) VALUES (%(tlId)s,%(shortdesc)s,%(longdesc)s)"
##         dct['shortdesc']=self.shortdesc
##         dct['longdesc']=self.longdesc
##         try:
##             dBUtils.putData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='insert new texlive package record')
##         except dBUtils.dBUtilsError, err:
##             mesg=u'unable to insert new texlive package record'
##             noteException(mesg,devel=mesg+' for package %(tlId)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),err=errorValue(err))
##         # insert new tl_cat records
##         if not(tlId.startswith('bin-')
##                or tlId.startswith('collection-')
##                or tlId.startswith('hyphen-')
##                or tlId.startswith('lib-')
##                or tlId.startswith('scheme-')
##                or tlId.startswith('texlive-')):
##             if (not(associatedCatPkgs)
##                 and careful
##                 and verbose):
##                 mesg=u'there are no catalogue packages associated with the TeX Live package %(tlId)s'
##                 warn(mesg,log=self.log,debug=self.debug,tlId=repr(tlId))
##             for pkgId in associatedCatPkgs:
##                 sql="INSERT INTO tl_cat (tl_id,pkg_id) VALUES (%(tlId)s,%(pkgId)s)"
##                 dct['pkgId']=pkgId
##                 try:
##                     dBUtils.putData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='insert new tl_cat package record')
##                 except dBUtils.dBUtilsError, err:
##                     mesg=u'unable to insert new association between a texlive package and a catalogue package'
##                     noteException(mesg,devel=mesg+' for texlive package %(tlId)s and catalgoue package %(pkgId)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),pkgId=repr(pkgId),err=errorValue(err))
##         # Insert the file records
##         #   First build a list of pairs: (fileName,fileType)
##         fileList=[]
##         if self.srcfiles:
##             for fn in self.srcfiles:
##                 fileList.append((fn,'src'))
##         if self.runfiles:
##             for fn in self.runfiles:
##                 fileList.append((fn,'run'))
##         if self.docfiles:
##             for fn in self.docfiles.keys():
##                 fileList.append((fn,'doc'))
##         if self.binfiles:
##             for arch in self.binfiles.keys():
##                 for fn in self.binfiles[arch]:
##                     fileList.append((fn,'bin'))
##         #  .. then put the info in the dB
##         dct={'tlId':tlId}
##         for (fn,fileType) in fileList:
##             pathDir,pathBase=os.path.split(fn)
##             sql="INSERT INTO tds_files (tl_id,type,path_dir,path_base) VALUES (%(tlId)s,%(fileType)s,%(pathDir)s,%(pathBase)s)"
##             dct['fileType']=fileType
##             dct['pathDir']=pathDir
##             dct['pathBase']=pathBase
##             try:
##                 dBUtils.putData(sql,dct=dct,dBcsr=dBcsr,log=self.log,debug=self.debug,listtype='insert new texlive files record')
##             except dBUtils.dBUtilsError, err:
##                 mesg=u'unable to insert new tds files record'
##                 noteException(mesg,devel=mesg+' for package %(tlId)s with type=%(fileType)s, pathDir=%(pathDir)s, pathBase=%(pathBase)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),fileType=repr(fileType),pathDir=repr(pathDir),pathBase=repr(pathBase),err=errorValue(err))
##         # Commit
##         try:
##             dBcnx.commit()
##         except Exception, err:
##             mesg=u'unable to commit the insert of the new tds files record'
##             noteException(mesg,devel=mesg+' for package %(pkgId)s: %(err)s',log=self.log,debug=self.debug,tlId=repr(tlId),err=errorValue(err))
##         return None

    initialState=tlp.initialState
    nextStates=tlp.nextStates
    nextStates['revision']=tlp.keyValueStates-set(['revision'])
    nextStates['srcfiles']=tlp.keyValueStates | set(['srcfiles_file'])-set(['srcfiles'])
    nextStates['srcfiles_file']=tlp.keyValueStates | set(['srcfiles_file'])
    nextStates['runfiles']=tlp.keyValueStates | set(['runfiles_file'])-set(['runfiles'])
    nextStates['runfiles_file']=tlp.keyValueStates | set(['runfiles_file'])
    nextStates['docfiles']=tlp.keyValueStates | set(['docfiles_file'])-set(['docfiles'])
    nextStates['docfiles_file']=tlp.keyValueStates | set(['docfiles_file'])-set(['docfiles'])
    nextStates['binfiles']=tlp.keyValueStates | set(['binfiles_file'])
    nextStates['binfiles_file']=tlp.keyValueStates | set(['binfiles_file'])
    nextStates['cataloguedata']=tlp.keyValueStates

    def handleRevision(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'revision'
        """
        try:
            fields=restOfLine.strip().split()
            self.revision=int(fields[0])
        except:
            mesg=u'no "value" integer in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None

    def handleSrcfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'srcfiles'
        """
        try:
            fields=restOfLine.strip().split()
            sizeString=fields[0]
        except:
            mesg=u'no value in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        try:
            sizeFields=sizeString.split('=')
            if sizeFields[0].lower()!='size':
                raise tlError
            size=int(sizeFields[1])
            if self.srcsize is None:
                self.srcsize=0
            self.srcsize+=size
        except:
            mesg=u'expected a value of size=NNNNNN in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        if self.srcfiles is None:
            self.srcfiles=[]
        return None

    def handleSrcfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'srcfiles_file'
        """
        try:
            fields=restOfLine.strip().split() # recall that restOfLine=line[1:]
            self.srcfiles.append(fields[0])
        except:
            mesg=u'unable to understand source file name in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None

    def handleDocfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'docfiles'
        """
        try:
            fields=restOfLine.strip().split()
            sizeString=fields[0]
        except:
            mesg=u'no value in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        try:
            sizeFields=sizeString.split('=',1)
            if sizeFields[0].lower()!='size':
                raise tlError
            size=int(sizeFields[1])
            if self.docsize is None:
                self.docsize=0
            self.docsize+=size
        except:
            mesg=u'expected a value of size=NNNNNN in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        if self.docfiles is None:
            self.docfiles={}
        return None
    
    def handleDocfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'docfiles_file'
        """
        fields=restOfLine.strip().split() # recall that restOfLine=line[1:]
        kvDct={}
        kvString=None
        try:
            for kvString in fields[1:]:
                if kvString:
                    k,v=kvString.split("=",1)
                    kvDct[k]=v
        except:
            mesg=u'unable to understand doc file description in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s; key-value description string=%(kvString)s; reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState),kvString=repr(kvString))                
        try:
            self.docfiles[fields[0].strip()]=kvDct
        except Exception, err:
            mesg=u'unable to understand doc file name in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s: %(err)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState),err=errorValue(err))
        return None
    
    def handleRunfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'runfiles'
        """
        try:
            fields=restOfLine.strip().split()
            sizeString=fields[0]
        except:
            mesg=u'no value in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        try:
            sizeFields=sizeString.split('=',1)
            if sizeFields[0].lower()!='size':
                raise tlError
            size=int(sizeFields[1])
            if self.runsize is None:
                self.runsize=0
            self.runsize+=size
        except:
            mesg=u'expected a value of size=NNNNNN in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        if self.runfiles is None:
            self.runfiles=[]
        return None

    def handleRunfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'runfiles_file'
        """
        try:
            fields=restOfLine.strip().split() # recall that restOfLine=line[1:]
            self.runfiles.append(fields[0].strip())
        except:
            mesg=u'unable to understand run file name in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None
    
    def handleBinfiles(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'binfiles'
        """
        try:
            fields=restOfLine.strip().split()
            firstString,secondString=fields[0],fields[1]
        except:
            mesg=u'expected an arch=XXXX size=NNNNNN in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        try:
            firstStringFields=firstString.split('=',1)
            secondStringFields=secondString.split('=',1)
            if firstStringFields[0].lower()=='arch':
                archFields=firstStringFields
                sizeFields=secondStringFields
            else:
                archFields=secondStringFields
                sizeFields=firstStringFields
            if (archFields[0].lower()!='arch'
                or sizeFields[0].lower()!='size'):
                raise tlError
            self.currentArch=archFields[1]
        except:
            mesg=u'expected two values of the form x=y in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        try:
            if self.binsize is None:
                self.binsize={}
            self.binsize[self.currentArch]=int(sizeFields[1])
        except:
            mesg=u'expected size to be an integer in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        if self.binfiles is None:
            self.binfiles={}
        self.binfiles[self.currentArch]=[]
        return None
    
    def handleBinfilesFile(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'binfiles_file'
        """
        if self.currentArch is None:
            mesg=u'do not know the right architecture in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))                
        try:
            fields=restOfLine.strip().split() # recall that restOfLine=line[1:]
            self.binfiles[self.currentArch].append(fields[0].strip())
        except:
            mesg=u'unable to understand bin file path in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s with architecture %(currentArch)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState),currentArch=repr(currentArch))
        return None

    def is_arch_dependent(self):
        """Returns True if there are binfiles.
        """
        if self.binfiles:
            return True
        else:
            return False

    def total_size(self,*archs):
        """Returns the sum of the sizes of srcfiles, docfiles, runfiles,
        and binfiles any architectures given.
        """
        if self.srcsize is None:
            srcsize=0
        else:
            srcsize=self.srcsize
        if self.docsize is None:
            docsize=0
        else:
            docsize=self.docsize
        if self.runsize is None:
            runsize=0
        else:
            runsize=self.runsize
        s=srcsize+docsize+runsize
        try:
            for arch in archs:
                s+=self.binsize[arch]
        except:
            mesg=u'unable to recognize an architecture'
            noteException(mesg,devel=mesg+': %(arch)s',exception=tlError,log=self.log,debug=self.debug,arch=repr(arch))
        return s

    def _subtractList(self,l1,l2):
        """From l1 remove any elements of l2, as many times as they occur.
        """
        for f in l2:
            while True:  # more than one f in l1?
                try:
                    l1.remove(f)
                except:
                    break
        return l1
    def add_srcfiles(self,fileList):
        self.srcfiles+=fileList
    def remove_srcfiles(self,fileList):
        self.srcfiles=self._subtractList(self.srcfiles,fileList)
    def add_docfiles(self,fileList):
        self.docfiles+=fileList
    def remove_docfiles(self,fileList):
        self.docfiles=self._subtractList(self.docfiles,fileList)
    def add_runfiles(self,fileList):
        self.runfiles+=fileList
    def remove_runfiles(self,fileList):
        self.runfiles=self._subtractList(self.runfiles,fileList)
    def add_binfiles(self,arch,fileList):
        self.binfiles[arch]+=fileList
    def remove_binfiles(self,arch,fileList):
        self.binfiles[arch]=self._subtractList(self.binfiles[arch],fileList)
    def add_files(self,t,fileList):
        if t=='src':
            self.add_srcfiles(fileList)
        elif t=='doc':
            self.add_docfiles(fileList)
        elif t=='run':
            self.add_runfiles(fileList)
        else:
            mesg=u'file type not known'
            noteException(mesg,devel=mesg+': %(t)s',exception=tlError,log=self.log,debug=self.debug,t=repr(t))
    def remove_files(self,t,fileList):
        if t=='src':
            self.remove_srcfiles(fileList)
        elif t=='doc':
            self.remove_docfiles(fileList)
        elif t=='run':
            self.remove_runfiles(fileList)
        else:
            mesg=u'file type not known'
            noteException(mesg,devel=mesg+': %(t)s',exception=tlError,log=self.log,debug=self.debug,t=repr(t))
            
    def list_files(self):
        """Return a string of lines with file names for all files 
        """
        r=[]
        if self.srcfiles: 
            r+=self.srcfiles
        if self.runfiles:
            r+=self.runfiles
        if self.docfiles:
            r+=self.docfiles.keys()
        if self.binfiles:
            for arch in self.binfiles.keys():
                r+=self.binfiles[arch]
        r.sort()
        return "\n".join(r)


class tlpobj_db(tlp_db):
    """Give information based on a TeXLive object file database
    """
    def _makeSingle(self):
        """Helper fcn to make one of whatever self.value is holding multiple
        of
          f  file handle
        """
        return tlpobj(log=self.log,debug=self.debug)

##     def to_db(self,dBcsr,dBcnx,verbose=False):
##         """Write all records to the database
##           dBcsr,dBcnx  database cursor and connection
##         """
##         pkgNames=self.value.keys()
##         pkgNames.sort()
##         for k in pkgNames:
##             v=self.value[k]
##             v.to_db(dBcsr,dBcnx,verbose=verbose)
##         return None
    

class tlpsrc(tlp):
    """Give information based on a TeXLive source file
    """
    def __init__(self,verbose=False,log=None,debug=False):
        """Initialize an object.
        """
        super(tlpsrc,self).__init__(verbose=verbose,log=log,debug=debug)
        self.srcpattern=None  # list of strings (or None)
        self.runpattern=None  # list of strings (or None)
        self.docpattern=None  # list of strings (or None)
        self.binpattern=None  # list of strings (or None)
        return None

    def __unicode__(self):
        r=[]
        r.append(super(tlpsrc,self).__unicode__())
        r.append("  srcpattern: %s" % (pprint.pformat(self.srcpattern),))
        r.append("  runpattern: %s" % (pprint.pformat(self.runpattern),))
        r.append("  docpattern: %s" % (pprint.pformat(self.docpattern),))
        r.append("  binpattern: %s" % (pprint.pformat(self.binpattern),))
        return "\n".join(r)

    def _stringToWriteout(self):
        """String that will be written out during writeout_fh
        """
        r=[]
        r.append(super(tlpsrc,self)._stringToWriteout())
        if self.srcpattern:
            for line in self.srcpattern:
                r.append("srcpattern %s" % (line,))
        if self.runpattern:
            for line in self.runpattern:
                r.append("runpattern %s" % (line,))
        if self.docpattern:
            for line in self.docpattern:
                r.append("docpattern %s" % (line,))
        if self.binpattern:
            for line in self.binpattern:
                r.append("binpattern %s" % (line,))
        return "\n".join(r)

    initialState=tlp.initialState
    nextStates=tlp.nextStates
    nextStates['srcpattern']=tlp.keyValueStates
    nextStates['runpattern']=tlp.keyValueStates
    nextStates['docpattern']=tlp.keyValueStates
    nextStates['binpattern']=tlp.keyValueStates

    def handleSrcpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'srcpattern'
        """
        try:
            if self.srcpattern is None:
                self.srcpattern=[]
            self.srcpattern.append(restOfLine.rstrip())
        except:
            mesg=u'no "value" text in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None

    def handleRunpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'runpattern'
        """
        try:
            if self.runpattern is None:
                self.runpattern=[]
            self.runpattern.append(restOfLine.rstrip())
        except:
            mesg=u'no "value" text in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None

    def handleDocpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'docpattern'
        """
        try:
            if self.docpattern is None:
                self.docpattern=[]
            self.docpattern.append(restOfLine.rstrip())
        except:
            mesg=u'no "value" text in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None

    def handleBinpattern(self,newState,restOfLine,line,lineNo):
        """What to do if the newState is 'binpattern'
        """
        try:
            if self.binpattern is None:
                self.binpattern=[]
            self.binpattern.append(restOfLine.rstrip())
        except:
            mesg=u'no "value" text in line number=%(lineNo)s'
            noteException(mesg,devel=mesg+'; now in state %(newState)s reading line=%(line)s',exception=tlError,log=self.log,debug=self.debug,lineNo=lineNo,line=repr(line),newState=repr(newState))
        return None


class tlpsrc_db(tlp_db):
    """Give information based on a TeXLive src file list
    """
    def from_dir(self,dn=None):
        """Read a set of tlpsrc files.  Set self.value.
          dn=None  directory name.  If None, use the canonical name.
        """
        if dn is None:
            dn=os.path.join(os.path.dirname(TLPDB_FILENAME),'tlpkg/tlpsrc')
        globPattern=os.path.join(dn,'*.tlpsrc')
        for fn in glob.glob(globPattern):
            self.from_file(fn=fn)
        return None

    def _makeSingle(self):
        """Helper fcn to make one of whatever self.value is holding multiple
        of.
        """
        return tlpsrc(log=self.log,debug=self.debug)
    
    def to_dir(self,dn=None):
        """Write a set of tlpsrc files.
          dn=None  directory name.  If None, use the canonical name.
        """
        if dn is None:
            dn=os.path.join(os.path.basename(TLPDB_FILENAME),'tlpsrc')
        if not(os.path.exists(dn)):
            os.makedirs(dn)
        pkgNames=self.value.keys()
        for k in pkgNames:
            v=self.value[k]
            fn=os.path.join(dn,v.name+'.tlpsrc')
            v.writeout(fn=fn)
        return None


def getRelatedCatPkg(tlId,dBcsr,log=None,debug=False):
    """Get the list of catalogue packages that are related to the given
    TeX Live package (does not return None values).
      tlId  string
      dBcsr  database cursor
      log=None,debug=False  debugging
    """
    sql="""SELECT pkg_id FROM tl_cat
             WHERE tl_id=%(tlId)s
             AND pkg_id IS NOT NULL"""
    dct={'tlId':tlId}
    try:
        dBres=dBUtils.getData(sql,dct=dct,dBcsr=dBcsr,log=log,debug=debug,listtype='get catalogue package ids related to this TeX Live package id')
    except dBUtils.dBUtilsError, err:
        mesg=u'unable to get texlive-catalogue packages record'
        noteException(mesg,devel=mesg+' for TeX Live package %(tlId)s: %(err)s',log=log,debug=debug,tlId=repr(tlId),err=errorValue(err))
    return set([catId for (catId,) in dBres])

def getRelatedTlPkg(pkgId,dBcsr,log=None,debug=False):
    """Get the list of TeX Live packages that are related to the given
    Catalogue package.
      pkgId  string
      dBcsr  database cursor
      log=None,debug=False  debugging
    """
    sql="""SELECT tl_id FROM tl_cat
             WHERE pkg_id=%(pkgId)s"""
    dct={'pkgId':pkgId}
    try:
        dBres=dBUtils.getData(sql,dct=dct,dBcsr=dBcsr,log=log,debug=debug,listtype='get TeX Live package ids related to this catalogue package id')
    except dBUtils.dBUtilsError, err:
        mesg=u'unable to get catalogue-texlive packages record'
        noteException(mesg,devel=mesg+' for catalogue package %(pkgId)s: %(err)s',log=log,debug=debug,pkgId=repr(pkgId),err=errorValue(err))
    return set([tlId for (tlId,) in dBres])

    
#......................................................................
def main(argv=None,log=None,debug=DEBUG):
    """The main logic if called from the command line
      argv  The arguments to the routine
      log=None, debug=DEBUG   Debugging stuff
    """
    if argv is None:
        argv=sys.argv
    # Parse the arguments
    usage="""%prog: read a TeX Live tlp src or obj file; typically write the obj filelists to the dB
  %prog [options]"""
    oP=optparse.OptionParser(usage=usage,version=__version__)
    oP.add_option('--output','-o',action='store_true',default=False,dest='output',help='show all package records')
    oP.add_option('--no-database','-n',action='store_true',default=False,dest='noDb',help='do not put all package records to the database')
    oP.add_option('--source-read','-s',action='store_true',default=False,dest='srcDir',help='read the source files')
    oP.add_option('--add-catalogue-information','-a',action='store_true',default=False,dest='catInfo',help='add catalogue information to the source or object information')
    oP.add_option('--debug','-D',action='store_true',default=DEBUG,dest='debug',help='output debugging information')
    oP.add_option('--verbose','-V',action='store_true',default=VERBOSE,dest='verbose',help='talk a lot')
    opts, args=oP.parse_args(argv[1:])
    # Handle the options
    # Handle positional arguments
    if args[1:]:    
        tlpdbFilename=args[1]
    else:
        tlpdbFilename=TLPDB_FILENAME
    # Handle the various command line switches
##     try:
##         (dBcnx,dBcsr)=dBUtils.opendB()
##     except dBUtils.dBUtilsError, err:
##         fail("Unable to connect to the database: %(err)s",returnCode=10,log=log,debug=opts.debug,err=errorValue(err))
    if opts.srcDir:
        try:
            t=tlpsrc_db(log=log,debug=opts.debug)
            t.from_dir(dn=None)
            if opts.catInfo:
                t.add_cat_descs(dBcsr)
            t.to_dir(dn='tmpTexlive')
        except Exception, err:
            mesg="trouble reading the object file and writing: "+errorValue(err)
            fail(mesg,returnCode=10,log=log,debug=opts.debug)
        return None
    if opts.output:
        try:
            t=tlpobj_db(log=log,debug=opts.debug)
            t.from_file(tlpdbFilename)
            if opts.catInfo:
                t.add_cat_descs(dBcsr)
            t.write_file()
        except Exception, err:
            mesg="trouble reading the object file and writing: "+errorValue(err)
            fail(mesg,returnCode=10,log=log,debug=opts.debug)
        return None
##     if not(opts.noDb):
##         try:
##             t=tlpobj_db(log=log,debug=opts.debug)
##             t.from_file(tlpdbFilename)
##             t.to_db(dBcsr,dBcnx,verbose=opts.verbose)
##         except Exception, err:
##             mesg="trouble reading the object file and sending the results to the database: "+errorValue(err)
##             fail(mesg,returnCode=10,log=log,debug=opts.debug)
    return None


# ............... script start .......................
if __name__=='__main__':
    log=None
    if LOGGING:
        log=openLog(LOGFILE_NAME,purpose=THIS_SCRIPT)
    if DEBUG and __notes__.strip():
        note(__notes__,log,leader="NOTES FOR %s:" % (THIS_SCRIPT,),)        
    try:
        main(argv=sys.argv,log=log,debug=DEBUG)
    except KeyboardInterrupt:
        mesg=u"Keyboard interrupt"
        fail(mesg,returnCode=1,log=log,debug=DEBUG)
    except StandardError, err:
        mesg=u"General programming error: "+errorValue(err)
        fail(mesg,returnCode=2,log=log,debug=DEBUG)
    except SystemExit, err:  # fail() inside a subroutine
        pass
    sys.exit(0)
