#!/bin/sh
# Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

TYPE="${BLOCK_INSTANCE:-mem}"

awk -v type=$TYPE '
/^MemTotal:/ {
	mem_total=$2
}
/^MemAvailable:/ {
	mem_avail=$2
}
/^SwapTotal:/ {
	swap_total=$2
}
/^SwapFree:/ {
	swap_free=$2
}
END {
	if (type == "swap") {
		free=swap_free/1024/1024
		used=(swap_total-swap_free)/1024/1024
		total=swap_total/1024/1024
	} else {
        # This is how libgtop calculates free mem (used by
        # gnome-system-monitor)
		used=(mem_total-mem_avail)/1048576
		total=mem_total/1048576
	}

	pct=0
	if (total > 0) {
		pct=used/total*100
	}

	# full text
	printf("%.1f/%.1fɢʙ\n", used, total)

	# short text
	printf("%.f%%\n", pct)

	# color
	if (pct > 90) {
		print("#FF0000")
	} else if (pct > 80) {
		print("#FFAE00")
	} else if (pct > 70) {
		print("#FFF600")
	}
}
' /proc/meminfo
