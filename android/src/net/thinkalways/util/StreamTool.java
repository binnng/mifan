package net.thinkalways.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class StreamTool {	
	public static byte[] read(InputStream inputStream) throws IOException{
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[2048];
		int len = 0;
		while( (len = inputStream.read(buffer)) != -1){
			outStream.write(buffer, 0, len);
		}
		inputStream.close();
		return outStream.toByteArray();
		
	}
}
