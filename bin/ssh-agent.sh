:
# NAME:
#	ssh-agent.sh - connect to or start for ssh-agent
#
# SYNOPSIS:
#	eval `ssh-agent.sh`
#	ssh-agent.sh --link
#
# DESCRIPTION:
#	Sets SSH_AUTH_SOCK to an existing or newly started agent socket.
#
#	SSH_AUTH_SOCKDIR can be used to control where the sockets will
#	be created.  The default is /tmp/.$USER-agent a subdir is needed
#	so that its permissions can be confined to the owner only.
#
#	If SSH_AGENT is set to 'gpg-agent' we will run that.
#	This can be useful since 'gpg-agent' can support yubikey.
#
#	Options:
#
#	--force	Ignore existing SSH_AUTH_SOCK
#
#	--gpg	Use 'gpg-agent'
#
#	--link	make a link to an existing socket, see below.
#		This is also done in the case that we had to
#		start an agent.  The link is placed in
#		SSH_AUTH_SOCKDIR named for the host the agent and the
#		pid of the agent, so it can be found for re-use and
#		its validity tested.
#
# BUGS:
#	'gpg-agent' always creates its socket in $HOME with
#	a fixed name.  This is a bad idea, if $HOME is on NFS
#	but it can be a file which we redirect to a guaranteed local
#	path (all very clunky).

# RCSid:
#	$Id: ssh-agent.sh,v 1.2 2016/08/12 17:39:43 sjg Exp $
#
#	@(#) Copyright (c) 2007 Simon J. Gerraty
#
#	This file is provided in the hope that it will
#	be of use.  There is absolutely NO WARRANTY.
#	Permission to copy, redistribute or otherwise
#	use this file is hereby granted provided that 
#	the above copyright notice and this notice are
#	left intact. 
#      
#	Please send copies of changes and bug-fixes to:
#	sjg@crufty.net
#

# portable means of finding things
Which() {
	case "$1" in
	-*) t=$1; shift;;
	*) t=-x;;
	esac
	case "$1" in
	/*)	test $t $1 && echo $1;;
	*)
		for d in `IFS=:; echo ${2:-$PATH}`
		do
			test $t $d/$1 && { echo $d/$1; break; }
		done
		;;
	esac
}

ssh_agent_error() {
	echo "ERROR: $@" >&2
	exit 1
}

ssh_agent_sock() {
	# in case we were sourced by someone else
	HOST=${HOST:-`uname -n`}
	SSH_AGENT_NAME=${SSH_AGENT_NAME:-`basename ${SSH_AGENT:-ssh-agent}`}
	SSH_AUTH_SOCKDIR=${SSH_AUTH_SOCKDIR:-/tmp/.${USER:-$LOGNAME}-agent}
	mkdir -p $SSH_AUTH_SOCKDIR
	chmod 700 $SSH_AUTH_SOCKDIR || return
	case "$SSH_AGENT_NAME" in
	gpg-agent*) agent_sock=$SSH_AUTH_SOCKDIR/S.gpg-agent.ssh;;
	*) agent_sock=$SSH_AUTH_SOCKDIR/$HOST.$SSH_AGENT_NAME;;
	esac
}
	
ssh_agent_find() {
	SSH_AUTH_SOCK=; export SSH_AUTH_SOCK
	SSH_AGENT_PID=; export SSH_AGENT_PID
	ssh_agent_sock
	for s in $agent_sock.*
	do
		pid=`expr $s : "$agent_sock.\([1-9].*\)"` || continue
		_m=`LANG=C LC_ALL=C kill -0 $pid 2>&1`
		_x=$?
		case "$_m,$_x" in
		*such*p*) # no longer valid
			rm -f $s
			;;
		*,0)	# got one! continue through the loop to cleanup
			SSH_AUTH_SOCK=$s
			SSH_AGENT_PID=$pid
			;;
		esac
	done
}

# find process associated with SSH_AUTH_SOCK
_lsof() {
	LSOF=${LSOF:-`Which fstat`}
	LSOF=${LSOF:-`Which lsof`}
	sock=${1:-$SSH_AUTH_SOCK}
	clue=${2:-$SSH_AGENT_NAME}

	case "/$LSOF" in
	*/lsof*) $LSOF $sock | awk "/$clue/ { print \$2; exit; }";;
	*/fstat*) $LSOF -u ${USER:-$LOGNAME} |
		egrep "$clue.* ($sock| wd )" | awk '{ print $3; exit; }';;
	esac
}
    
# make a link to SSH_AUTH_SOCK such that we can find it later            
ssh_agent_link() {
	[ -S ${SSH_AUTH_SOCK:-/dev/null} ] || ssh_agent_error no SSH_AUTH_SOCK
	ssh_agent_sock
	case $SSH_AUTH_SOCK in
	*/Listeners|*/S.gpg*) SSH_AGENT_PID=${SSH_AGENT_PID:-`_lsof`};;
	*/agent.*) # if we don't have SSH_AGENT_PID set, something is wrong
		[ "$SSH_AGENT_PID$SSH_CLIENT" ] || ssh_agent_error no SSH_AGENT_PID
		;;
	esac
	# if SSH_AGENT_PID is not set, it is a forwarded socket
	# and the ssh pid is used - which serves our purpose.
	SSH_AGENT_PID=${SSH_AGENT_PID:-`echo $SSH_AUTH_SOCK | sed 's,.*\.,,'`}
	[ -S $agent_sock.$SSH_AGENT_PID ] ||
	ln -sf $SSH_AUTH_SOCK $agent_sock.$SSH_AGENT_PID
}

ssh_agent() {
	[ -S ${SSH_AUTH_SOCK:-/dev/null} ] && return # I've already got one you see
	ssh_agent_find
	[ -S ${SSH_AUTH_SOCK:-/dev/null} ] && return
	# start one and make a link
	case "$SSH_AGENT_NAME" in
	gpg-agent*)
		SSH_AGENT_FLAGS="--daemon --enable-ssh-support $SSH_AGENT_FLAGS"
		GNUPGHOME=${GNUPGHOME:-$HOME/.gnupg}
		for s in S.gpg-agent S.gpg-agent.ssh
		do
			# gpg2 *always* uses the std_sock!
			std_sock=$GNUPGHOME/$s
			test -f $std_sock && continue
			# but it can be a file naming a real socket to use!
			test -s $std_sock && mv $std_sock $std_sock.$$
			{ echo '%Assuan%'; echo "socket=$SSH_AUTH_SOCKDIR/$s"; } > $std_sock
		done
		;;
	*) SSH_AGENT_FLAGS="-s $SSH_AGENT_FLAGS";;
	esac
	eval `$SSH_AGENT $SSH_AGENT_FLAGS`
	case "$SSH_AGENT_NAME,$SSH_AUTH_SOCK" in
	gpg-agent*,$HOME/*) # this thing is stupid
		SSH_AUTH_SOCK=$agent_sock
		;;
	esac
	ssh_agent_link
}


case "/$0" in
*/ssh-agent*)
	# suitable for eval `ssh-agent.sh`
	op=ssh_agent
	export_list="SSH_AUTH_SOCK SSH_AGENT_PID"
	csh_syntax=
	SSH_AGENT_FLAGS=
	while :
	do
		case "$1" in
		-[at]) SSH_AGENT_FLAGS="$SSH_AGENT_FLAGS $1 $2"; shift 2;;
		-[dkx]) SSH_AGENT_FLAGS="$SSH_AGENT_FLAGS $1"; shift;;
		-c) csh_syntax=yes; shift;;
		-s) shift;;
		*=*) eval "$1"; shift;;
		--force) SSH_AUTH_SOCK= SSH_AGENT_PID=; shift;;
		--gpg) SSH_AGENT=${SSH_AGENT:-`Which gpg-agent`}; shift;;
		--link) op=ssh_agent_link; export_list=SSH_AUTH_SOCK; shift;;
		*) break;;
		esac
	done
	SSH_AGENT=${SSH_AGENT:-`Which ssh-agent`}
	$op > /dev/null
	for v in $export_list
	do
		eval "val=\$$v"
		[ $val ] || continue
		if [ "$csh_syntax" ]; then
			echo "setenv $v $val;"
		else
			echo "$v=$val; export $v;"
		fi
	done
	;;
esac
