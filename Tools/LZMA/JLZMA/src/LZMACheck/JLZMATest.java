package LZMACheck;

import java.nio.file.Files;
import java.nio.file.Paths;
import JLZMA.LZMACompress;
import JLZMA.LZMADecompress;
import Stream.InStream;
import Stream.OutStream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class JLZMATest {
  
  public static void main(String[] args) throws Exception {
    System.out.println("Hello Java-World!");
    byte[] bytesC = Files.readAllBytes(Paths.get("small_test.lzma"));
    for (int i = 0; i < bytesC.length; i++) {
      System.out.printf("%d ", bytesC[i]);
    }
    System.out.printf("\n");

    InStream inputC = new InStream(bytesC);
    OutStream outputD = new OutStream();

    LZMADecompress.Decode(inputC, outputD);
    
    byte[] bytesD = outputD.getAllBytes();
    for (int i = 0; i < bytesD.length; i++) {
      System.out.printf("%d ", bytesD[i]);
    }
    System.out.printf("\n");
    Files.write(Paths.get("small_test.txt"), bytesD);
    
    InStream inputD = new InStream(bytesD);
    OutStream outputC = new OutStream();
    
    LZMACompress.Encode(inputD, outputC);
    byte[] bytesCNew = outputC.getAllBytes();
    for (int i = 0; i < bytesCNew.length; i++) {
      System.out.printf("%d ", bytesCNew[i]);
    }
    System.out.printf("\n");
    Files.write(Paths.get("small_test_new.lzma"), bytesCNew);
  }
}
