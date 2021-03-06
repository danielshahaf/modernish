#! /module/for/moderni/sh
#
# 'use safe' loads safer shell defaults, plus utilities to facilitate
# temporary deviations from the defaults.
#
# 'use safe' does the following:
# - IFS='': Disable field splitting.
# - set -o noglob: Disable globbing. This is set on non-interactive shells only.
#	(The above two render most quoting of variable names unnecessary.
#	Only empty removal remains as a potential issue.)
# - set -o nounset: block on reading unset variables. This catches many bugs and typos.
#	However, you have to initialize variables before using them.
# - set -o noclobber: block on overwriting existing files using redirection.
#
# For interactive shells (or if 'use safe' is given the '-i' option), there
# are the 'fsplit' and 'glob' functions for convenient control of field
# splitting and globbing from the command line. For shell programs to
# temporarily enable these, it's recommended to use var/setlocal instead;
# see there for documentation.
#
# By default, on non-interactive shells (i.e. shell scripts/programs),
# safe.mm blocks on BUG_APPENDC (which is in older versions of
# zsh). The -w option (with the bug ID as the argument) can be used to
# suppress this block; it is a declaration that your program will work
# around the specified bug. The specific way of working around it is, of
# course, the responsibility of the programmer.
#
# To work around BUG_APPENDC, you could set this function and call it before
# every use of the '>>' operator where the file might not exist:
# Workaround_APPENDC() {
#        if thisshellhas BUG_APPENDC && not is -L present "$1"; then
#                : > "$1"
#        fi
# }
#
# --- begin license ---
# Copyright (c) 2016 Martijn Dekker <martijn@inlv.org>, Groningen, Netherlands
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# --- end license ---

# ------------
unset -v _Msh_save_wAPPENDC _Msh_safe_i
while let "$#"; do
	case "$1" in
	( -w )
		# declare that the program will work around a shell bug affecting 'use safe'
		let "$# >= 2" || die "safe.mm: option requires argument: -w" || return
		case "$2" in
		( BUG_APPENDC )	_Msh_safe_wAPPENDC=y ;;
		esac
		shift
		;;
	( -i )
		_Msh_safe_i=y
		;;
	( -??* )
		# if option and option-argument are 1 argument, split them
		_Msh_safe_tmp=$1
		shift
		set -- "${_Msh_safe_tmp%"${_Msh_safe_tmp#-?}"}" "${_Msh_safe_tmp#-?}" "$@"			# "
		unset -v _Msh_safe_tmp
		continue
		;;
	( * )
		putln "safe.mm: invalid option: $1"
		return 1
		;;
	esac
	shift
done

# don't block on bugs if shell is interactive
if not contains "$-" i; then
	unset -v _Msh_safe_err
	if thisshellhas BUG_APPENDC && not isset _Msh_safe_wAPPENDC; then
		putln 'safe.mm: This module sets -C (noclobber), but this shell has BUG_APPENDC, which' \
		      "         blocks the creation of non-existent files when the append ('>>')" \
		      '         redirection operator is used while the -C (noclobber) shell option is' \
		      '         active. To "use safe" in a BUG_APPENDC compatible way, add the option' \
		      '         "-w BUG_APPENDC" to "use safe" and carefully write your script to' \
		      "         make sure a file exists before appending to it using '>>'." \
		      1>&2
		_Msh_safe_err=y
	fi
	if isset _Msh_safe_err; then
		unset -v _Msh_safe_err _Msh_safe_i _Msh_safe_wAPPENDC
		return 1
	fi
fi

# --- Eliminate most variable quoting headaches ---
# (allows a zsh-ish style of shell programming)

# Disable field splitting.
IFS=''

# -f: Disable pathname expansion (globbing) on non-interactive shells.
not contains "$-" i && set -o noglob

# --- Other safety measures ---

# -u: error out when reading an unset variable (thereby preventing
# hard-to-trace bugs with unexpected empty removal on unquoted unset
# variables, for instance, if you make a typo in a variable name).
set -o nounset

# -C: protect files from being accidentally overwritten using output
# redirection. (Use '>|' instesad of '>' to explicitly overwrite any file
# that may exist).
set -o noclobber


# --- A couple of convenience functions for fieldsplitting and globbing ---
# Primarily convenient for interactive shells. To load these in shell
# scripts, add the -i option to 'use safe'. However, for shell scripts,
# setlocal/endlocal blocks are recommended instead (see var/setlocal.mm).

if contains "$-" i || isset _Msh_safe_i; then

	# fsplit:
	# Turn field splitting on (to default space+tab+newline), or off, or turn it
	# on with specified characters. Use the modernish CC* constants to
	# represent control characters. For an example of the latter, the default is
	# represented with the command:
	#
	#	fsplit set " ${CCt}${CCn}" # space, tab, newline
	#
	# Ref.: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_05
	#	1. If the value of IFS is a <space>, <tab>, and <newline>, ***OR IF
	#	   IT IS UNSET***, any sequence of <space>, <tab>, or <newline>
	#	   characters at the beginning or end of the input shall be ignored
	#	   and any sequence of those characters within the input shall
	#	   delimit a field.
	#	2. If the value of IFS is null, no field splitting shall be performed.
	#
	# 'fsplit save' and 'fsplit restore' use the stack functions
	# above to gain multiple levels of save and restore; this allows safe use in
	# functions, loops, and recursion. We have to save/restore not just the
	# value, but also the set/unset state, because this determines whether field
	# splitting is active at all. The stack functions do this.

	fsplit() {
		if let "$# == 0"; then
			set -- 'show'
		fi
		while let "$#"; do
			case "$1" in
			( 'on' )
				IFS=" ${CCt}${CCn}"
				;;
			( 'off' )
				IFS=''
				;;
			( 'set' )
				shift
				let "$#" || die "fsplit set: argument expected" || return
				IFS="$1"
				;;
			( 'save' )
				push IFS || die "fsplit save: 'push' failed" || return
				;;
			( 'restore' )
				if not stackempty IFS; then
					pop IFS || die "fsplit restore: 'pop' failed" || return
				else
					die "fsplit restore: stack empty" || return
				fi
				;;
			( 'show' )
				if not isset IFS || identic "$IFS" " ${CCt}${CCn}"; then
					putln "field splitting is active with default separators:" \
					      "  20  09  0a" \
					      "      \t  \n"
				elif empty "$IFS"; then
					putln "field splitting is not active"
				else
					putln "field splitting is active with custom separators:"
					put "$IFS" | od -v -An -tx1 -c || die "fsplit: 'od' failed" || return
				fi
				# TODO: show field splitting settings saved on the stack, if any
				;;
			( * )
				die "fsplit: invalid argument: $1" || return
				;;
			esac
			shift
		done
	}

	# Turn globbing (a.k.a. pathname expansion) on or off.
	#
	# 'glob save' and 'glob restore' use a stack to gain multiple levels
	# of save and restore; this allows safe use in functions, loops, and
	# recursion.

	glob() {
		if let "$# == 0"; then
			set -- 'show'
		fi
		while let "$#"; do
			case "$1" in
			( 'on' )
				set +f
				;;
			( 'off' )
				set -f
				;;
			( 'save' )
				push -f || die "globbing save: 'push' failed" || return
				;;
			( 'restore' )
				if not stackempty -f; then
					pop -f || die "globbing restore: 'pop' failed" || return
				else
					die "globbing restore: stack empty" || return
				fi
				;;
			( 'show' )
				if contains "$-" f
				then putln "pathname expansion is not active"
				else putln "pathname expansion is active"
				fi
				# TODO: show globbing settings saved on the stack, if any
				;;
			( * )
				die "globbing: invalid argument: $1"
				;;
			esac
			shift
		done
	}

fi

unset -v _Msh_safe_wAPPENDC _Msh_safe_i
