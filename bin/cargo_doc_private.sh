#!/bin/sh

#cargo rustdoc -- --no-defaults --passes "collapse-docs" --passes "unindent-comments" "$@"

RUSTDOC=rustdoc-with-private cargo doc "$@"
