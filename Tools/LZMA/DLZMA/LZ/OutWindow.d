// LZ.OutWindow.d
module LZ.OutWindow;


import Stream.OutStream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class OutWindow {

  private byte[] _buffer;
  private int _pos;
  private int _windowSize = 0;
  private int _streamPos;
  private OutStream _stream;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void Create(int windowSize) {
    if (_buffer == null || _windowSize != windowSize) {
      _buffer = new byte[windowSize];
    }
    _windowSize = windowSize;
    _pos = 0;
    _streamPos = 0;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void SetStream(OutStream stream) {
    ReleaseStream();
    _stream = stream;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void ReleaseStream() {
    Flush();
    _stream = null;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void Init(bool solid) {
    if (!solid) {
      _streamPos = 0;
      _pos = 0;
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void Flush() {
    int size = _pos - _streamPos;
    if (size == 0) {
      return;
    }
    _stream.write(_buffer, _streamPos, size);
    if (_pos >= _windowSize) {
      _pos = 0;
    }
    _streamPos = _pos;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void CopyBlock(int distance, int len) {
    int pos = _pos - distance - 1;
    if (pos < 0) {
      pos += _windowSize;
    }
    for (; len != 0; len--) {
      if (pos >= _windowSize) {
        pos = 0;
      }
      _buffer[_pos++] = _buffer[pos++];
      if (_pos >= _windowSize) {
        Flush();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void PutByte(byte b) {
    _buffer[_pos++] = b;
    if (_pos >= _windowSize) {
      Flush();
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public byte GetByte(int distance) {
    int pos = _pos - distance - 1;
    if (pos < 0) {
      pos += _windowSize;
    }
    return _buffer[pos];
  }
}