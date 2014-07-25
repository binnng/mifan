package us.mifan.app.bean;

import java.io.Serializable;

/**
 * 接口URL实体类
 * 定义所有api的URL地址
 *
 * @author xie.hj
 * @version 0.1
 *
 */
public class URLs implements Serializable {
	public final static String HOST = "mifan.us";	
	public final static String HTTP = "http://";
	public final static String HTTPS = "https://";
	
	private final static String URL_SPLITTER = "/";
	private final static String API_PATH = "service/index.php";
	
	public final static String LOGIN_HTTP = HTTP + HOST + URL_SPLITTER + API_PATH + URL_SPLITTER + "user/usersession/user";
	public final static String LOGIN_HTTPS = HTTPS + HOST + URL_SPLITTER + API_PATH + URL_SPLITTER + "user/usersession/user";
	
	//http://www.mifan.us/service/index.php/user/userinfo/user/id/1
	public final static String TEST_URL = HTTP + HOST + URL_SPLITTER + API_PATH + URL_SPLITTER + "user/userinfo/user/id/1";

}
