#!/usr/bin/python

"""Launches Terminal with profile corresponding to output"""

# pylint: disable=no-member

import logging
import sys
from pprint import pformat
import i3


LOG = logging.getLogger()


def setup_logger(level):
    """Initializes logger with debug level"""
    LOG.setLevel(logging.DEBUG)
    channel = logging.StreamHandler(sys.stdout)
    channel.setLevel(level)
    formatter = logging.Formatter('[%(levelname)s] %(message)s')
    channel.setFormatter(formatter)
    LOG.addHandler(channel)


def get_focused_workspace():
    """Get workspace that is currently focused"""
    actives = [wk for wk in i3.get_workspaces() if wk['focused']]
    assert len(actives) == 1
    return actives[0]


def launch_terminal():
    """Launches terminal on output that has focus with profile"""
    focused_workspace = get_focused_workspace()
    focused_output = focused_workspace['output']
    LOG.debug('Focused output: ' + focused_output)

    # Launch 'External' profile if not focused on main monitor
    profileArgs = []
    if not focused_output.startswith('eDP'):
        profileArgs = ['--profile=External']
    i3.command(*(['exec', 'terminator'] + profileArgs))


if __name__ == '__main__':
    i3.command('exec', 'terminator')
    #setup_logger(logging.DEBUG)
    #launch_terminal()
