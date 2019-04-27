#!/usr/bin/python

"""
Renames XML/HTML tags
"""

import argparse
import sys
import lxml.html as etree


def convert_xml(input_file, output_file, conversions):
    """
    Rename tags in input_file based on conversions. Writes XML to output_file
    as string.

    :param types.FileType input_file: input file stream
    :param types.FileType output_file: output file stream
    :param dict conversions: mapping of tag name conversions
    """
    xml = etree.parse(input_file)

    for from_tag, to_tag in conversions.items():
        for elem in xml.iterfind('//%s' % from_tag):
            elem.tag = to_tag

    output_file.write(etree.tostring(xml))


def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='convert html tags')
    parser.add_argument('--input', '-i', dest='input_filename',
                        help='Input XML file')
    parser.add_argument('--output', '-o', dest='output_filename',
                        help='Output XML file')
    parser.add_argument('--convert', '-c', required=True, action='append',
                        nargs=2, help='tag name converisons')
    args = parser.parse_args()

    input_file = sys.stdin if args.input_filename is None else open(args.input_filename, 'r')
    output_file = sys.stdout if args.output_filename is None else open(args.output_filename, 'w')

    convert_xml(input_file, output_file, dict(args.convert))


if __name__ == '__main__':
    main()
