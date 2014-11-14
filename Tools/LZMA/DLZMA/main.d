import std.stdio;
import std.file;

import DLZMA.LZMACompress;
import DLZMA.LZMADecompress;
import Stream.InStream;
import Stream.OutStream;

void main(string[] argv){
  writeln("Hello D-World!");
  byte[] bytesC = cast(byte[]) read("small_test.lzma");
  writeln(bytesC);

  InStream inputC = new InStream(bytesC);
  OutStream outputD = new OutStream();

  LZMADecompress.Decode(inputC, outputD);

  byte[] bytesD = outputD.getAllBytes();
  writeln(bytesD);
  std.file.write("small_test.txt", bytesD);

  InStream inputD = new InStream(bytesD);
  OutStream outputC = new OutStream();

  LZMACompress.Encode(inputD, outputC);
  byte[] bytesCNew = outputC.getAllBytes();
  writeln(bytesCNew);
  std.file.write("small_test_new.lzma", bytesCNew);
}
