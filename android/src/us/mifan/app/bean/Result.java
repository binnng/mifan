package us.mifan.app.bean;

import java.io.IOException;
import java.io.InputStream;

import net.thinkalways.util.StreamTool;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * 结果实体类
 *
 * @author xie.hj
 *
 */
public class Result {
	
	private String ret;
	private String msg;
	private JSONObject result;

	public static Result parse(InputStream inputStream) throws IOException, JSONException{
		Result res = new Result();
		byte[] data = null;
		
		data = StreamTool.read(inputStream);
		String json = new String(data);
		JSONObject jsonObject = new JSONObject(json);
		
		res.ret = jsonObject.getString("ret");
		res.msg = jsonObject.getString("msg");
		
		if(!"100000".equals(res.ret)){
			res.result = jsonObject.getJSONObject("result");
		}else{
			res.result = null;
		}
		
		return res;	
	}

	public String getRet() {
		return ret;
	}

	public String getMsg() {
		return msg;
	}

	public JSONObject getResult() {
		return result;
	}
	
	
}
