# $Id$
# TeXLiveInfra.sh - shell library for the access to TLDB and TLP
#
# Copyright 2007 Norbert Preining
# This file is licensed under the GNU General Public License version 2
# or any later version.

die() {
	echo $*
	exit 1
}

test_tlp() {
	tlpfile="$1"
	if [ ! -r "$tlpfile" ] ; then
		die "tlp file not readable: $tlpfile"
	fi
}

# we read the whole tlp again and again
# if we could use some multi-line grepping this could be speed up
# but I guess we would need perl regexp grepping
# BETTER: use an awk program for this, but I am not able to write
# such an awk program. And do we have it available everywhere?
_tlp_get_multi() {
	entry="$1"
	tlpfile="$2"
	arch="$3"
	test_tlp "$tlpfile"
	( SAVEDIFS=$IFS ; IFS= ; cat "$tlpfile" | __tlp_get_multi "$entry" "$arch" )
}
__tlp_get_multi() {
	entry="$1"
	arch="$2"
	if [ "$arch" = "" ] ; then
		pat="$entry*"
	else
		pat="$entry*arch=$arch*"
	fi
	reading_multi=0
	while read line ; do
		case "$line" in 
			$pat)	
				reading_multi=1
				;;
			\ *)
				if [ $reading_multi = 1 ] ; then
					( IFS=$SAVEDIFS ; echo $line )
				fi
			;;
		*)
			if [ $reading_multi = 1 ] ; then
				# we already have read the interesting part, return now
				return
			fi
			;;
		esac
	done
}

_tlp_get_multi_simple() {
	entry="$1"
	tlpfile="$2"
	test_tlp "$tlpfile"
	grep "^$entry" "$tlpfile" | sed -e "s@^$entry[ \t]*@@"
}

_tlp_get_simple() {
	entry="$1"
	tlpfile="$2"
	field="$3"
	prefix="$4"
	test_tlp "$tlpfile"
	cat "$tlpfile" | __tlp_get_simple $entry $field $prefix
}

__tlp_get_simple() {
	entry="$1"
	field="$2"
	prefix="$3"
	if [ "$field" = "" ] ; then
		grep -m 1 "^$entry " | sed -e "s@^$entry[ \t]*@@" | sed -e "s@^$prefix@@"
	else
		grep -m 1 "^$entry " | awk "{print\$${field}}" | sed -e "s@^$prefix@@"
	fi
}

tlp_get_name() 
{ 
	_tlp_get_simple name "$1"
}
tlp_get_revision() 
{
	_tlp_get_simple revision "$1"
}
tlp_get_category () 
{
	_tlp_get_simple category "$1"
}
tlp_get_shortdesc ()
{
	_tlp_get_simple shortdesc "$1"
}
tlp_get_catalogue ()
{
	_tlp_get_simple catalogue "$1"
}
tlp_get_longdesc ()
{
	_tlp_get_multi longdesc "$1"
}
tlp_get_depends ()
{
	_tlp_get_multi_simple depend "$1"
}
tlp_get_executes ()
{
	_tlp_get_multi_simple execute "$1"
}
tlp_get_srcfiles ()
{
	_tlp_get_multi srcfiles "$1"
}
tlp_get_docfiles () {
	_tlp_get_multi docfiles "$1"
}
tlp_get_runfiles () {
	_tlp_get_multi runfiles "$1"
}
tlp_get_srcsize () {
	_tlp_get_simple srcfiles "$1" 2 "size="
}
tlp_get_docsize () 
{
	_tlp_get_simple docfiles "$1" 2 "size="
}
tlp_get_runsize () 
{ 
	_tlp_get_simple runfiles "$1" 2 "size=" 
}

tlp_get_binsize () 
{ 
	tlpfile="$1"
	arch="$2"
	_tlp_get_simple "binfiles[ \t]*arch=$arch" "$1" 3 "size=" 
}
tlp_get_binfiles ()
{
	_tlp_get_multi binfile "$1" "$2"
}

tlp_get_available_arch ()
{
	test_tlp "$tlpfile"
	grep 'binfiles[ \t]*arch=' "$tlpfile" | awk '{print$2}' | sed -e 's/arch=//'
}

test_tldb() {
	tldbfile="$1"
	if [ ! -r "$tldbfile" ] ; then
		die "tldb file not readable: $tldbfile"
	fi
}

_tldb_tlp_get_multi()
{
	tldb="$1"
	tlp="$2"
	entry="$3"
	arch="$4"
	test_tldb "$tldb"
	foundpackage=0
	( SAVEDIFS=$IFS ; IFS= ; while read line ; do
	case "$line" in 
		name\ $tlp*)
			foundpackage=1
			__tlp_get_multi $entry $arch
			;;
		*)
			if [ $foundpackage = 1 ] ; then
				return
			fi
			;;
		esac
	done ) <$tldb
}
_tldb_tlp_get_simple()
{
	tldb="$1"
	tlp="$2"
	entry="$3"
	field="$4"
	prefix="$5"
	test_tldb "$tldb"
	foundpackage=0
	( SAVEDIFS=$IFS ; IFS= ; while read line ; do
		case "$line" in 
			name\ $tlp*)
				foundpackage=1
				__tlp_get_simple $entry $field $prefix
				;;
			*)
				if [ $foundpackage = 1 ] ; then
					return
				fi
				;;
		esac
	done ) <$tldb
}


tldb_tlp_get_revision() 
{
	_tldb_tlp_get_simple "$1" "$2" revision "$3" "$4"
}
tldb_tlp_get_category () 
{
	_tldb_tlp_get_simple "$1" "$2" category "$3" "$4"
}
tldb_tlp_get_shortdesc ()
{
	_tldb_tlp_get_simple "$1" "$2" shortdesc "$3" "$4"
}
tldb_tlp_get_catalogue ()
{
	_tldb_tlp_get_simple "$1" "$2" catalogue "$3" "$4"
}
tldb_tlp_get_longdesc ()
{
	_tldb_tlp_get_multi "$1" "$2" longdesc "$3"
}
tldb_tlp_get_srcfiles ()
{
	_tldb_tlp_get_multi "$1" "$2" srcfiles "$3"
}
tldb_tlp_get_docfiles () {
	_tldb_tlp_get_multi "$1" "$2" docfiles "$3"
}
tldb_tlp_get_runfiles () {
	_tldb_tlp_get_multi "$1" "$2" runfiles "$3"
}
tldb_tlp_get_binfiles ()
{
	_tldb_tlp_get_multi "$1" "$2" binfile "$3"
}

tldb_get_installed_packages ()
{
	tldb="$1"
	test_tldb "$tldb"
	grep ^name "$tldb" | awk '{print$2}'
}


### Local Variables:
### perl-indent-level: 4
### tab-width: 4
### indent-tabs-mode: t
### End:
# vim:set tabstop=4: #
