// Unit tests for hex functions
// These tests should work for both your C implementations and your
// assembly language implementations

#include <stdio.h>
#include <stdlib.h>
#include "tctest.h"
#include "hexfuncs.h"

// test fixture object
typedef struct {
  char test_data_1[16];
} TestObjs;

// setup function (to create the test fixture)
TestObjs *setup(void) {
  TestObjs *objs = malloc(sizeof(TestObjs));
  strcpy(objs->test_data_1, "Hello, world!\n");
  return objs;
}

// cleanup function (to destroy the test fixture)
void cleanup(TestObjs *objs) {
  free(objs);
}

// Prototypes for test functions
void testFormatOffset(TestObjs *objs);
void testFormatByteAsHex(TestObjs *objs);
void testHexToPrintable(TestObjs *objs);

int main(int argc, char **argv) {
  if (argc > 1) {
    tctest_testname_to_execute = argv[1];
  }

  TEST_INIT();

  TEST(testFormatOffset);
  TEST(testFormatByteAsHex);
  TEST(testHexToPrintable);

  TEST_FINI();

  return 0;
}

void testFormatOffset(TestObjs *objs) { //sbuf must have enough room
  (void) objs; // suppress warning about unused parameter
  char buf[16];
  hex_format_offset(0x00000001u, buf);
  ASSERT(0 == strcmp(buf, "00000001"));

  hex_format_offset(0xabcd1234u, buf);
  ASSERT(0 == strcmp(buf, "abcd1234"));

  hex_format_offset(0x0u, buf);
  ASSERT(0 == strcmp(buf, "00000000"));

    hex_format_offset(0x1u, buf);
  ASSERT(0 == strcmp(buf, "00000001"));

  hex_format_offset(0xffffffffu, buf);
  ASSERT(0 == strcmp(buf, "ffffffff"));

  hex_format_offset(-0x1, buf);
  ASSERT(0 == strcmp(buf, "ffffffff"));
}

void testFormatByteAsHex(TestObjs *objs) { //input has value 0-255
  char buf[16];
  hex_format_byte_as_hex(objs->test_data_1[0], buf);
  ASSERT(0 == strcmp(buf, "48"));
  hex_format_byte_as_hex('I', buf);
  ASSERT(0 == strcmp(buf, "49"));
  hex_format_byte_as_hex('\0', buf);
  ASSERT(0 == strcmp(buf, "00"));
  hex_format_byte_as_hex('~', buf);
  ASSERT(0 == strcmp(buf, "7e"));
  hex_format_byte_as_hex('.', buf);
  ASSERT(0 == strcmp(buf, "2e"));
  hex_format_byte_as_hex(255, buf);
  ASSERT(0 == strcmp(buf, "ff"));
  hex_format_byte_as_hex(-1, buf);
  ASSERT(0 == strcmp(buf, "ff"));
  hex_format_byte_as_hex(128, buf);
  ASSERT(0 == strcmp(buf, "80"));
}

void testHexToPrintable(TestObjs *objs) {
  ASSERT('H' == hex_to_printable(objs->test_data_1[0]));
  ASSERT('.' == hex_to_printable(objs->test_data_1[13]));
  ASSERT('!' == hex_to_printable(objs->test_data_1[12]));
  ASSERT('~' == hex_to_printable('~'));
  ASSERT(' ' == hex_to_printable(' '));
  ASSERT('+' == hex_to_printable('+'));
  ASSERT('.' == hex_to_printable(0));
  ASSERT('.' == hex_to_printable(-1));
  ASSERT('.' == hex_to_printable(129)); //test for char > 127
}
