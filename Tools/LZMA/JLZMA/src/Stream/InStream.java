// Stream.InStream.java
package Stream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class InStream {
  final byte[] _data;
  int _offset = 0;
  int _length = 0;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public InStream (byte[] buffer) {
    this._data = buffer;
    this._length = buffer.length;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public int read() {
    if (this._offset >= this._length) {
      return -1;
    }
    return (int)(this._data[this._offset++] & 0xff);
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public int read(byte[] buffer, int offset, int size) {
    if (this._offset >= this._length) {
      return -1;
    }

    int len = Math.min(size, this._length - this._offset);
    for (int i = 0; i < len; ++i) {
      buffer[offset++] = this._data[this._offset++];
    }

    return len;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public int length() {
    return this._length;
  }
}