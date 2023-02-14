// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// Read up to 16 bytes from standard input into data_buf.
// Returns the number of characters read.
unsigned hex_read(char data_buf[]){
    unsigned count = 0;
    // read 16 bytes
    count = read(0, data_buf, 16);
    return count;
}

// Write given nul-terminated string to standard output.
void hex_write_string(const char s[]){
    unsigned length = 0;
    // find the length of the string
    while (s[length] != '\0') {
        length++;
    }
    write(1, s, length);
}

// Format an unsigned value as an offset string consisting of exactly 8
// hex digits.  The formatted offset is stored in sbuf, which must
// have enough room for a string of length 8.
void hex_format_offset(unsigned offset, char sbuf[]){
    // convert hex from least significant digit
    int index = 7;
    // remainder -> division operations to convert to hex
    while (offset != 0) {
        unsigned remainder = 0;
        char hex_digit;
        remainder = offset % 16;
        if (remainder >= 10) {
            hex_digit = 87 + remainder;
        } else {
            hex_digit = 48 + remainder;
        }
        sbuf[index--] = hex_digit;
        offset/=16;
    }
    // pad leading zeros
    for (int i = 0; i <= index; i++) {
        sbuf[i] = '0';
    }
    // add null terminator in case of any garbage in the array
    sbuf[8] = '\0';
}

// Format a byte value (in the range 0-255) as string consisting
// of two hex digits.  The string is stored in sbuf.
void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]){
    // convert hex from least significant digit
    int index = 1;
    // remainder -> division operations to convert to hex
    while (byteval != 0) {
        unsigned remainder = 0;
        char hex_digit;
        remainder = byteval % 16;
        if (remainder >= 10) {
            hex_digit = 87 + remainder;
        } else {
            hex_digit = 48 + remainder;
        }
        sbuf[index--] = hex_digit;
        byteval/=16;
    }
    // pad leading zeros
    for (int i = 0; i <= index; i++) {
        sbuf[i] = '0';
    }
    // add null terminator in case of any garbage in the array
    sbuf[2] = '\0';
}

// Convert a byte value (in the range 0-255) to a printable character
// value.  If byteval is already a printable character, it is returned
// unmodified.  If byteval is not a printable character, then the
// ASCII code for '.' should be returned.
char hex_to_printable(unsigned char byteval){
    // return '.' for non-printable characters
    if ((byteval >= 0 && byteval <= 31) || byteval == 127) {
        return '.';
    } else {
        // others are printable
        return byteval;
    }
}