// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  // string for location
  char location[9];
  // string of input (hex and printable)
  char data_buf[17]; 
  // number of char read
  unsigned count = 0;
  count = hex_read(data_buf);
  data_buf[count] = '\0';
  unsigned index = 0;
  while (count != 0) {
    // write the location
    hex_format_offset(index, location);
    hex_write_string(location);
    hex_write_string(": ");
    // write hex digits
    char sbuf[3];
    for (unsigned i = 0; i < count; i++) {
      hex_format_byte_as_hex(data_buf[i], sbuf);
      hex_write_string(sbuf);
      hex_write_string(" ");
    }
    // pad empty spaces until the block of hex has been filled
    for (unsigned i = count; i < 16; i++) {
      hex_write_string("   ");
    }
    hex_write_string(" ");
    // write printables
    for (unsigned i = 0; i < count; i++) {
      data_buf[i] = hex_to_printable(data_buf[i]);
    }
    hex_write_string(data_buf);
    // new line
    hex_write_string("\n");
    // update index, count, and buffer for the new line
    index += 16;
    count = hex_read(data_buf);
    data_buf[count] = '\0';
  }
}
